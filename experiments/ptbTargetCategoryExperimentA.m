%% ptbTargetCategoryExperimentA
% 
% Category-detection task for fMRI 
% 
%% Syntax
% 
% ptbTargetCategoryExperimentA(SessionParameters)
% 
%% Description
% 
% ptbTargetCategoryExperimentA implements an fMRI experiment for a
% target-category detection task. An image is displayed with an overlaid
% fixation crosshair for a set duration on each trial, and subjects
% indicate by button press when an image from a target category appears.
% The start of each trial is locked to a keyboard input of 't,' but this
% can be switched to a set trial duration by using the debugging mode. Null
% events are double nulls by default.  The script assumes that sequence
% files have been generated for each subject on each run and that these
% files fit a specified format (see below).
%  
% Although this function implements a general-purpose experimental
% protocol, there are a number of built-in settings that users might want
% to change. This function is provided mainly as an example experiment to
% illustrate the use of ptbTools and PsychToolbox. Keep in mind that all
% functions in ptbTools are in development and have not been tested. If you
% use this or any other ptbTools functions in your experiment, make sure to
% run validation tests to ensure that timing and accuracy measures are
% correct.
% 
% * SessionParameters.subjectNumber     - subject number (e.g., 1)
% * SessionParameters.runNumber     - run number (e.g., 1)
% * SessionParameters.isDebuggingRun    - logical value indicating whether
% this is a debugging run. 1 indicates debugging and uses timed trials (of
% length cTrialDuration). 0 indicates a real experiment and time-locks the
% start of each trial to a 't' keyboard input.
% * SessionParameters.isTransparentDisplay   - logical value indicating
% whether the display should be made semi-transparent, which can be
% helpfulf during debugging. 1 indicates a semi-transparent display. 0
% indicates a real experiment and makes the dispay opaque. Transparency
% should only be used during debugging.
% * SessionParameters.directorySequences    - directory containg subject-
% and run-specific sequences. The file names should have the following
% format: 'subj001run001sequence.mat.' It is assumed that this file
% contains a SequenceInfo structure with the following fields:
% 
% <html>
% <ul>
% <ul style="list-style-type:circle">
% <li>SequenceInfo.stimulusSequence   - a cell array of stimulus file names
% for each trial, with 'null' entries for null trials</li>
% <li>SequenceInfo.conditionSequence  - a cell array of of condition names,
% which is used in selecting the stimulus-image directory and in
% calculating accuracy</li>
% <li>SequenceInfo.isTimeZero     - a sequence of logical values with a 1
% indicating the time-zero trial. This trial is used as the reference point
% when computing relative onset times. It should corresponds to the onset
% of the first scan that you will model after removing dummy or start-up
% scans.</li>
% </ul>
% </ul>
% </html>
% 
% * SessionParameters.StimulusDirectories   - this is the
% StimulusDirectories structure that will be passed to
% <file:ptbFullfileByCondtion.html ptbFullfileByCondtion>
% * SessionParameters.directoryOutput   - directory that the experiment
% data will be saved to
% * SessionParameters.ResponseParameters   - this is the ResponseParameters
% structure that will be passed to <file:ptbResponseAccuracy.html
% ptbResponseAccuracy>
% * SessionParameters.Timing    - a structure of timing information that
% must contain the following fields:
% 
% <html>
% <ul>
% <ul style="list-style-type:circle">
% <li>Timing.cStimulusDuration    - amount of time (in seconds) that the
% stimulus will be displayed</li>
% <li>Timing.cTrialDuration    - amount of time (in seconds) per trial to use
% in debugging mode</li>
% </ul>
% </ul>
% </html>
% 
% * SessionParameters.imageSize 	- size at which the stimulus images
% will be displayed. Note that if the actual images do not match this, they
% will be resized
% * SessionParameters.instructions 	- instructions that will be displayed
% at the start of the experiment (before the the first 't' input)
% 
% A data file is saved to the output directory with the following format:
% subj001run001.mat. It is important to note that the relative onset
% times in this file are calculated relative to a user specified time-zero
% trial, which is assigned in the isTimeZero field of the SequenceInfo
% structure. Raw time stamps are also provided so that onset times can be
% recalculated in the event that the time-zero reference point needs to be
% changed. This file contains a ScanData structure with the following
% fields.
% 
% * ScanData.GeneralInfo.date   - date that experiment was run
% * ScanData.GeneralInfo.computer   - computer that expriment was run on
% * ScanData.GeneralInfo.subject    - subject name (e.g., 'subj001')
% * ScanData.GeneralInfo.run    - run name (e.g., 'run001')
% * ScanData.GeneralInfo.SessionParameters  - input parameters passed to
% this function
% * ScanData.Sequence   - the SequenceInfo structure loaded in for this
% subject and run
% * ScanData.Timing.TrialOnset.raw 	- time stamp of trial onset
% * ScanData.Timing.TrialOnset.relative 	- trial onset time relative to
% the time-zero reference point
% * ScanData.Timing.StimulusOnset.raw 	- time stamp of stimulus onset
% (this could lag behind the trial onset if the computer is slow or if the
% stimulus files a very large)
% * ScanData.Timing.StimulusOnset.relative 	- stimulus onset time relative
% to the time-zero reference point
% * ScanData.Timing.StimulusOffset.raw 	- time stamp of stimulus offset
% * ScanData.Timing.InterStimulusIntervalOnsets.raw 	- time stamp of ISI
% onset
% * ScanData.Timing.timeZeroTrial 	- trial number of the time-zero trial
% used as the zero reference point
% * ScanData.ResponseData.responses     - subject's responses
% * ScanData.ResponseData.accuracy     - subject's accuracy
% * ScanData.ResponseData.ReactionTime.raw     - time stamps of subject's
% responses
% * ScanData.ResponseData.ReactionTime.relative     - subject's reaction
% time relative to stimulus onset
%
%% Example
% 
%   % Import default settings
%   setPtbParameters_TargetCategory_v001; 
%   isDebuggingRun = PtbParameters.isDebuggingRun;
%   isTransparentDisplay = PtbParameters.isTransparentDisplay;
%   
%   % Directories
%   directorySequences = PtbParameters.directorySequences;
%   directoryStimuli = PtbParameters.directoryStimuli;
%   directoryOutput = PtbParameters.directoryOutput;
%   directoryExperimental = fullfile(directoryStimuli, 'pathways');
%   directoryTarget = fullfile(directoryStimuli, 'target');
%   directoryFiller = fullfile(directoryStimuli, 'filler');
%   directoryStartUp = fullfile(directoryStimuli, 'startUp');
%   
%   % Add ptbTools paths
%   addpath(PtbParameters.directoryPtbTools);
%   
%   % Condition labels and associated directories (this will be passed to
%   % ptbFullfileByCondtion)
%   StimulusDirectories.StartUp.conditions = {'startUp'};
%   StimulusDirectories.StartUp.directory = directoryStartUp;
%   StimulusDirectories.Experimental.conditions = {'pathways', 'targetCarryover', 'fillerCarryover', 'nullCarryover'};
%   StimulusDirectories.Experimental.directory = directoryExperimental;
%   StimulusDirectories.Target.conditions = {'target'};
%   StimulusDirectories.Target.directory = directoryTarget;
%   StimulusDirectories.Filler.conditions = {'filler'};
%   StimulusDirectories.Filler.directory = directoryFiller;
%   StimulusDirectories.Null.conditions = {'null'};
%   StimulusDirectories.Null.directory = [];
%   StimulusDirectories.WrapUp.conditions = {'wrapUp'};
%   StimulusDirectories.WrapUp.directory = [];
%   
%   % Response keys and conditions
%   if isDebuggingRun
%       rightKey = 'm';
%   else
%       rightKey = 'r';
%   end
%   responseKeys = {rightKey};
%   rightConditionLabel = 'target';
%   ResponseParameters.responseKeys = responseKeys;
%   ResponseParameters.rightKey = rightKey;
%   ResponseParameters.rightConditionLabel = rightConditionLabel;
%   ResponseParameters.leftKey = nan;
%   ResponseParameters.leftConditionLabel = nan;
%   
%   % Timing (in seconds)
%   Timing.cStimulusDuration = 1.5;  % seconds
%   Timing.cTrialDuration = 2;  % for debugging mode
%   
%   % Screen size, which is used for sizing the stimulus
%   hScreen = ptbScreenSettings;  % screen settings, including a standard gray background
%   screenSize = Screen('Rect', hScreen); 
%   screenHeight = screenSize(3);
%   
%   % Image size
%   cImageDownsize = PtbParameters.cImageDownsize;
%   imageExtension = PtbParameters.imageExtension;
%   directoryExampleImage = fullfile(directoryStimuli, 'pathways');
%   searchInput = fullfile(directoryExampleImage, ['*' imageExtension]);
%   searchResults = dir(searchInput);
%   exampleImageFile = fullfile(directoryExampleImage, searchResults(1).name);
%   exampleImage = imread(exampleImageFile);
%   exampleImageSize = size(exampleImage);
%   exampleImageSize = exampleImageSize(1 : 2);
%   exampleImageHeight = exampleImageSize(1);
%   largestPossibleScaling = screenHeight / exampleImageHeight;
%   cImageScale = cImageDownsize * largestPossibleScaling;
%   imageSize = exampleImageSize * cImageScale;
%   clear exampleImage searchInput searchResults directoryExampleImage;
%   
%   % Instructions
%   instructions = [
%       'Please fixate on the crosshair and pay attention to each scene.\n\n'...
%       'Press the right button if the scene is a target scene.\n\n'...
%       'Get ready!\n\n'
%       ]; 
% 
%   % Run this session
%   SessionParameters.subjectNumber = subjectNumber;
%   SessionParameters.runNumber = runNumber;
%   SessionParameters.isDebuggingRun = isDebuggingRun;
%   SessionParameters.isTransparentDisplay = isTransparentDisplay;
%   SessionParameters.directorySequences = directorySequences;
%   SessionParameters.StimulusDirectories = StimulusDirectories;
%   SessionParameters.directoryOutput = directoryOutput;
%   SessionParameters.ResponseParameters = ResponseParameters;
%   SessionParameters.Timing = Timing;
%   SessionParameters.imageSize = imageSize;
%   SessionParameters.instructions = instructions;
%   ptbTargetCategoryExperimentA(SessionParameters)
% 
%% See also
%
% * <file:ptbRunExperiment.html ptbRunExperiment>
% * <file:ptbFullfileByCondtion.html ptbFullfileByCondtion>
% * <file:ptbScreenSettings.html ptbScreenSettings>
% * <file:ptbInstructions.html ptbInstructions>
% * <file:ptbWaitForT.html ptbWaitForT>
% * <file:ptbKbQueueCreate.html ptbKbQueueCreate>
% * <file:ptbRelativeToTimeZero.html ptbRelativeToTimeZero>
% * <file:ptbGetResponse.html ptbGetResponse>
% * <file:ptbResponseAccuracy.html ptbResponseAccuracy>
% * <file:ptbCrosshair.html ptbCrosshair>
% * <file:ptbEndRun.html ptbEndRun> 
% 
% Michael F. Bonner | University of Pennsylvania | <http://www.michaelfbonner.com> 



