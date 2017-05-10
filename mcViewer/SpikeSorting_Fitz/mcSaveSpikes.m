function mcSaveSpikes(backup)

    global state

    if nargin == 0
        backup = 0;
    end
%     if isempty(state.mcViewer.trode)
%        return
%     end
    
    for field=state.mcViewer.saveFields

		eval(['tempObject.' field{1} '=state.mcViewer.' field{1} ';']);
    end
    
% 	[fname, pname] = uiputfile([state.imageViewer.fileBaseName '_ts.mat'], 'Choose file...');
% 	if pname == 0
% 		return
% 	end

	disp('Saving...')
% 	save([state.mcViewer.filePath state.mcViewer.fileBaseName 'mcSpikes.mat'], 'tempObject');

%%
% For resaving, try and use existing path of spikes file and existing spikes file name
    if backup == 0
        try
            cd(state.mcViewer.spikesFilePath);
            [filename, pathname, filterindex] = uiputfile(state.mcViewer.spikesFileName, 'Save Spikes');
            if isnumeric(filename)
                return
            end
            save(filename, 'tempObject');
            %         uisave('tempObject', state.mcViewer.spikesFileName);                
        catch
            cd(state.mcViewer.filePath);
            [filename, pathname, filterindex] = uiputfile([mcExpPrefix 'mcSpikes.mat'], 'Save Spikes');
            if isnumeric(filename)
                return
            end        
            save(filename, 'tempObject');        
    %         uisave('tempObject', [mcExpPrefix 'mcSpikes.mat']);        
        end
    else
        % for backup, make sure that you've already saved spikes initially
        if isempty(state.mcViewer.spikesFileName)
            disp('*** Error in mcSaveSpikes: First save spikes initially before performing backup ***');
            return
        end
        %backup folder is always witin data file folder
        %(state.mcViewer.filePath) and always takes the name of the
        %existing spikes file with "_backup" prepended
        cd(state.mcViewer.filePath);        
        [pathstr, name, ext, versn] = fileparts(state.mcViewer.spikesFileName);
        backupFolder=['backup_' name];
        if ~isdir(backupFolder)
            success=mkdir(backupFolder);
            if ~success
                return
            end
        end
        cd(backupFolder);
        save(state.mcViewer.spikesFileName, 'tempObject');
        backupPath = pwd;
        disp(['*** Saved Backup ' state.mcViewer.spikesFileName ' in ' backupPath ' ***']);
        clear tempObject;
        return
        % return so that you don't change spikesFileName or spikesFilePath,
        % backup process should be transparent and not switch the focus of
        % the mcViewer program towards the backup rather than the original
        % spikes file
    end
        
            
            
        
    state.mcViewer.spikesFileName=filename;
    state.mcViewer.spikesFilePath=pathname;
    disp(['*** Saved ' filename ' in ' pathname ' ***']);
	disp('Done...');
	clear tempObject;