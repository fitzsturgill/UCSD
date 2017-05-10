function [cfun gof coeff] = fitHrf(c,r,bPlot)
% function [cfun gof coeff] = fitHrf(c,r,bPlot)
%
% INPUT
%   r: Response values
%   c: Input values (e.g. contrast)
%   bPlot: Flag for plotting

% Created: SRO - 6/9/11


if nargin < 3 || isempty(bPlot)
    bPlot = 0;
end

% Verify column vectors
if size(r,2) > 1
    r = r';
end
if size(c,2) > 1
    c = c';
end

% Determine starting values
a0 = min(r);                % offset
b0 = max(r) - min(r);       % rmax
n0 = 1;                     % "shape"
c0 = 0.2;                   % c50

% Make fittype object
f = fittype('a+b*((x^n)/((x^n)+(c^n)))');
options = fitoptions(f);
set(options,'StartPoint',[a0; b0; c0; n0;]);
set(options,'Lower',[a0-2*b0; 0.5*b0; 0.1*c0; 0]);
set(options,'Upper',[2*a0; 3*b0; max(c); 10]);
set(options,'MaxFunEvals',2000);

% Fit data
[cfun gof] = fit(c,r,f,options);

% Extract coefficients
coeff = coeffvalues(cfun)';

% Plot
if bPlot
    hfig = portraitFigSetup; set(hfig,'Position',[-660   560   483   376]);
    hax = axes;
    x = linspace(min([min(c) 0]),max(c),100);
    y = feval(cfun,x);
    hl(1) = line('XData',x,'YData',y,'Parent',hax);
    hl(2) = line('XData',c,'YData',r,'Parent',hax);
    set(hl(2),'Marker','o','Line','none');
end