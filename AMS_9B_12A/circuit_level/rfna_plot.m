function varargout = rfna_plot(varargin)
% RFNA_PLOT Application M-file for rfna_plot.fig
%    FIG = RFNA_PLOT launch rfna_plot GUI.
%    RFNA_PLOT('callback_name', ...) invoke the named callback.

% Last Modified by GUIDE v2.0 07-May-2002 18:01:31

if nargin == 0  % LAUNCH GUI

	fig = openfig(mfilename);  % no 'reuse'
   % set(fig,'Color',get(0,'defaultUicontrolBackgroundColor'));
    handles = guihandles(fig);
    figure(fig);
	% Generate a structure of handles to pass to callbacks, and store it. 

    handles.Zo=50;
    handles.smith = smith_chart('draw',...
                                [5 10 20 30 50 75 100 150 200 300 500]/handles.Zo,...
                                [5 10 20 30 50 75 100 150 200 300 500]/handles.Zo,...
                                handles.Zo,...
                                get(handles.axes1,'position'),handles.rfna_plot);  % place on top of existing axis
    
                            
    handles.polar = line('color',[0 1 0],'parent',handles.smith,'visible','off','xdata',[],'ydata',[]);
                        
    set(handles.axes1,'color','none'); % this eventually ends up on top and must be transparent to show 
                                       % smith chart coordinates below 
                             
    vis='off';
    set(handles.smith,'visible',vis);
    set(get(handles.smith,'children'),'visible',vis);
    handles.line    = line('color',[0 1 0],'parent',handles.axes1,'linewidth',2);
    handles.overlay = line('color',[0 1 1],'parent',handles.axes1,'visible','off');
    
    
    CLWc   = 20;   % Cursor Label width
    CROWc  = 70;   % Cursor readout width
    MKWc   = 38;   % Mark button width 
    CURDXc = 8;
    HTXTc  = 20;
       
    y  = 40;       % position in pixels
    x  = 20;       
        
          positions = [x+0.2*CURDXc+MKWc                             y          CLWc   HTXTc; % x label
                       x+0.2*CURDXc+MKWc                             y-HTXTc    CLWc   HTXTc; % y label
                       x+CLWc+0.2*CURDXc+MKWc                        y          CROWc  HTXTc; % x readout
                       x+CLWc+CROWc+CURDXc+0.2*CURDXc+MKWc           y          CROWc  HTXTc; % x expand
                       x+CLWc+0.2*CURDXc+MKWc                        y-HTXTc    CROWc  HTXTc; % y readout
                       x+CLWc+CROWc+CURDXc+0.2*CURDXc+MKWc           y-HTXTc    CROWc  HTXTc; % y expand
                       x                                             y          HTXTc  HTXTc; % peak button
                       x+HTXTc                                       y          HTXTc  HTXTc; % valley button
                       x+0.1*CURDXc                                  y-HTXTc    MKWc   HTXTc];% mark button
                 
      curcol=[0 0  1];                           
      colors    =  [1 1 1;   % label color
                    1 1 0;   % readout color (zeros means track line color)
                    0 0 1;   % expansion box color
                    1 1 0;   % mark line color
                    1 0 0;   % cursor color line 1
                    0 0 1];  %                   
      format_s  = ['%8.5f';'%8.5f'];  % formats for x and y related readouts
      font_size = 12;
      handles.cursor_id = add_cur(handles.axes1,'init',positions,colors,['X:';'Y:'],...
                                            ['x';'+'],font_size,format_s,'on');         
      
      add_cur(handles.cursor_id,'set','axis_cb','rfna_plot(''axis_synch'',gcbo,[],guidata(gcbo))');        
      
      guidata(fig, handles);

	if nargout > 0
		varargout{1} = fig;
	end

elseif ischar(varargin{1}) % INVOKE NAMED SUBFUNCTION OR CALLBACK

	try
		if (nargout)
			[varargout{1:nargout}] = feval(varargin{:}); % FEVAL switchyard
		else
			feval(varargin{:}); % FEVAL switchyard
		end
	catch
		disp(lasterr);
	end
end

function varargout = plot_data(h, data, handles, varargin)
         handles.data = data;
         switch data.name
            case {'s11','s22'}
                % create a list for the display popup
                s={'Smith','Zin','vswr','return loss'};
            case {'s21','s12'}
                s={'dB mag','phase','polar'};                
         end;   
         set(handles.display,'string',s,'value',1);
         guidata(handles.rfna_plot, handles);
         display_Callback(h,[],handles,varargin);

  function varargout = axis_synch(h,data, handles, varargin)
            set(handles.smith,'xlim',get(handles.axes1,'xlim'),'ylim',get(handles.axes1,'ylim'));
           
            
  function  varargout = smith_cursor(h,data, handles, varargin)
         % cursor for smith chart aux readout
         [xy,index] = add_cur(handles.cursor_id,'get','position');
         [number,h_line]=add_cur(handles.cursor_id,'get','active_line');
         data = get(h_line,'userdata');  % need for freq info 
         x=xy(1); y=xy(2);
         z  = handles.Zo*(1+(x+j*y))/(1-(x+j*y));
         rs = real(z);
         xs = imag(z);
         index=min(length(data.freq),index);
         f  = data.freq(index);
         set(handles.aux_ro,'string',sprintf(' F=%8.2f MHz R=%4.1f ohms  X=%4.1f ohms',f,rs,xs));
         mag=abs(x+j*y);
         set(handles.aux_r2,'string',sprintf(' Radius= %5.3f Angle=%6.1f  VSWR=%4.2f', mag, (180/pi)*atan2(y,x), (1+mag)/(1-mag)));

         
