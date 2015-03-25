%% ptbCreateRandomTrialSequence
%
% Create a random sequence bookended by start-up and wrap-up trials
% 
%% Syntax
% 
% sequence = ptbCreateRandomTrialSequence(EventParameters)
% 
%% Description
% 
% ptbCreateRandomTrialSequence creates a randomized sequence of trials
% bookended by startUp and wrapUp trials. Note that a "trial" may contain
% muliple events,
% 
% * EventParameters.bookends.startUp.N  - number of startUp trials
% * EventParameters.bookends.startUp.events     - cell array of event names for each trial
% * EventParameters.bookends.wrapUp.N   - number of wrapUp trials
% * EventParameters.bookends.wrapUp.events  - cell array of event names for each trial
% * EventParameters.main.(conditionName).N  - number of trials for this condition
% * EventParameters.main.(conditionName).events     - cell array of event names for each trial
% 
% * thisSequence    - random sequence of conditions
%
%% Example
%
%  EventParameters.bookends.startUp.N = nStartUp;
%  EventParameters.bookends.startUp.events = {'startUp', 'null'};
%  
%  EventParameters.bookends.wrapUp.N = nWrapUp;
%  EventParameters.bookends.wrapUp.events = {'null'};
%  
%  EventParameters.main.heightChange.N = nTrialsPerCrossCondition;
%  EventParameters.main.heightChange.events = {'heightChange', 'null'};
%  
%  EventParameters.main.widthChange.N = nTrialsPerCrossCondition;
%  EventParameters.main.widthChange.events = {'widthChange', 'null'};
%  
%  EventParameters.main.null.N = nNull;
%  EventParameters.main.null.events = {'null', 'null'};
%  
%  thisSequence = ptbCreateRandomTrialSequence(EventParameters);
% 
%% See also
% 
% Michael F. Bonner | University of Pennsylvania | <http://www.michaelfbonner.com> 



%% Function 

function [sequence] = ptbCreateRandomTrialSequence(EventParameters)


%% Initialize random number generator 

rng('shuffle');  % on older releases, use: rand('seed',sum(100*clock));


%% Allocate events

conditionNames = fieldnames(EventParameters.main);
nConditionNames = length(conditionNames);
conditionSequence = [];
for iConditionNames = 1 : nConditionNames
    thisConditionName = conditionNames{iConditionNames};
    nThisCondition = EventParameters.main.(thisConditionName).N;
    thisConditionNameList = repmat({thisConditionName}, [nThisCondition, 1]);
    conditionSequence = [conditionSequence; thisConditionNameList];
end



%% Randomize events

nConditionTrials = length(conditionSequence);  
randomIndices = randperm(nConditionTrials);
randomizedConditionTrials = conditionSequence(randomIndices);



%% Unpack events

mainEventSequence = [];
for iConditionTrials = 1 : nConditionTrials
    thisConditionName = randomizedConditionTrials{iConditionTrials};
    eventsForThisCondition = EventParameters.main.(thisConditionName).events;
    nEventsForThisCondition = length(eventsForThisCondition);
    for iEventsForThisCondition = 1 : nEventsForThisCondition
        thisEvent = eventsForThisCondition(iEventsForThisCondition);
        mainEventSequence = [mainEventSequence; thisEvent];
    end
end



%% Add startUp and wrapUp

startUpSequence = makeBookendSequence('startUp', EventParameters);
wrapUpSequence = makeBookendSequence('wrapUp', EventParameters);
sequence = [startUpSequence; mainEventSequence; wrapUpSequence];

end  % function [sequence] = ptbCreateRandomTrialSequence(EventParameters)



%% Local functions

function [thisBookendSequence] = makeBookendSequence(thisBookend, EventParameters)

nBookendTrials = EventParameters.bookends.(thisBookend).N;
bookendEvents = EventParameters.bookends.(thisBookend).events(:);
thisBookendSequence = repmat(bookendEvents, [nBookendTrials, 1]);

end




