%% Function

function ptbTargetCategoryExperimentA(SessionParameters)


%% Assign variables

% SessionParameters inputs 
subjectNumber = SessionParameters.subjectNumber;
runNumber = SessionParameters.runNumber;
isDebuggingRun = SessionParameters.isDebuggingRun;
isTransparentDisplay = SessionParameters.isTransparentDisplay;
directorySequences = SessionParameters.directorySequences;
directoryOutput = SessionParameters.directoryOutput;
StimulusDirectories = SessionParameters.StimulusDirectories;
ResponseParameters = SessionParameters.ResponseParameters;
Timing = SessionParameters.Timing;
imageSize = SessionParameters.imageSize;
instructions = SessionParameters.instructions;
PtbParameters = SessionParameters.PtbParameters;

% More input parsing
responseKeys = ResponseParameters.responseKeys;
cStimulusDuration = Timing.cStimulusDuration;
cTrialDuration = Timing.cTrialDuration;

% Subject and run
subjectName = ['subj' num2str(subjectNumber, '%03d')];
runName = ['run' num2str(runNumber, '%03d')];

% Output data file
mkdirIF(directoryOutput);
ScanDataFileName = [subjectName runName 'data.mat'];
ScanDataFullFile = fullfile(directoryOutput, ScanDataFileName);

