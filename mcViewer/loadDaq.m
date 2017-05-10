function success = mcLoadDaq(filename, wavename)
    global MC, MC
    success = 1;
    if nargin == 0 || isempty(filename)
        [fname, pname] = uigetfile('*.daq', 'select .daq files to load');
        if isnumeric(pname)
            return
        else
            filename = [pname fname];
            [~, wavename, ~, ~] = fileparts(filename);
        end
    end
    
    if nargin < 2 || isempty(wavename)
        [~, wavename, ~, ~] = fileparts(filename);
    end
    
    try
        data = daqread(filename);
    catch
        disp ( 'error in loadDaq, invalid filename');
        success = 0;
        return
    end
    
    if length(find(isnan(data), 1)) > 0
        disp ('multiple triggers not currently supported in loadDaq');
        success = 0;
    end
    
    waveo(wavename, data');
    
    
    
    
    
        