%% ptbInterStimulusInterval
%
% Wait for a single t
%
%% Syntax
%
% IntervalOutput = ptbInterStimulusInterval(IntervalParameters)
%
%% Description
%
% ptbInterStimulusInterval waits for one 't' input or, if in debugging
% mode, it waits for the remained of the current trial duration and then
% one more trial duration.
%
% * IntervalParameters.thisTrialOnset  - time stamp of previous trial onset (used to calculate
% remaining wait time in debugging mode)
% * IntervalParameters.isDebuggingRun  - logical indicating whether this is a debugging run
% * IntervalParameters.isTimeZero  - logical indicating whether current trial is the timeZero
% * IntervalParameters.timeZero    - zero time stamp (should be an empty array if not defined
% yet)
% * IntervalParameters.cTrialDuration  - trial duration to use during debuggin
%
% * IntervalOutput.WaitOutput   - output from ptbWaitForT
% 
%% Example
%
%  IntervalParameters.thisTrialOnset = thisTrialOnset;
%  IntervalParameters.isDebuggingRun = isDebuggingRun;
%  IntervalParameters.isTimeZero = isTimeZero;
%  IntervalParameters.cTrialDuration = cTrialDuration;
%  IntervalOutput = ptbInterStimulusInterval(IntervalParameters);
%  thisIsiOnset = IntervalOutput.WaitOutput.thisTrialOnset;
%
%% See also
%
% * ptbWaitForT
%
% Michael F. Bonner | University of Pennsylvania | <http://www.michaelfbonner.com>



%% Function 

function IntervalOutput = ptbInterStimulusInterval(IntervalParameters)


%% Assign variables

thisTrialOnset = IntervalParameters.thisTrialOnset;
isDebuggingRun = IntervalParameters.isDebuggingRun;
isTimeZero = IntervalParameters.isTimeZero;
timeZero = IntervalParameters.timeZero;
cTrialDuration = IntervalParameters.cTrialDuration;



%% Wait for t

% If in debugging mode, wait the remainder of the trial duration befor
% calling ptbWaitForT
if isDebuggingRun
    timeFromTrialOnset = (GetSecs - thisTrialOnset); 
    timeLeftUntilEndOfTrial = cTrialDuration - timeFromTrialOnset;
    WaitSecs(timeLeftUntilEndOfTrial);
end

% Parameters for ptbWaitForT
WaitParameters.isDebuggingRun = isDebuggingRun;
WaitParameters.isTimeZero = isTimeZero;
WaitParameters.timeZero = timeZero;
WaitParameters.cTrialDuration = cTrialDuration;

% Wait for t
WaitOutput = ptbWaitForT(WaitParameters);

% Output structure
IntervalOutput.WaitOutput = WaitOutput;


end  % function IntervalOutput = ptbInterStimulusInterval(IntervalParameters)

