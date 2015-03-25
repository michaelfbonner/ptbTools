%% ptbBufferImageAndCrosshairAndWaitForT
%
% Load image and crosshair to backbuffer and wait for a t
%
%% Syntax
%
% ptbBufferImageAndCrosshairAndWaitForT
%
%% Description
%
% ptbBufferImageAndCrosshairAndWaitForT loads the image and a crosshair to
% the backbuffer and waits for one 't' input or (if in debugging mode, it
% skips the wait for t) and asigns values to the following vairiables:
%
% * thisTrialOnset  - time stamp of first 't' or first trial start in
% debugging mode
% * thisRelativeTrialOnset  - thisTrialOnset time relative to firstTrialOnset
%
% The following variables should be defined in the script that calls
% ptbBufferImageAndCrosshairAndWaitForT:
% 
% * isDebuggingRun  - logical indicating whether this is a debugging run
% * isTimeZero  - logical indicating whether current trial is the timeZero
% * timeZero    - zero time stamp (should be an empty array if not defined
% yet)
% * CrosshairParameters     - inputs for ptbCrosshair
%
%% Example
%
%  ptbBufferImageAndCrosshairAndWaitForT;
%
%% See also
%
% * ptbWaitForT
% * ptbCrosshair
%
% Michael F. Bonner | University of Pennsylvania | <http://www.michaelfbonner.com>



%% Load image and wait for t

% Load stimulus image
thisImage = imread(thisStimulusFullFile);
thisImage = imresize(thisImage, imageSize);
thisImageScreenTexture = Screen('MakeTexture', hScreen, thisImage);
Screen('DrawTexture', hScreen, thisImageScreenTexture);  % Draw texture image to backbuffer.

% Crosshair
ptbCrosshair(CrosshairParameters);

% Parameters for ptbWaitForT
WaitParameters.isDebuggingRun = isDebuggingRun;
WaitParameters.isTimeZero = isTimeZero;
WaitParameters.timeZero = timeZero;
WaitParameters.cTrialDuration = 0;  % do not wait when in debugging mode

% Wait for 't'
WaitOutput = ptbWaitForT(WaitParameters);
thisTrialOnset = WaitOutput.thisTrialOnset;
thisRelativeTrialOnset = WaitOutput.thisRelativeTrialOnset;



