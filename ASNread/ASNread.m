function [DNAdata_gbank, varargout] = ASNread(file)
%ASNread - Reads in ASN.1 format data files
%    DATA =ASNread(FILENAME) reads in the ASN.1 
%    formatted sequence entry file, from FILENAME.
%    DATA is a structure containing these fields:
%       LocusName 
%       LocusSequenceLength
%       LocusMoleculeType
%       LocusGenBankDivision
%       LocusModificationDate
%       Definition
%       Accession
%       Version
%       GI
%       Keywords
%       Segment
%       Source
%       SourceOrganism
%       Reference.Number
%       Reference.Authors
%       Reference.Title
%       Reference.Journal
%       Reference.MedLine
%       Reference.PubMed
%       Reference.Remark
%       Comment
%       Features 
%       BaseCount
%       Sequence
%    To view the raw data aquired from the ASN.1 file,
%    specify an extra output argument.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%ERROR CHECKING
if ~isstr(file), error('The input argument must be a string.'); end

if nargout > 2, error('Too many output arguments.'); end

[status msg] = fopen(file,'r');

if ~isempty(msg), error(msg); end

fclose(status);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%IMPORTING DATA FROM FILE
DNAdata = [];
all_word = {};
current_structure = [];

all_row = textread(file,'%s','delimiter','\n');
temp_word = textread(file,'%s','delimiter',' ');

%adding space to end of each word
for a = 1:length(temp_word), temp_word{a}(end+1)= ' '; end

%creating cell array of each word in file
n = 0;
for i=1:length(all_row)
    t = isspace(all_row{i});
    t2 = [0,t(1:end-1)];
    t3 = t+t2;
    double_spaces = length(find(t3 == 2));
    Num_words(i) = length(find(t))+1-double_spaces;
    [all_word{i,1:Num_words(i)}]=deal(temp_word{n+1:n+Num_words(i)});
    
    n = n + Num_words(i);
end
clear temp_word n;

