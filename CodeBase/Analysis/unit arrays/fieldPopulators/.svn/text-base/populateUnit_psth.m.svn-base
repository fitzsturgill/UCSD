function unit = populateUnit_psth(unit, curExpt, curTrodeSpikes,varargin)

expt = curExpt;
s = curTrodeSpikes;
assign = unit.assign;

% Get orientation fileInd
fileInd = expt.analysis.orientation.fileInd;

% Filter on orientation files and unitassign
s = filtspikes(s,0,'fileInd',fileInd,'assigns',assign);

% Make stimulus struct for orientation
stim = makeStimStruct(expt,fileInd);

% Get condition struct
cond = expt.analysis.orientation.cond;

% Get sweep duration
dur_sw = expt.files.duration(fileInd(1));

% Set bin sizes in milliseconds
binSize = {[50],[2]};

for i = 1:length(binSize)
    psth(i).delay = expt.stimulus(fileInd(1)).params.delay;
    psth(i).dur_sw = dur_sw;
    psth(i).dur_vstim = expt.stimulus(fileInd(1)).params.duration;
    psth(i).cond = 'led';
    psth(i).condtime = expt.analysis.orientation.windows.ledon;
    psth(i).binsize = binSize{i}/1000;
    psth(i).edges = (0:psth(i).binsize:dur_sw)';
    psth(i).centers = (psth(i).edges(1:end-1)+psth(i).binsize/2);
    psth(i).counts = [];
end

for i = 1:length(psth)
    for m = 1:length(stim.values)
        for n = 1:length(cond.values)
            s_temp = s;
            s_temp = makeTempField(s_temp,'led',cond.values{n});
            s_temp = filtspikes(s_temp,0,'stimcond',stim.code{m},'temp',1);
            stimes = s_temp.spiketimes;
            if ~isempty(stimes)
                counts = histc(stimes,psth(i).edges);
                psth(i).counts{m,n} = counts;
                trials = length(s_temp.sweeps.trials);
                psth(i).fr{m,n} = counts(1:end-1)/psth(i).binsize/trials;
            else
                psth(i).fr{m,n} = (zeros(size(psth(i).centers)))';
            end
        end
    end
end

unit.psth = psth;