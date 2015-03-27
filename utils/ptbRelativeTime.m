%% ptbRelativeTime
%
% Compute relative and rounded time (in milliseconds)
% 
%% Syntax
% 
% relativeTime = ptbRelativeTime(thisTime, initialTime)
% 
%% Description
% 
% ptbRelativeTime computes the difference between the thisTimeStamp and the
% referenceTimeStamp. The output is converted to milliseconds and rounded
% to the nearest millisecond.
% 
% * thisTimeStamp   - time stamp to analyze (in seconds)
% * referenceTimeStamp   - time stamp of reference point (in seconds)
%
% * relativeTime    - difference between thisTimeStamp and
% referenceTimeStamp in rounded milliseconds
% 
%% Example
%
%  thisTrialTime = GetSecs;
%  if iTrials == 1  % Get the onset time of first 't' as the time=0 reference point
%      firstTrialTime = thisTrialTime;
%  end
%  thisRelativeTrialTime = ptbRelativeTime(thisTrialTime, firstTrialTime);
% 
%% See also
%
% * ptbRelativeToTimeZero
% * ptbGetResponse
% 
% Michael F. Bonner | University of Pennsylvania | <http://www.michaelfbonner.com> 



%% Function

function relativeTime = ptbRelativeTime(thisTimeStamp, referenceTimeStamp)


%% Compute relative time

cSecondsToMilliseconds = 1000;
thisRelativeTime = cSecondsToMilliseconds * (thisTimeStamp - referenceTimeStamp);  
relativeTime = round(thisRelativeTime);


end  % function relativeTime = ptbRelativeTime(thisTimeStamp, referenceTimeStamp)