[DNAdata_raw,DNAdata_gbank] = CreateStructure(all_row, all_word, Num_words', current_structure);

if nargout == 2
    varargout{1} = DNAdata_raw;
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%CONFIGURING THE IMPORTED DATA
function [data_structure,gbank_struct] = CreateStructure(all_row, all_word, Num_word, data_structure)

%Defining GENBANK structure
gbank_struct.LocusName = [];
gbank_struct.LocusSequenceLength = [];
gbank_struct.LocusMoleculeType = [];
gbank_struct.LocusGenBankDivision = [];
gbank_struct.LocusModificationDate = [];
gbank_struct.Definition = [];
gbank_struct.Accession = [];
gbank_struct.Version = [];
gbank_struct.GI = [];
gbank_struct.Keywords = [];
gbank_struct.Segment = [];
gbank_struct.Source = [];
gbank_struct.SourceOrganism = [];
gbank_struct.Reference.Number = [];
gbank_struct.Reference.Authors = [];
gbank_struct.Reference.Title = [];
gbank_struct.Reference.Journal = [];
gbank_struct.Reference.MedLine = [];
gbank_struct.Reference.PubMed = [];
gbank_struct.Reference.Remark = [];
gbank_struct.Comment = [];
gbank_struct.Features  = [];
gbank_struct.BaseCount = [];
gbank_struct.Sequence = [];

L = length(all_row); %how many rows

current_row_num = 2;
current_field = '';
balance_up = 0;
balance_down = 0;
while current_row_num <= L    

    current_row = all_row{current_row_num};
    down_field = findstr(current_row,'{');
    up_field = findstr(current_row,'}');
    
    if ~isempty(down_field) % if a { is found, update the current field ...
        
        if isempty(findstr(all_word{current_row_num, 1}, '{ '))
            current_field = go_up_field(current_field, all_word{current_row_num, 1});
        else %only a { is on the line
            balance_up = balance_up+1;
        end
        
        current_row_num = current_row_num+1; 
                
    else %if both { and } are NOT present or if only } is found, update current field and add data ...    
        
        if ~isempty(findstr(all_word{current_row_num, Num_word(current_row_num)}, ', ')) %if line ends in ',' 
        
            if (Num_word(current_row_num) - length(up_field) - 1) ~= 1 %if there is more than one word on the line
            
                if ~isempty(findstr(all_word{current_row_num,1},'"')) %if first word starts with "
                    data = strrep([all_word{current_row_num,1:Num_word(current_row_num)-1}],'"','');
                    data_structure = MakeField(data_structure, current_field, data);
                    gbank_struct = MapIt(data_structure, current_field, gbank_struct);
                else %normal case with field name and data
                    current_field = go_up_field(current_field, all_word{current_row_num, 1});
                    data = strrep([all_word{current_row_num,2:Num_word(current_row_num)-1}],'"','');
                    data = strrep(data,'} ','');
                    data_structure = MakeField(data_structure, current_field, data); 
                    gbank_struct = MapIt(data_structure, current_field, gbank_struct);
                    current_field = go_down_field(current_field);
                end
                
            else %there is only one word not including } or , on the line (ie: only data is on the line)
                
                if ~isempty(findstr(all_word{current_row_num,1},'"')) %if first word starts with "
                    data = strrep([all_word{current_row_num,1}],'"','');
                    data_structure = MakeField(data_structure, current_field, data);
                    gbank_struct = MapIt(data_structure, current_field, gbank_struct);
                end
                
            end
            
            if ~isempty(up_field) % if a } is found, update the field ...
                for g = 1:length(up_field)-balance_up-balance_down
                    current_field = go_down_field(current_field);
                end
                balance_up = 0;
                balance_down = 0;
            end
            
            current_row_num = current_row_num+1;
            
        elseif Num_word(current_row_num) == 1 %if there is only a single word on the line, update the field
            current_field = go_up_field(current_field, all_word{current_row_num, 1});
            balance_down = balance_down-1;
            
            current_row_num = current_row_num+1;
            
        else %if the last word is not a ',' then the data wraps to the next line or it is EOF
            
            if ~isempty(up_field), break %if } is present and no ',', then EOF is reached
            else
                data_row = current_row_num;
                n=3; x = 1; data_temp = all_word{data_row,2};

                while x~=0
                    data_temp = [data_temp all_word{data_row,n:Num_word(data_row)}];
                    quotes = findstr(data_temp,'''');
                    quotes2 = findstr(data_temp,'"');
                    
                    if length(quotes) > 1, x=0; end  %checking for 2 quotes
                    if length(quotes2) > 1, x=0; end %checking for 2 double quotes
                    data_row = data_row+1;
                    n = 1;
                end
                
                data = strrep(data_temp(1:end-4), '"','');
                data = strrep(data, '''','');               
                current_field = go_up_field(current_field, all_word{current_row_num, 1});
                data_structure = MakeField(data_structure, current_field, data); 
                gbank_struct = MapIt(data_structure, current_field, gbank_struct);
                current_field = go_down_field(current_field);
                
                current_row_num = data_row;
            end
        end 
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%CREATE THE FULL FIELD NAME
function new_field = go_up_field(current_field, field)

new_field = strcat([current_field '.' field]);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%GO BACK ONE FIELD FROM THE FULL FIELD NAME
function new_field = go_down_field(current_field)

dot = findstr(current_field, '.');
if ~isempty(current_field)
    new_field = current_field(1:dot(end)-1);
else 
    new_field = '';
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%USING THE FULL FIELD NAME TO CREATE FIELD IN STRUCTURE AND ADD DATA
function data_structure = MakeField(current_structure, current_field, data)

data_structure = current_structure;

if ~isempty(data)
    eval(['data_structure', sprintf(strrep(current_field, '-','_')), '=', '''', sprintf(strrep(data,'''','')), '''', ';']);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%MAPPING RAW DATA STRUCTURE TO GENBANK STYLE STRUCTURE
function gbank_struct = MapIt(current_structure, current_field, gbank_struct)

dot = findstr(current_field, '.');
if length(dot) > 3
    field = strrep(current_field(dot(end-3)+1:end),'-','_');
elseif length(dot) > 2
    field = strrep(current_field(dot(end-2)+1:end),'-','_');
elseif length(dot) == 2
    field = strrep(current_field(dot(end-1)+1:end),'-','_');
else
    return
end

    %SEQUENCE
if ~isempty(findstr(lower(field),'inst.seq_data.ncbi2na')) | ~isempty(findstr(lower(field),'inst.seq_data.iupacna'))
    if isempty(gbank_struct.Sequence)
        gbank_struct.Sequence = strrep(eval(['current_structure' strrep(current_field, '-','_')]),' ',sprintf('\n'));
    end
    
    %LOCUS GENBANK DIVISION
elseif ~isempty(findstr(lower(field),'org.orgname.div')) | ~isempty(findstr(lower(field),'genbank.div'))
    if ~isempty(findstr(lower(field),'genbank.div'))
        gbank_struct.LocusGenBankDivision = eval(['current_structure' strrep(current_field, '-','_')]);
    elseif isempty(gbank_struct.LocusGenBankDivision)
        gbank_struct.LocusGenBankDivision = eval(['current_structure' strrep(current_field, '-','_')]);
    end
    
    %LOCUS NAME
elseif ~isempty(findstr(lower(field),'id.genbank.name'))
    gbank_struct.LocusName = eval(['current_structure' strrep(current_field, '-','_')]);
    
    %LOCUSE MOLECULE TYPE
elseif ~isempty(findstr(lower(field),'molinfo.biomol')) 
    if isempty(gbank_struct.LocusMoleculeType)
        gbank_struct.LocusMoleculeType = eval(['current_structure' strrep(current_field, '-','_')]);
    end
    
    %LOCUS SEQUENCE LENGTH
elseif ~isempty(findstr(lower(field),'inst.length'))  
    if isempty(gbank_struct.LocusSequenceLength)
        gbank_struct.LocusSequenceLength = eval(['current_structure' strrep(current_field, '-','_')]);
    end
    
    %ACCESSION
elseif ~isempty(findstr(lower(field),'id.genbank.accession'))   
    if isempty(gbank_struct.Accession)
        gbank_struct.Accession = eval(['current_structure' strrep(current_field, '-','_')]);
    end
    
    %VERSION
elseif ~isempty(findstr(lower(field),'id.genbank.version')) 
    gbank_struct.Version = eval(['current_structure' strrep(current_field, '-','_')]);
    
    %GI
elseif ~isempty(findstr(lower(field),'seq.id.gi')) 
    if isempty(gbank_struct.GI)
        gbank_struct.GI = eval(['current_structure' strrep(current_field, '-','_')]);
    end
    
    %DEFINITION
elseif ~isempty(findstr(lower(field),'descr.title')) 
    gbank_struct.Definition = eval(['current_structure' strrep(current_field, '-','_')]);
    
    %SOURCE
elseif ~isempty(findstr(lower(field),'source.org.common'))  
    gbank_struct.Source = eval(['current_structure' strrep(current_field, '-','_')]);
    
    %SOURCE ORGANISM
elseif ~isempty(findstr(lower(field),'source.org.taxname')) 
    gbank_struct.SourceOrganism{1} = eval(['current_structure' strrep(current_field, '-','_')]);
elseif ~isempty(findstr(lower(field),'org.orgname.lineage')) 
    gbank_struct.SourceOrganism{2} = eval(['current_structure' strrep(current_field, '-','_')]);
    
    %COMMENT
elseif ~isempty(findstr(lower(field),'descr.comment')) 
    gbank_struct.Comment = eval(['current_structure' strrep(current_field, '-','_')]);
    
    %KEYWORDS
elseif ~isempty(findstr(lower(field),'keywords')) 
    gbank_struct.Keywords = eval(['current_structure' strrep(current_field, '-','_')]);
    
    %DATE
elseif ~isempty(findstr(lower(field),'update_date.std.year'))
    if isempty(gbank_struct.LocusModificationDate)
        gbank_struct.LocusModificationDate = eval(['current_structure' strrep(current_field, '-','_')]);
    end
elseif ~isempty(findstr(lower(field),'update_date.std.month')) 
    if length(gbank_struct.LocusModificationDate) >= 12, break, end
    gbank_struct.LocusModificationDate = [eval(['current_structure' strrep(current_field, '-','_')]) '- '...
            gbank_struct.LocusModificationDate];
elseif ~isempty(findstr(lower(field),'update_date.std.day'))
    if length(gbank_struct.LocusModificationDate) >= 12, break, end
    gbank_struct.LocusModificationDate = [eval(['current_structure' strrep(current_field, '-','_')]) '- '...
            gbank_struct.LocusModificationDate];
        
    %REFERENCES

end