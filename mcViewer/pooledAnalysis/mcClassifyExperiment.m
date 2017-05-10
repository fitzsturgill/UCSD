function mcClassifyExperiment(experiment)


    global clusters

%     evalin('base', 'global PCAInput_odor');    
    
    % initialize data matrix- variables go in columns, observations in rows
%     PCAInput_odor = zeros(size(clusters(1).analysis.SpikeRate.data, 1), length(clusters));
  
% generate list of clusters to pull from
    cl = mcFilterClusters('experiment', experiment);
    cl = find(cl);

    % iterate through conditions, concatenating master and groups as we
    % go...
    nGroups = size(clusters(cl(1)).analysis.SpikeRate.data, 1);
    nTrials = length(clusters(cl(1)).analysis.SpikeRate.data(1,1).data); % assuming # of trials is the same
    nNeurons = length(cl);
    
    master = [];
    groups = [];
%     master2=zeros(nTrials,nNeurons,nGroups);
    for i = 1:nGroups
        groups = [groups ; repmat(i, nTrials, 1)];        
        temp = zeros(nTrials, nNeurons);
        for j = 1:nNeurons
            temp(:,j) = clusters(cl(j)).analysis.SpikeRate.data(i,1).data';
        end
        master = [master ; temp];
%         master2(:,:,i) = temp;
    end
    
    assignin('base', [experiment 'master'], master);
    assignin('base', [experiment 'groups'], groups);
    
    
    
    %perform "leave one out" classification using matlab classify function
    %and calculate % correct
    key = unique(groups);
    correct = zeros(size(key));
    
    masterIndex = 1:size(master, 1);
    for i = 1:size(master, 1);
        group = groups(i);
        class = classify(master(i,:), master(masterIndex ~= i, :), groups(masterIndex ~= i, 1)); % classify( current trial (row)  ,     all other trials (except for this row))
        
        if group == class % if classification is corrrect...
            correct(key == group) = correct(key == group) + 1;
        end
    end
    
    correct = correct ./ nTrials .* 100;
    correct = [key correct]; % first column is group, second is % correct
    assignin('base', [experiment 'correct'], correct);
        
        
    
    
    
    
    
    
%     % generate a master training matrix that can be used for "withhold-one"
% % training and classification.  As this function deals with a single
% % experiment, the master training matrix will be rectangular (equal numbers
% % of trials)
%         first = 1;
%     for i = 1:length(clusters)
%         cluster = clusters(i);
%         if first % initialize master and groups
%             nGroups = size(clusters(cluster).analysis.SpikeRate.data, 1);
%             nTrials = length(clusters(cluster).analysis.SpikeRate.data(1,1).data);
%             master = zeros(nTrials, length(clusters)); %a # rows = trials/condition X # columns = neurons
%             master = repmat(master, nGroups, 1); % expand matrix according to the total # of conditions
%             groups = zeros(1, nGroups * nTrials);
%             first = 0;
%         end
% 
%         for j = 1:size(clusters(i).analysis.SpikeRate.data, 1)
%             PCAInput_odor(i, j) = clusters(i).analysis.SpikeRate.data(j, 1).avg;
%         end
%     end