% Check that data has not already been generated for this subject and run
if exist(ScanDataFullFile, 'file')
    error('An output file has already been generated for this subject and run');
end

% Stimulus directories
FullfileParameters.StimulusDirectories = StimulusDirectories;

% Delay before displaying stimulus in debuggind mode
cOnsetDelay = 0;  



%% Load scan sequence
% 
% sequenceFullFile contains the SequenceInfo with the following fields:
% 
% * SequenceInfo.conditionSequence    - sequence of condition labels for
% this run
% * SequenceInfo.stimulusSequence   - sequence of stimulus files for this
% run
% * SequenceInfo.isTimeZero   - sequence of logical values in which the only
% 'true' entry is the first trial after the startUp trials (this represents
% time t=0 if the startUp scans are removed before analyzing the fMRI data)

sequenceFileName = [subjectName runName 'sequence.mat'];
sequenceFullFile = fullfile(directorySequences, sequenceFileName);
load(sequenceFullFile);  % Loads SequenceInfo (described at the top of this code section)
stimulusSequence = SequenceInfo.stimulusSequence;
conditionSequence = SequenceInfo.conditionSequence;
isTimeZeroValues = SequenceInfo.isTimeZero;
timeZeroTrial = find(isTimeZeroValues);



%% Set experiment parameters

