function MotifInfo = gibbsmotifsampler(seqArray,motifVector,alphabet,Options)
%MOTIFINFO = GIBBSMOTIFSAMPLER(SEQARRAY,MOTIFVECTOR,ALPHABET,OPTIONS)
%Searches for the motifs in a set of sequences via Gibbs
%sampling.
%
%seqArray is a cell vector of sequence strings.
%
%motifVector is a vector of uniformly-spaced motif widths you wish to
%optimize. The program iterates over these widths, and returns the
%one that is the "best", according the technique described in Lawrence et
%al, Science, Vol. 262, No. 5131 pp. 208-214, 1993.
%
%alphabet is a string that denotes the alphabet you want to use. Use 'DNA'
%to use 'ATCG', or 'Protein' to use 'ARNDCEQGHILKMFPSTWYV'. You can enter
%one in of your choice as well.
%
%Options is the options structure, which has some nifty features. The
%fields are:
%
%   nTrials: The number of trials to perform for each motif alignment. The
%   more the better, but the longer it takes.
%
%   pcMode: A string, either 'Fraction' or 'Addition'. If you choose
%   'Fraction', a fractional amount of each residue from the background
%   will be used as the pseudocount. If you choose 'Addition', a static
%   amount will be used for the pseudocount.
%
%   pcVector: This is a scalar or vector quantity. This designates amount
%   to add to each residue for the pseudocount. If you enter a scalar, that
%   amount will be used for each residue in the alphabet. If you enter a
%   vector, the amounts will be dispersed according to the order the
%   characters are entered in your alphabet. For example, if you want to
%   use a pseudocount of 1% of the counts of all residue sequences, you
%   would choose pcMode as 'Fraction', and pcVector = 0.01. If you wanted
%   to add 25 to each count, you would enter pcMode as 'Addition', and
%   pcVector = 25.
%
%   nPhaseTrials: Increasing this quantity helps reduce the chance of being
%   caught in a local maximum. The higher it is, the better the search, but
%   the longer it takes.
%
%   nPhaseBand: This is how wide of a search range the sampler uses when
%   doing phase correction (as described in Lawrence's paper). I suggest a
%   value of 1/3 to 1/2 the length of your hypothesized motif.
%
%   If you omit the Options structure, the program will use these defaults:
%
%     nTrials = 500;
%     pcVector = 0.01;
%     pcMode = 'Fraction';
%     relativeTol = 0.01;
%     nTrials = 500;
%     nPhaseTrials = 50;
%     phaseBand = 25;
%
%The program returns a structure called MotifInfo, whose fields are:
%
%   MotifSites: This is the vector of motif positions.
%   BestMotifWidth: The best motif width.
%   MaxS: The maximum value of S; which is the information per parameter.
%   SVector: A vector of S values, corresponding to each motif width.
%   ExecutionTimes: Time elapsed for each tested motif width.
%
%Example:
%
% sequenceArray =
%
%     'ATCTCTGAGTCGCTATATCGCTCTCG'
%     'TCTCTGAGATCTCCGCGCTCTCGAGTGCGATATGC'
%     'TATCGCGCTATGCGCTATTATATCTCTG'
%     'CGGCGCTATCGGATATAGCGTA'
%     'TCTCTCGAGATCGATCGT'
%     'ATTCTCTATATATCTTATATTCTTATGAGAATCTAG'
%
% MotifInfo =
%
%         MotifSites: [6x1 double]
%     BestMotifWidth: 5
%              Motif: {6x1 cell}
%               MaxS: 1.4267
%            SVector: [3x1 double]
%     ExecutionTimes: [3x1 double]
%
% MotifInfo.MotifSites = [22 1 1 7 1 32]'
% MotifInfo.BestMotifWidth = 5
% MotifInfo.Motif =
%
%     'TCTCG'
%     'TCTCT'
%     'TATCG'
%     'TATCG'
%     'TCTCT'
%     'TCTAG'
%
%MotifInfo.MaxS = 1.4267
%MotifInfo.SVector =
%
%        1.4267
%        1.3362
%        1.1279
%
%(The execution times only really matter for your own computer.)
%
%There is some room for improvement in this program:
%
%1. The code isn't optimized; the execution time could be improve greatly.
%
%2. It is possible to modify the algorithm to search for multiple motifs -
%I am not just sure how to go about doing that.
%
%3. It is also possible to determine whether a detected motif is
%statistically significant or not - again, I'm just not sure how to do it.
%
%(c) May 6, 2010 Bradley James Ridder, University of South Florida, for Dr.
%Xiaoning Qian's Computational Molecular Biology Course, Spring 2010 term.

%Check that we have the right number of inputs, and allows for a default
%Options structure.
if nargin < 3
    error(...
        'gibbsmotifsampler requires at least 3 input arguments.')
end
if nargin == 3
    Options.nTrials = 500;
    Options.pcVector = 0.01;
    Options.pcMode = 'Fraction';
    Options.relativeTol = 0.01;
    Options.nTrials = 500;
    Options.nPhaseTrials = 50;
    Options.phaseBand = 25;
end

%Unpack the Options structure
nTrials = Options.nTrials;
phaseBand = Options.phaseBand;
relativeTol = Options.relativeTol;
nPhaseTrials = Options.nPhaseTrials;
A = getA(alphabet);
pcVector = getpcvector(seqArray,A,Options);

%Initializations
nSeqs = length(seqArray);
bgCounts = getcounts(seqArray,A);
bgFreqs = bgCounts/sum(bgCounts);
bestAlignmentScore = 0;
seqLengths = zeros(nSeqs,1);
for i = 1:nSeqs
    seqString = seqArray{i};
    seqLengths(i,1) = length(seqString);
end
S = zeros(length(motifVector),1);
time = S;
maxS = 0;

%Main loop. The sampler iterates over the motifVector, calculating values
%of S at each pass. The motif width that maximizes S is the optimum.
for mwIndex = 1:length(motifVector)
    tic
    motifWidth = motifVector(mwIndex);
    seqMaxes = seqLengths - motifWidth + 1;
    for trial = 1:nTrials
        motifSites = getrandomsites(seqArray,motifWidth);
        alignmentTol = relativeTol + 1;
        globalfScore = 1;
        while alignmentTol > relativeTol
            for zIndex = 1:nSeqs
                zSeq = seqArray{zIndex};
                %Cuts the chosen sequence out of seqArray and the position
                %vector.
                loopArray = seqArray;
                loopArray(zIndex) = [];
                loopSites = motifSites;
                loopSites(zIndex) = []; %loopSites has all the motif
                %sites EXCEPT the chosen one.
                
                %This code gets the motif from the chosen seq, and puts its
                %residues into the background residue counts. Then it calculates
                %the new background frequencies.
                loopMotif = cellstr(zSeq...
                    (motifSites(zIndex):motifSites(zIndex) + motifWidth - 1));
                loopMotifCounts = getcounts(loopMotif,A);
                loopbgCounts = bgCounts + loopMotifCounts;
                loopbgFreqs = ...
                    (loopbgCounts + pcVector)/(sum(loopbgCounts + pcVector));
                
                %Calculates the residue frequency (q) matrix, from all sequences
                %excluding the chosen sequences.
                loopMotifBlock = getmotif(loopArray,motifWidth,loopSites);
                loopProfile = buildprofile(loopMotifBlock,motifWidth,A);
                loopqMatrix = getqmatrix(loopProfile,motifWidth,pcVector,nSeqs);
                loopresIndices = parseseq(zSeq,A);
                pDist = ...
                    getpdist(loopresIndices,loopqMatrix,loopbgFreqs,motifWidth);
                newIndex = samplenewindex(pDist);
                motifSites(zIndex) = newIndex;
            end
            %This loop does the phase correction, to help the algorithm
            %escape from local optima.
            for pIndex = 1:nPhaseTrials
                %Randomly selects new motif positions over +/- the amount in
                %Options.phaseBand.
                phasemotifSites = ...
                    motifSites - phaseBand + 2*ceil(phaseBand*rand(nSeqs,1));
                %This loop makes sure the new positions are in the correct
                %domain.
                for k = 1:nSeqs
                    isBelow1 = phasemotifSites(k) < 1;
                    isAboveMax = phasemotifSites(k) > seqMaxes(k);
                    if isBelow1 == true
                        phasemotifSites(k) = 1;
                    elseif isAboveMax == true
                        phasemotifSites(k) = seqMaxes(k);
                    end
                end
                %Then just evaluate the new motif positions, taking the
                %best one.
                phaseMotif = getmotif(seqArray,motifWidth,phasemotifSites);
                phaseProfile = buildprofile(phaseMotif,motifWidth,A);
                phaseqMatrix = ...
                    getqmatrix(phaseProfile,motifWidth,pcVector,nSeqs);
                phasefScore = ...
                    fscore(phaseProfile,phaseqMatrix,bgFreqs,motifWidth,A);
                alignmentTol = (phasefScore - globalfScore) / globalfScore;
                if phasefScore > globalfScore
                    globalfScore = phasefScore;
                    motifSites = phasemotifSites;
                end
            end
        end
        %Saves the best-found motif sites by comparing to the bestAlignment
        %score.
        if globalfScore > bestAlignmentScore
            storedSites = motifSites;
            bestAlignmentScore = globalfScore;
        end
    end
    %This loop calculates the subtrahend in the equation given in the
    %references of Lawrence's aforementioned paper.
    %(c) May 6, 2010 Bradley James Ridder, University of South Florida, for Dr.
    %Xiaoning Qian's Computational Molecular Biology Course, Spring 2010 term.
    gSum = 0;
    for gIndex = 1:nSeqs
        Lprime = seqMaxes(gIndex); %Highest possible motif position 
                                   %in sequence i.

        %This code is puts the i'th motif's counts into the background.                    
        gArray = seqArray;        
        gSeq = seqArray{gIndex};
        gArray(gIndex) = [];
        gSites = motifSites;
        gSites(gIndex) = [];
        gMotifString = cellstr(...
            gSeq(motifSites(gIndex):motifSites(gIndex) + motifWidth - 1));
        gMotifCounts = getcounts(gMotifString,A);
        gbgCounts = bgCounts + gMotifCounts;
        gbgFreqs = (gbgCounts + pcVector) / sum(gbgCounts + pcVector);
        
        %This code is used to find the sampling weights.
        gMotifBlock = getmotif(gArray,motifWidth,gSites);
        gProfile = buildprofile(gMotifBlock,motifWidth,A);
        gqMatrix = getqmatrix(gProfile,motifWidth,pcVector,nSeqs);
        gresIndices = parseseq(gSeq,A);
        Y = getpdist(gresIndices,gqMatrix,gbgFreqs,motifWidth);
        
        %Now we can calculate the subtrahend.
        gSum = gSum + log(Lprime) + sum(Y.*log(Y));
    end
    %Subtract gSum from the best F value, and divide by the number of free
    %parameters. This yields S; the information per free parameter.
    S(mwIndex,1) = (bestAlignmentScore - gSum)/((length(A) - 1)*motifWidth);
    time(mwIndex,1) = toc;
    if S(mwIndex,1) > maxS
        maxS = S(mwIndex,1);
        maxmwIndex = mwIndex;
        maxSMotifSites = storedSites;
    end
end
MotifInfo.MotifSites = maxSMotifSites;
MotifInfo.BestMotifWidth = motifVector(maxmwIndex);
MotifInfo.Motif = getmotif(seqArray,motifVector(maxmwIndex),maxSMotifSites);
MotifInfo.MaxS = maxS;
MotifInfo.SVector = S;
MotifInfo.ExecutionTimes = time;

function newIndex = samplenewindex(pDist)
%Samples a new motif position from the probability mass function created by
%getpdist.
cdf = cumsum(pDist);
nMotifSites = length(pDist);
u = rand;
for i = 1:nMotifSites
    if u < cdf(i)
        newIndex = i;
        break
    else
    end
end

function F = fscore(seqProfile,qMatrix,bgFreqs,motifWidth,A)
%Calculates the alignment score, F.
%(c) May 6, 2010 Bradley James Ridder, University of South Florida, for Dr.
%Xiaoning Qian's Computational Molecular Biology Course, Spring 2010 term.
f = 0;
for i = 1:motifWidth
    for j = 1:length(A)
        f = f + seqProfile(j,i)*log(qMatrix(j,i)/bgFreqs(j));
    end
end
F = f;

function pDist = getpdist(resIndices,qMatrix,bgFreqs,motifWidth)
%Gets the probability distribution for sampling new motif positions.
nMotifSites = length(resIndices) - motifWidth + 1;
Ax = zeros(nMotifSites,1);
Qx = zeros(motifWidth,1);
Px = Qx;
for i = 1:nMotifSites
    for j = 1:motifWidth
        Qx(j,1) = qMatrix(resIndices(j + i - 1),j);
        Px(j,1) = bgFreqs(resIndices(j + i - 1));
    end
    Ax(i,1) = prod(Qx./Px);
end
pDist = Ax/sum(Ax);

function resIndices = parseseq(zSeq,A)
%Reads a sequence, returning a vector of numbers. These numbers are the indices
%of each character in the sequence, as they appear in the alphabet.
nMotifSites = length(zSeq);
indices = zeros(nMotifSites,1);
for i = 1:nMotifSites
    indices(i) = findstr(zSeq(i),A);
end
resIndices = indices;

function qMatrix = getqmatrix(seqProfile,motifWidth,pcVector,nSeqs)
%Returns the residue frequency matrix.
addedPC = seqProfile + repmat(pcVector,1,motifWidth);
B = sum(pcVector);
qMatrix = addedPC/(nSeqs - 1 + B);

function motif = getmotif(seqArray,motifWidth,motifSites)
%Returns a cell vector of strings which corresponds to the motifs in each
%sequence.
nSeqs = length(seqArray);
seqChainLengths = ones(nSeqs,1);
for i = 1:nSeqs
    seqChainLengths(i) = length(seqArray{i});
end
charBlock = char(ones(nSeqs,motifWidth));
charConversion = char(seqArray);
for i = 1:nSeqs
    charBlock(i,:) = ...
        charConversion(i,motifSites(i):(motifSites(i) + motifWidth - 1));
end
motif = cellstr(charBlock);

function seqProfile = buildprofile(motif,motifWidth,A)
%Gets the sequence profile for a cell vector of strings that contains the
%motifs in each sequence.
ALength = length(A);
seqProfile = zeros(ALength,motifWidth);
charMotif = char(motif);
for i = 1:motifWidth
    currentColumn = cellstr(charMotif(:,i));
    seqProfile(:,i) = getcounts(currentColumn,A);
end

function pcVector = getpcvector(seqArray,A,Options)
%Creates the pseudocount vector.
ALength = length(A);
pcMode = Options.pcMode;
pcVector = Options.pcVector;
useAddition = strcmp('Addition',pcMode);
useFraction = strcmp('Fraction',pcMode);
if (useAddition == true) && (isscalar(pcVector) == true)
    pcVector = repmat(pcVector,ALength,1);
elseif (useAddition == true) && (isscalar(pcVector) == false)
end
counts = getcounts(seqArray,A);
if (useFraction == true) && (isscalar(pcVector) == true)
    pcVector = pcVector*counts;
elseif (useFraction == true) && (isscalar(pcVector) == false)
    pcVector = pcVector.*counts;
end

function counts = getcounts(seqArray,A)
%Gets the raw counts from a cell array of strings, for the given alphabet.
nSeqs = length(seqArray);
nResidues = length(A);
resCounts = zeros(nResidues,1);
for i = 1:nSeqs
    seqLength = length(seqArray{i});
    seq = seqArray{i};
    for j = 1:seqLength
        for k = 1:nResidues
            if strcmp(seq(j),A(k)) == true
                resCounts(k) = resCounts(k) + 1;
            end
        end
    end
end
counts = resCounts;

function A = getA(alphabet)
%Gets the alphabet.
useDNA = strcmp('DNA',alphabet);
useProtein = strcmp('Protein',alphabet);
if useDNA == true
    A = 'ATCG';
elseif useProtein == true
    A = 'ARNDCEQGHILKMFPSTWYV';
else
    A = alphabet;
end

function motifSites = getrandomsites(seqArray,motifWidth)
%This function gets a random vector of motif sites, over the allowable
%domain.
nSeqs = length(seqArray);
motifA = zeros(nSeqs,1);
for i = 1:nSeqs
    x = seqArray{i};
    seqLength = length(x);
    motifA(i,1) = seqLength - motifWidth + 1;
end
motifSites = ceil(rand(nSeqs,1).*motifA);
%(c) May 6, 2010 Bradley James Ridder, University of South Florida, for Dr.
%Xiaoning Qian's Computational Molecular Biology Course, Spring 2010 term.