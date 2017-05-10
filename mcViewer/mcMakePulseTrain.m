function out = mcMakePulseTrain(duration, delay, nPulses, ISI, pulseWidth, amplitude)
    %pass pulseWidth = 0 to obtain edges for histograms
    global state
    if nargin == 0
        if any([isempty(state.mcViewer.pulse.pulseDelay)...
                isempty(state.mcViewer.pulse.nPulses)...
                isempty(state.mcViewer.pulse.pulseISI)...
                isempty(state.mcViewer.pulse.pulseWidth)...
                isempty(state.mcViewer.tsData{1,1})])
            disp('Error in mcMakePulseTrain: Define Pulse Parameters');
            out = [];
            return
        end
        
        duration = size(state.mcViewer.tsData{1,1}, 1)/state.mcViewer.sampleRate;
        delay = state.mcViewer.pulse.pulseDelay;
        nPulses = state.mcViewer.pulse.nPulses;
        ISI = state.mcViewer.pulse.pulseISI;
        pulseWidth = state.mcViewer.pulse.pulseWidth;
        amplitude = NaN;
    end
    deltaX = 1/state.mcViewer.sampleRate; %sample rate in Khz, x units in msec
    startX = state.mcViewer.startX;
    endX = startX + duration - deltaX; 
    out = ones(1, duration/deltaX);
    
    
    startIndex = (delay - startX)/deltaX + 1;
    mask1 = startIndex + (0:(nPulses - 1)) .* (ISI/deltaX); % a row, the pulse onsets in indices
    mask2 = (0:(pulseWidth/deltaX))'; % a column, indices spanning pulse duration
    
    mask1 = repmat(mask1, size(mask2, 1), 1); 
    mask2 = repmat(mask2, 1, size(mask1, 2));
    mask1 = mask1 + mask2;
    mask1 = reshape(mask1, 1, size(mask1, 1) * size(mask1, 2)); 

    
    out(mask1) = amplitude;
    
    
    
  