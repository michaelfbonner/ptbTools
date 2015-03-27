%% ptbResponseAccuracy
%
% Get response accuracy
% 
%% Syntax
% 
% thisTrialAccuracy = ptbResponseAccuracy(thisResponseKey, thisConditionLabel, ResponseParameters)
% 
%% Description
% 
% ptbResponseAccuracy computes the response accuracy based on the response
% and condition of the current trial and a set of response parameters. Note
% that if there is no response, it is labeled as incorrect.
% 
% * thisResponseKey  - subject's response
% * thisConditionLabel  - condition for current trial
% * ResponseParameters.leftKey                    Key for lefthand response
% * ResponseParameters.rightKey                   Key for righthand response
% * ResponseParameters.leftConditionLabel         Condition label (string) for lefthand response
% * ResponseParameters.rightConditionLabel        Condition label (string) for righthand response
% 
% * thisTrialAccuracy  - response accuracy
%
%% Example
%
%  % Response keys and conditions
%  leftKey = 'b';
%  rightKey = 'r';
%  responseKeys = {leftKey, rightKey};
%  leftConditionLabel = 'virtual';
%  rightConditionLabel = 'real';
%  ResponseParameters.leftKey = leftKey;
%  ResponseParameters.rightKey = rightKey;
%  ResponseParameters.leftConditionLabel = leftConditionLabel;
%  ResponseParameters.rightConditionLabel = rightConditionLabel;
%  
%  thisConditionLabel = conditionLabels{iTrials};
%  
%   % Create KbQueue for responses
%  ptbKbQueueCreate(responseKeys)
%  KbQueueFlush(); % removes all keyboard presses
%  [~, stimulusOnsetTime] = Screen('Flip', hScreen);  % Show crosshair
%  thisRelativeStimulusTime = ptbRelativeTime(stimulusOnsetTime, firstTrialTime);  % Calculate time relative to first TR
%  
%  % Get key response while stimulus is up
%  [thisResponseKey, thisRawReactionTime, thisRelativeReactionTime] = ptbGetResponse(stimulusOnsetTime, cStimulusDuration);
%  
%  % Get accuracy
%  thisTrialAccuracy = ptbResponseAccuracy(thisResponseKey, thisConditionLabel, ResponseParameters);
% 
%% See also
%
% * ptbGetResponse
% * ptbKbQueueCreate
% * ptbRelativeTime
% 
% Michael F. Bonner | University of Pennsylvania | <http://www.michaelfbonner.com> 



%% Function

function thisTrialAccuracy = ptbResponseAccuracy(thisResponseKey, thisConditionLabel, ResponseParameters)


%% Assign variables

% Inputs
leftKey = ResponseParameters.leftKey;
rightKey = ResponseParameters.rightKey;
leftConditionLabel = ResponseParameters.leftConditionLabel;
rightConditionLabel = ResponseParameters.rightConditionLabel;



%% Compute accuracy

% Identify response key
isLeftResponse = strcmp(thisResponseKey, leftKey);
isRightResponse = strcmp(thisResponseKey, rightKey);

% Identify condition
isLeftCondition = strcmp(thisConditionLabel, leftConditionLabel);
isRightCondition = strcmp(thisConditionLabel, rightConditionLabel);

% Compute accuracy
if isLeftCondition && isLeftResponse
    thisTrialAccuracy = 1;
elseif isRightCondition && isRightResponse
    thisTrialAccuracy = 1;
else
    thisTrialAccuracy = 0;
end


end  % function thisTrialAccuracy = ptbResponseAccuracy(thisResponseKey, thisConditionLabel, ResponseParameters)