% Make display transparent when debugging
if isTransparentDisplay
    screenOpacity = 0.75;
    PsychDebugWindowConfiguration(0, screenOpacity);  % note that timestamping will be inaccurate in this mode
end

% Reseed the random-number generator
rand('state', sum(100 * clock));

% PsychToolbox settings
hScreen = ptbScreenSettings;  % screen settings, including a standard gray background
Screen('Preference', 'SkipSyncTests', 1);  % Override timing check
AssertOpenGL;  % Check for OpenGL compatibility, abort otherwise
KbName('UnifyKeyNames'); % Make sure keyboard mapping is the same on all supported operating systems: Apple MacOS/X, MS-Windows and GNU/Linux:
% ListenChar(2);    % Uncomment this when the experiment is ready to run and has been debugged. This command prevents the key response from being sent to the Matlab screen.

% Position for center of screen
screenSize = Screen('Rect', hScreen); 
screenWidth = screenSize(4);
screenHeight = screenSize(3);
centerWidth = screenWidth / 2;
centerHeight = screenHeight / 2; 

% Crosshair
CrosshairParameters.color = [50 50 50];
CrosshairParameters.width = 20;
CrosshairParameters.height = 20;
CrosshairParameters.thickness = 6;
CrosshairParameters.screenCenterWidth = centerWidth;
CrosshairParameters.screenCenterHeight = centerHeight;
CrosshairParameters.screenHandle = hScreen;

% Text properties
Screen('TextSize', hScreen, 32);  
Screen('TextFont', hScreen, 'Arial');

% Do dummy calls to make sure functions are loaded and ready when we need them - without delays:
WaitSecs(0.1);
GetSecs;



%% Display instructions

InstructionsParameters.instructions = instructions;
InstructionsParameters.screenHandle = hScreen;
InstructionsParameters.textColor = WhiteIndex(hScreen);
ptbInstructions(InstructionsParameters);