function  varargout = xfer_cursor(h,data, handles, varargin)
         % cursor for xfer function (s12,s21) aux readout
         [xy,index] = add_cur(handles.cursor_id,'get','position');
         [number,h_line]=add_cur(handles.cursor_id,'get','active_line');
         data = get(h_line,'userdata');  % this real and imaginary format
         set(handles.aux_ro,'string',sprintf(' Mag= %8.6f   Phase=%6.1f ',20*log10(sqrt(data.real(index)^2+data.imag(index)^2)),(180/pi)* atan2(data.imag(index),data.real(index))));
         set(handles.aux_r2,'string','');
% --------------------------------------------------------------------
function varargout = Overlay_Callback(h, eventdata, handles, varargin)
        if strcmp(get(handles.overlay,'visible'),'on')
            set(handles.overlay,'visible','off');
        else
             set(handles.overlay,'visible','on','xdata',...
                 get(handles.line,'xdata'),'ydata',get(handles.line,'ydata'),...
                 'userdata',get(handles.line,'userdata'));
         end;

% --------------------------------------------------------------------
function varargout = display_Callback(h, eventdata, handles, varargin)
                data=handles.data;
                switch data.name
                case {'s11','s22'}
                
                                      
                    set(handles.line,'xdata', data.real, 'ydata',data.imag,'userdata',data);
                    set(handles.axes1,'xlim',get(handles.smith,'xlim'),'ylim',get(handles.smith,'ylim'),...
                                     'xgrid','off','ygrid','off','xcolor',[0 0 0],'ycolor',[0 0 0]);
                    set(get(handles.axes1,'xlabel'),'string','Real');set(get(handles.axes1,'ylabel'),'string','Imag');
                    set(handles.smith,'visible','on');
                    set(get(handles.smith,'children'),'visible','on');
                    add_cur(handles.cursor_id,'set','move_cb','rfna_plot(''smith_cursor'',gcbo,[],guidata(gcbo))');
                case  {'s12','s21'}
                    set(handles.smith,'visible','off');
                    set(get(handles.smith,'children'),'visible','off');
                    set(handles.aux_r2,'visible','off');

                    set(handles.line,'xdata', data.freq, 'ydata', 10*log10(data.real.^2+data.imag.^2),'userdata',data);
                    set(handles.axes1,'xlim',[data.freq(1),data.freq(end)],'ylimmode','auto',...
                                      'xgrid','on','ygrid','on','xcolor',[1 1 1],'ycolor',[1 1 1]); 
                    set(get(handles.axes1,'xlabel'),'string','MHz');set(get(handles.axes1,'ylabel'),'string','dB');
                    add_cur(handles.cursor_id,'set','move_cb','rfna_plot(''xfer_cursor'',gcbo,[],guidata(gcbo))');
                end;


                
                
function out1 = smith_chart(Action,In1,In2,In3,In4,In5) 
% function out1 = smith_chart(Action,In1,In2,In3,In4)
% Action = 'draw'
%    In1 = [rvalues];
%    In2 = [xvalues];
%    In3 = Zo of line (optional)
%    In4 = position   (optional)
%    In5 = parent figure handle

    NSEGSc = 63;
    if strcmp(Action,'draw')
        if nargin <=3
            Zo = 50;
        else
            Zo = In3;
        end;
        figure(In5)
        if nargin <=4
           out1=axes('box','off','xgrid','off','ygrid','off','zgrid','off',...
                     'color','none','nextplot','add','visible','off','parent',In5);
        else
           out1=axes('Units','pixels','position',In4,'box','off','xgrid','off','ygrid','off','zgrid','off',...
                     'color','none','nextplot','add','visible','off', 'parent',In5);
        end;
        set(out1,'xlim',[-1.1 1.1],'ylim',[-1.1,1.1]);
        xlabel('');
        ylabel('');
        theta = linspace(-pi, pi, NSEGSc);
        
        for r=(In1)
           z     =((r/(r+1) + 1/(r+1)*exp(j*theta)));
           line('xdata',real(z),'ydata',imag(z),'color',[0.5 0.5 0]);
           xpos = (r-1)/(r+1);
            h=text(xpos, 0, ftoa('%4w',r*Zo));
            % h=text(xpos, 0, sprintf('%4.1f',r*Zo));
           set(h, 'VerticalAlignment', 'top', 'HorizontalAlignment', 'right','color',[1 1 1]);
        end;
        
        % draw unit circle , and imag==0 line 
        z = exp(j*theta);
        line('xdata',real(z),'ydata',imag(z),'color',[1 1 0]);
        line('xdata',[-1 1],'ydata',[0 0],'color',[1 1 0]);
        
        v = linspace(0,10,NSEGSc);
        r = [ 0 v.^2];
        
        for x = In2
            z = r+j*x*ones(1,NSEGSc+1);
            g = (z-1)./(z+1);
            line('xdata',real(g),'ydata', imag(g), 'color',[0 0.5 0.5]);
            line('xdata',real(g),'ydata',-imag(g), 'color',[0 0.5 0.5]);
            
            g= ((j*x-1)/(j*x+1));
            xpos = real(g);
            ypos = imag(g);
            
            s = ftoa('%4w',Zo*x);
            h=text([xpos xpos], [ypos -ypos], [' j' s ; '-j' s]);
            set(h(1),'VerticalAlignment', 'bottom','color',[1 1 1]);
            set(h(2),'VerticalAlignment', 'top','color',[1 1 1]);
            if xpos == 0 
               set(h, 'Horizontalalignment', 'center');
            elseif xpos < 0
               set(h, 'Horizontalalignment', 'right');
            end
        end;
        rmin = min(In2);
        rmax = max(In2);
        line('xdata',[(rmin-1)/(rmin+1),(rmax-1)/(rmax+1)],'ydata',[0 0],'color',[1 1 0]);

    else
    
    end;
        
% end; 




