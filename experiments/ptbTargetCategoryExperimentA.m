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
% target-category detection task
% 
% * SessionParameters.subjectNumber = subjectNumber;
% * SessionParameters.runNumber = runNumber;
% * SessionParameters.isDebuggingRun = isDebuggingRun;
% * SessionParameters.isTransparentDisplay = isTransparentDisplay;
% * SessionParameters.directorySequences = directorySequences;
% * SessionParameters.StimulusDirectories = StimulusDirectories;
% * SessionParameters.directoryOutput = directoryOutput;
% * SessionParameters.ResponseParameters = ResponseParameters;
% * SessionParameters.Timing = Timing;
% * SessionParameters.imageSize = imageSize;
% * SessionParameters.instructions = instructions;
% * SessionParameters.PtbParameters = PtbParameters; 
%
%% Example
% 
%  SessionParameters.subjectNumber = subjectNumber;
%  SessionParameters.runNumber = runNumber;
%  SessionParameters.isDebuggingRun = isDebuggingRun;
%  SessionParameters.isTransparentDisplay = isTransparentDisplay;
%  SessionParameters.directorySequences = directorySequences;
%  SessionParameters.StimulusDirectories = StimulusDirectories;
%  SessionParameters.directoryOutput = directoryOutput;
%  SessionParameters.ResponseParameters = ResponseParameters;
%  SessionParameters.Timing = Timing;
%  SessionParameters.imageSize = imageSize;
%  SessionParameters.instructions = instructions;
%  SessionParameters.PtbParameters = PtbParameters;
%  ptbTargetCategoryExperimentA(SessionParameters)
% 
%% See also
%
% * <file:ptbRunExperiment.html ptbRunExperiment>
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
% * SequenceInfo.conditionSequence    - sequence of condition labels for
% this run
% * SequenceInfo.stimulusSequence   - sequence of stimulus files for this
% run
% * SequenceInfo.isTimeZero   - equence of logical values in which the only
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
GeneralInfo.PtbParameters = PtbParameters;

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





