% create event files for each run that indicates event type, onset and duration of each event.
% Hayley Brooks
% May 2021

dataFolder = '/Volumes/shlab/Projects/VNI/data/mriBehaviorRaw/singleSubjectFiles'; %defining working folder
filePattern = fullfile(dataFolder, '*.mat'); %file pattern to load 
matFiles = dir(filePattern); %%pull out files that match file pattern

% participant 13 did not do the RDM task so we will skip them
subNum = [1:12,14:52];
nSub =size(subNum,2);

for k = 1:length(subNum) % for each file that we want to pull out
 baseFileName = matFiles(subNum(k)).name; %store the name of the file
  fullFileName = fullfile(dataFolder, baseFileName); %store file name with folder
  fprintf(1, 'Now reading %s\n', fullFileName); %tell us your reading the file
  matData(subNum(k)) = load(fullFileName); %save the file in matData
end %at the end of this loop, only the .mat files we want will be in matData



for s = 1:nSub
    
timing = matData(subNum(s)).subjdata.ts; % store timing stuff
timing.RTs = matData(subNum(s)).subjdata.cs.RTs'; % store RTs


    
 nT = matData(subNum(s)).subjdata.nT;
 blockTrialStart = [1,74,147]; % trial number when a new block starts
 nTblock = 73;
 % the way the timing is set up right now is not as useful as it could be
 % for the following stuff so let's rearrange it
 
 tmpmtx = NaN(nTblock*6,3,1);
 totEvent = 6; % 6 events per trial

 
 for b = 1:3 % block
     startTrial = blockTrialStart(b);
     endTrial = nTblock*b;
     
     indStart = 1;
     indEnd = totEvent;
     
     for t = startTrial:endTrial
         
         tmpmtx(indStart:indEnd,b,1) = [timing.trialStart(t); timing.stimStart(t); timing.choiceStart(t); timing.isiStart(t); timing.otcStart(t); timing.itiStart(t)];
         
         indStart = indStart + totEvent;
         indEnd = indEnd + totEvent;
     end
 end
 
 % now we have a matrix where each column in a run and each row is an event
 
 %eventDuration = [[0,0,0];diff(tmpmtx)]; % duration of each event in each run
 eventDuration = diff(tmpmtx); % duration of each event in each run

 % need to get the duration for the last ITIs 
 % this can be found by the predetermined ITI plus the "extraTime" variable which based on
 % the difference between the response window (2s) and RT
 lastITIdurationBlock1 = timing.extraTime(blockTrialStart(1)) +  matData(subNum(s)).subjdata.cs.iti(blockTrialStart(1));
 lastITIdurationBlock2 = timing.extraTime(blockTrialStart(2)) +  matData(subNum(s)).subjdata.cs.iti(blockTrialStart(2));
 lastITIdurationBlock3 = timing.extraTime(blockTrialStart(3)) +  matData(subNum(s)).subjdata.cs.iti(blockTrialStart(3));

 % now we can add the final ITI information to the eventDuration matrix:
 eventDuration = [eventDuration;[lastITIdurationBlock1,lastITIdurationBlock2,lastITIdurationBlock3]];
 
 
%{
    Columns: 
        1) Event: 
          - First row will be study start with onset of 0
          - Remaining rows: trial, stimulus display, decision window, choice, ISI, outcome display, ITI
        2) Onset: seconds
        3) Duration: seconds
        4) Block start: 1 = yes, 0 = no
        5) Trial number (1-219)
    
%}
    % we need to account for 15 seconds plus the short delay between the

    eventRun1 = table; % create tables
    eventRun2 = table; % create tables
    eventRun3 = table; % create tables
            
    eventorder = ["trialStart", "stimulusStart", "decisionWindow", "ISI", "outcome","ITI"]; % events
    eventRun1.eventType = repmat(eventorder,1,nTblock)'; % repeat the events and store in matrix, make first row study start
    eventRun2.eventType = repmat(eventorder,1,nTblock)'; % repeat the events and store in matrix, make first row study start
    eventRun3.eventType = repmat(eventorder,1,nTblock)'; % repeat the events and store in matrix, make first row study start

    
    
    % trial number
    eventRun1.trial= repelem(1:nTblock,totEvent)'; % fill in trial number for the rest of the events
    eventRun2.trial= repelem(1:nTblock,totEvent)'; % fill in trial number for the rest of the events
    eventRun3.trial= repelem(1:nTblock,totEvent)'; % fill in trial number for the rest of the events

    
    
    % duration
    eventRun1.duration = eventDuration(:,1);
    eventRun2.duration = eventDuration(:,2);
    eventRun3.duration = eventDuration(:,3);
   
    % onset
    eventRun1.onset(1) = 0; % start first trial at 0
    eventRun2.onset(1) = 0; % start first trial at 0
    eventRun3.onset(1) = 0; % start first trial at 0

    
    for event=2:size(eventRun1,1)
        eventRun1.onset(event) = eventRun1.onset(event-1) + eventRun1.duration(event-1); % block/first trial starts shortly after study start
        eventRun2.onset(event) = eventRun2.onset(event-1) + eventRun2.duration(event-1); % block/first trial starts shortly after study start
        eventRun3.onset(event) = eventRun3.onset(event-1) + eventRun3.duration(event-1); % block/first trial starts shortly after study start
    end


    %SAVE OUTPUT
    writetable(eventRun1, sprintf('/Volumes/shlab/Projects/VNI/data/mriTimingFiles/sub-%s_run1_event.csv',matData(subNum(s)).subjdata.subjID))
    writetable(eventRun2, sprintf('/Volumes/shlab/Projects/VNI/data/mriTimingFiles/sub-%s_run2_event.csv',matData(subNum(s)).subjdata.subjID))
    writetable(eventRun3, sprintf('/Volumes/shlab/Projects/VNI/data/mriTimingFiles/sub-%s_run3_event.csv',matData(subNum(s)).subjdata.subjID))
end

      
      

    
    
 
    