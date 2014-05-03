function printmif(file,size,font,fig)
%printmif(file,size,font,fig) Print graph to an Adobe Illustrator file 
% and then use ai2mif to convert it to FrameMaker MIF format.
% ai2mif is a slightly modified version of the function of the same name
% provided by Deron Jackson <djackson@mit.edu>.

path = which(mfilename);
ai2mifpath = [ path(1:max(find(path=='/'))) 'ai2mif '];
if nargin<4
    fig = gcf;
    if nargin<3
	font = [];
	if nargin<2
	    size = [];
	    if nargin<1
		file = 'matlab';
	    end
	end
    end
end

if ~isempty(font)
    fontsize = str2num(font(font<59));	% Numerical portion
    fontname = font(font>58);		% Alphabetical portion
    children = get(fig,'Children');
    set(children, 'FontName',fontname, 'FontSize',fontsize);
%    for i = 1:length(children)
%    	kids = get(children(i),'Children');
%	set(kids,'FontName',font); set(kids,'FontSize',fontsize);
%    end
end

if ~isempty(size)
    set(fig,'PaperUnits','inches','PaperPosition', [0.5 0.5 0.5+size]);
end
eval( ['print -dill -f' num2str(fig) ' ' file '.ai'] );
temp = cd;                              % Get the current directory
tmp = [ai2mifpath temp '/' file '.ai ' temp '/' file '.mif > /dev/null'];
eval(['!' tmp]);                        % Execute AI2MIF
eval(['! rm ' temp '/' file '.ai']);    % Delete the AI file
