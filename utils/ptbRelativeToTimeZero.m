%% ptbRelativeToTimeZero
%
% Time stamp relative to time-zero in milliseconds
%
%% Syntax
%
% relativeTimeStamp = ptbRelativeToTimeZero(thisTimeStamp, timeZero)
%
%% Description
%
% ptbRelativeToTimeZero calculates the difference between the thisTimeStamp
% and timeZero if timeZero is a non-empty variable. The output is converted
% to milliseconds and rounded to the nearest millisecond.
%
% * thisTimeStamp   - current time stamp
% * timeZero  - time stamp of first 't' or first trial start in
% debugging mode
% 
% * relativeTimeStamp  - time relative to timeZero (in milliseconds)
%
%% Example
%
%  timeZero = [];
% 
%  % Trial start
%  ptbKbQueueCreate({'t'})  % Wait for 't'
%  
%  % Timing
%  thisTrialOnset = KbQueueWait;
%  if isTimeZero
%      timeZero = thisTrialOnset;
%  end
%  thisRelativeTrialOnset = ptbRelativeToTimeZero(thisTrialOnset, timeZero);
%  KbQueueRelease;
%
%% See also
%
% * ptbRelativeTime
%
% Michael F. Bonner | University of Pennsylvania | <http://www.michaelfbonner.com>



%% Function

function relativeTimeStamp = ptbRelativeToTimeZero(thisTimeStamp, timeZero)


%% Calculate relative onset

if isempty(timeZero)
    relativeTimeStamp = nan;
else
    relativeTimeStamp = ptbRelativeTime(thisTimeStamp, timeZero);
end


end  % function thisRelativeTimeStamp = ptbRelativeToTimeZero(thisTimeStamp, timeZero)