% If in debugging moded, wait trial duration, instead of waiting for for
% the first 't' below
if isDebuggingRun
    WaitSecs(cTrialDuration);  
end



%% Pre-allocate output variables
% 
% Notes:
%
% * Relative trial times are calculated relative to the 'isTimeZero' trial
% * Relative reaction times are calculated relative to the stimulus onset

% Get number of events in loop
nTrials = length(stimulusSequence);

% Trial timing
Timing.TrialOnset.raw = nan(nTrials, 1, 'single');
Timing.TrialOnset.relative = nan(nTrials, 1, 'single');
Timing.StimulusOnset.raw = nan(nTrials, 1, 'single');
Timing.StimulusOnset.relative = nan(nTrials, 1, 'single');
Timing.StimulusOffset.raw = nan(nTrials, 1, 'single');
Timing.InterStimulusIntervalOnsets.raw = nan(nTrials, 1, 'single');
Timing.timeZeroTrial = timeZeroTrial;

% Response data
ResponseData.responses = cell(nTrials, 1);
ResponseData.accuracy = nan(nTrials, 1, 'single');
ResponseData.ReactionTime.raw = nan(nTrials, 1, 'single');
ResponseData.ReactionTime.relative = nan(nTrials, 1, 'single');



%% Present stimuli

