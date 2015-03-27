%% ptbGetResponse
%
% Get key response while during stimulus duration
% 
%% Syntax
% 
% [thisRawReactionTime, thisRelativeReactionTime] = ptbGetResponse(stimulusOnsetTime, cStimulusDuration)
% 
%% Description
% 
% ptbGetResponse uses the KbQueue previously created with
% ptbKbQueueCreate to check for responses during the stimulus duration.
% Returns information about the first response during this time window.
% 
% * stimulusOnsetTime    - time stamp of stimulus onset 
% * cStimulusDuration    - stimulus duration (in seconds)
% 
% * thisResponseKey    - first pressed key in the KbQueue
% 
% * thisRawReactionTime    - time stamp of first key press (in seconds)
% 
% * thisRelativeReactionTime    - time between first key press and stimulus
% onset (in milliseconds)
%
%% Example
%
%  % Create KbQueue for responses
%  ptbKbQueueCreate(responseKeys)
%  KbQueueFlush(); % removes all keyboard presses
%  
%  % Display stimulus
%  [~, thisStimulusOnset] = Screen('Flip', hScreen);
%  thisRelativeStimulusOnset = ptbRelativeToTimeZero(thisStimulusOnset, timeZero);
%  
%  % Get key response while stimulus is up
%  [thisResponseKey, thisRawReactionTime, thisRelativeReactionTime] = ptbGetResponse(thisStimulusOnset, cStimulusDuration);
% 
%% See also
%
% * ptbKbQueueCreate
% * ptbRelativeTime
% * ptbResponseAccuracy
% 
% Michael F. Bonner | University of Pennsylvania | <http://www.michaelfbonner.com> 



%% Function

function [thisResponseKey, thisRawReactionTime, thisRelativeReactionTime] = ptbGetResponse(stimulusOnsetTime, cStimulusDuration)


%% Get key responses during stimulus duration time

pressed = 0; % Start with a zero value for the keydown variable
while ~pressed && (GetSecs - stimulusOnsetTime) <= cStimulusDuration % Check for responses until receiving one or until the trial duration time is reached
    [pressed, firstPressedKey] = KbQueueCheck(); % Check for key response
end
firstPressedKeyCodeIndex = find(firstPressedKey); % Get key pressed by subject
thisResponseKey = KbName(firstPressedKeyCodeIndex);



%% Compute reaction time if there is a response

if firstPressedKey(firstPressedKeyCodeIndex) > 0 
    thisRawReactionTime = GetSecs;
    thisRelativeReactionTime = ptbRelativeTime(thisRawReactionTime, stimulusOnsetTime);
else
    thisRawReactionTime = nan;
    thisRelativeReactionTime = nan;
end



%% Wait so that the stimulus stays on screen for a set duration

timeLeftUntilEndOfStimulusDuration = (GetSecs - stimulusOnsetTime); 
WaitSecs(cStimulusDuration - timeLeftUntilEndOfStimulusDuration); 

% Stop listening for keys
KbQueueRelease;


end  % function [thisResponseKey, thisRawReactionTime, thisRelativeReactionTime] = ptbGetResponse(stimulusOnsetTime, cStimulusDuration)



