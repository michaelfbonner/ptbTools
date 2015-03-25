%% ptbWaitForT
%
% Wait for t
%
%% Syntax
%
% WaitOutput = ptbWaitForT(WaitParameters)
%
%% Description
%
% ptbWaitForT waits for a 't' input or, if in debugging mode, gets the
% current time stamp.
% 
% * WaitParameters.isDebuggingRun  - logical indicating whether this is a
% debugging run
% * WaitParameters.isTimeZero  - logical indicating whether current trial
% is the timeZero
% * WaitParameters.timeZero    - zero time stamp (should be an empty array
% if not defined yet)
% * WaitParameters.cTrialDuration  - trial duration to use during debuggin
% 
% * WaitOutput.thisTrialOnset  - time stamp of first 't' or first trial
% start in debugging mode
% * WaitOutput.thisRelativeTrialOnset  - thisTrialOnset time relative to
% firstTrialOnset
% * WaitOutput.timeZero     - updated time zero value if this is the
% timeZero trial
% 
%% Example
%
%  WaitParameters.isDebuggingRun = isDebuggingRun;
%  WaitParameters.isTimeZero = isTimeZero;
%  WaitParameters.timeZero = timeZero;
%  WaitParameters.cTrialDuration = cTrialDuration;
%  WaitOutput = ptbWaitForT(WaitParameters);
%
%% See also
%
% * ptbKbQueueCreate
% * ptbInterStimulusInterval
%
% Michael F. Bonner | University of Pennsylvania | <http://www.michaelfbonner.com>


%% Function

function WaitOutput = ptbWaitForT(WaitParameters)


%% Assign variables

isDebuggingRun = WaitParameters.isDebuggingRun;
isTimeZero = WaitParameters.isTimeZero;
timeZero = WaitParameters.timeZero;
cTrialDuration = WaitParameters.cTrialDuration;



%% Wait for 't'

if isDebuggingRun
    
    % Trial start
    thisTrialOnset = GetSecs;
    
    % Timing
    if isTimeZero
        timeZero = thisTrialOnset;
    else
        timeZero = WaitParameters.timeZero;
    end
    thisRelativeTrialOnset = ptbRelativeToTimeZero(thisTrialOnset, timeZero);

    % Wait for a set duration
    WaitSecs(cTrialDuration);
      
else
    
    % Trial start
    ptbKbQueueCreate({'t'})  % Wait for 't'
    thisTrialOnset = KbQueueWait;

    % Timing
    if isTimeZero
        timeZero = thisTrialOnset;
    else
        timeZero = WaitParameters.timeZero;
    end
    thisRelativeTrialOnset = ptbRelativeToTimeZero(thisTrialOnset, timeZero);
    
    % End KbQueue 
    KbQueueRelease;
    
end



%% Output

WaitOutput.thisTrialOnset = thisTrialOnset;
WaitOutput.thisRelativeTrialOnset = thisRelativeTrialOnset;
WaitOutput.timeZero = timeZero;


end  % function WaitOutput = ptbWaitForT(WaitParameters)