timeZero = [];
for iTrials = 1 : 5 %nTrials

    % Check for time-zero trial
    isTimeZero = iTrials == timeZeroTrial;
    
    % Condition and stimulus information
    thisCondition = conditionSequence{iTrials};
    thisStimulusFile = stimulusSequence{iTrials};
    FullfileParameters.thisCondition = thisCondition;
    FullfileParameters.thisStimulusFile = thisStimulusFile;
    thisStimulusFullFile = ptbFullfileByCondtion(FullfileParameters);

    % Condition-specific routines
    if strcmp(thisCondition, 'null')  
        
        % Double null events
        
        % First null
        WaitParameters.isDebuggingRun = isDebuggingRun;
        WaitParameters.isTimeZero = isTimeZero;
        WaitParameters.timeZero = timeZero;
        WaitParameters.cTrialDuration = cTrialDuration;  % used only in debugging mode
        WaitOutput = ptbWaitForT(WaitParameters);
        timeZero = WaitOutput.timeZero;
        thisTrialOnset = WaitOutput.thisTrialOnset;
        thisRelativeTrialOnset = WaitOutput.thisRelativeTrialOnset;
        
        % Second null
        WaitOutput = ptbWaitForT(WaitParameters);
        thisIsiOnset = WaitOutput.thisTrialOnset;
        
        % Trial timing
        Timing.TrialOnset.raw(iTrials) = thisTrialOnset;
        Timing.TrialOnset.relative(iTrials) = thisRelativeTrialOnset;
        Timing.InterStimulusIntervalOnsets.raw(iTrials) = thisIsiOnset;
 
    elseif strcmp(thisCondition, 'wrapUp')  
        
        % Wrap-up trials are single null events
        
        % Null
        WaitParameters.isDebuggingRun = isDebuggingRun;
        WaitParameters.isTimeZero = isTimeZero;
        WaitParameters.timeZero = timeZero;
        WaitParameters.cTrialDuration = cTrialDuration;  % used only in debugging mode
        WaitOutput = ptbWaitForT(WaitParameters);
        timeZero = WaitOutput.timeZero;
        thisTrialOnset = WaitOutput.thisTrialOnset;
        thisRelativeTrialOnset = WaitOutput.thisRelativeTrialOnset;
        
        % Trial timing
        Timing.TrialOnset.raw(iTrials) = thisTrialOnset;
        Timing.TrialOnset.relative(iTrials) = thisRelativeTrialOnset;
        
    else
        
        % Stimulus trials: 
        % * startUp
        % * pathways
        % * targetCarryover
        % * fillerCarryover
        % * nullCarryover
        
        % Load stimulus image
        thisImage = imread(thisStimulusFullFile);
        thisImage = imresize(thisImage, imageSize);
        thisImageScreenTexture = Screen('MakeTexture', hScreen, thisImage);
        Screen('DrawTexture', hScreen, thisImageScreenTexture);  % Draw texture image to backbuffer.
        
        % Load crosshair on top of image
        ptbCrosshair(CrosshairParameters);
        
        % Wait for 't'
        WaitParameters.isDebuggingRun = isDebuggingRun;
        WaitParameters.isTimeZero = isTimeZero;
        WaitParameters.timeZero = timeZero;
        WaitParameters.cTrialDuration = cOnsetDelay;  % debugging mode: zero delay at this point
        WaitOutput = ptbWaitForT(WaitParameters);
        timeZero = WaitOutput.timeZero;
        thisTrialOnset = WaitOutput.thisTrialOnset;
        thisRelativeTrialOnset = WaitOutput.thisRelativeTrialOnset;

        % Create KbQueue for responses
        ptbKbQueueCreate(responseKeys)
        KbQueueFlush(); % removes all keyboard presses
        
        % Display stimulus
        [~, thisStimulusOnset] = Screen('Flip', hScreen);  
        thisRelativeStimulusOnset = ptbRelativeToTimeZero(thisStimulusOnset, timeZero);
        
        % Get key response while stimulus is up 
        [thisResponseKey, thisRawReactionTime, thisRelativeReactionTime] = ptbGetResponse(thisStimulusOnset, cStimulusDuration);

        % Compute accuracy
        thisTrialAccuracy = ptbResponseAccuracy(thisResponseKey, thisCondition, ResponseParameters);

        % Display crosshair
        ptbCrosshair(CrosshairParameters);
        [~, thisStimulusOffset] = Screen('Flip', hScreen);

        % Interstimulus interval (one 't')
        IntervalParameters.thisTrialOnset = thisTrialOnset;
        IntervalParameters.isDebuggingRun = isDebuggingRun;
        IntervalParameters.isTimeZero = isTimeZero;
        IntervalParameters.timeZero = timeZero;
        IntervalParameters.cTrialDuration = cTrialDuration;  % used only in debugging mode
        IntervalOutput = ptbInterStimulusInterval(IntervalParameters);
        thisIsiOnset = IntervalOutput.WaitOutput.thisTrialOnset;

        % Trial timing
        Timing.TrialOnset.raw(iTrials) = thisTrialOnset;
        Timing.TrialOnset.relative(iTrials) = thisRelativeTrialOnset;
        Timing.StimulusOnset.raw(iTrials) = thisStimulusOnset;
        Timing.StimulusOnset.relative(iTrials) = thisRelativeStimulusOnset;
        Timing.StimulusOffset.raw(iTrials) = thisStimulusOffset;
        Timing.InterStimulusIntervalOnsets.raw(iTrials) = thisIsiOnset;
        
        % Response data
        ResponseData.responses{iTrials} = thisResponseKey;
        ResponseData.accuracy(iTrials) = thisTrialAccuracy;
        ResponseData.ReactionTime.raw(iTrials) = thisRawReactionTime;
        ResponseData.ReactionTime.relative(iTrials) = thisRelativeReactionTime;
 
    end  % if strcmp(thisCondition, 'null')
    
    Screen('Close');
    
end  % for iTrials = 1 : nTrials



%% Save data

% General experiment information
GeneralInfo.date = date;
GeneralInfo.computer = computer;
GeneralInfo.subject = subjectName;
GeneralInfo.run = runName;
GeneralInfo.SessionParameters = SessionParameters;

% Save all data
ScanData.General = GeneralInfo;
ScanData.Sequence = SequenceInfo;
ScanData.Timing = Timing;
ScanData.Responses = ResponseData;
save(ScanDataFullFile, 'ScanData'); 



%%  End session

EndRunParameters.screenHandle = hScreen;
EndRunParameters.message = 'Great job!';
EndRunParameters.textColor = WhiteIndex(hScreen);
ptbEndRun(EndRunParameters)


end  % function pwExperimentTargetCategoryA(subjectNumber, runNumber)
