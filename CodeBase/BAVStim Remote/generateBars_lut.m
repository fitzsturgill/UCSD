function [img lut]= generateBars_lut(orient,freq,speed,contrast,length, position, duration, degPerPix,sizeX,sizeY, frameRate, black, white,sizeLut)%%% generate images for drifting gratings, without displaying them%%% based (loosely) on DriftDemo from psychtoolbox%%% cmn 11/05/05% DriftDemo shows a drifting grating.% % See also GratingDemo, NoiseDemo, MovieDemo.% 2/21/02 dgp Wrote it, based on FlickerTest.% 4/23/02 dgp HideCursor & ShowCursor.%%%set color rangegray = 0.5*(white+black);if contrast>1    contrast=1;endinc=(white-gray)*contrast;%%% geometry, timingsweepPix = sizeX;pixPerDeg = 1/degPerPix;sweepDeg =  sweepPix / pixPerDeg;duration = sweepDeg/speed;frames = duration*frameRate;  % temporal period, in frames, of the drifting gratingif length>0  %%% short bars    lengthPix = length*pixPerDeg    positionPix = position*pixPerDegendlutMax = frames*floor((sizeLut-1)/frames)   % save max value for off;pixPerLut = sweepPix/lutMax;degPerLut = pixPerLut*degPerPix;wavelength = 1/freq;barWidthLut = round(wavelength /degPerLut);speedLut = speed / degPerLut;lutPerFrame = speedLut/frameRate;[x,y]=meshgrid(1:sizeX,1:sizeY);angle=orient*pi/180;%%%angle = -angle;    %%% to follow polar coordinate conventionsf= 2*pi/(pixPerDeg*wavelength); % cycles/pixela=cos(angle)/pixPerLut;b=sin(angle)/pixPerLut;img = floor(lutMax/2 + a*(x-sizeX/2)+b*(y-sizeY/2));img(img<0)=lutMax;  %%% values outside the range are set to off, to avoid periodic wraparoundimg(img>lutMax)=lutMax;if length>0    d = sin(angle)*(x-sizeX/2) - cos(angle)*(y-sizeY/2);    img(d>(positionPix+lengthPix/2))=lutMax;    img(d<(positionPix-lengthPix/2))=lutMax;endlut =zeros(sizeLut,3,floor(frames));lut(:,:,:) = gray;for i=1:frames    center = round(i*lutPerFrame);    leadingEdge = round(min(lutMax-1,center + 0.5*barWidthLut));    trailingEdge = round(max(1,center - 0.5*barWidthLut));    lut(trailingEdge:leadingEdge,1:3,i)= gray + inc ;  end