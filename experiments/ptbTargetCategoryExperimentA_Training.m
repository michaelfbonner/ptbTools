%% ptbTargetCategoryExperimentA_Training
% 
% Training for ptbTargetCategoryExperimentA
% 
%% Syntax
% 
% ptbTargetCategoryExperimentA_Training(SessionParameters)
% 
%% Description
% 
% ptbTargetCategoryExperimentA_Training a training task for
% ptbTargetCategoryExperimentA with optional feedback on target trials.
% 
% * SessionParameters.isTransparentDisplay   - logical value indicating
% whether the display should be made semi-transparent, which can be
% helpfulf during debugging. 1 indicates a semi-transparent display. 0
% indicates a real experiment and makes the dispay opaque. Transparency
% should only be used during debugging.
% * SessionParameters.Stimuli.experimental - cell array of full file paths
% for experimental stimuli to use during training
% * SessionParameters.Stimuli.experimental - cell array of full file paths
% for target stimuli to use during training
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
%% Example
% 
%   % Import default settings
%   setDefaultsExperimentATraining; 
%   isTransparentDisplay = PtbParameters.isTransparentDisplay;
%   
%   % Directories
%   directoryStimuli = PtbParameters.directoryStimuli;
%   directoryExperimental = fullfile(directoryStimuli, 'pathways');
%   directoryTarget = fullfile(directoryStimuli, 'target');
%   
%   % Add ptbTools paths
%   addpath(genpath(PtbParameters.directoryPtbTools));
%   
%   % Condition labels and associated directories (this will be passed to
%   % ptbFullfileByCondtion)
%   StimulusDirectories.Experimental.conditions = {'pathways'};
%   StimulusDirectories.Experimental.directory = directoryExperimental;
%   StimulusDirectories.Target.conditions = {'target'};
%   StimulusDirectories.Target.directory = directoryTarget;
%   StimulusDirectories.Null.conditions = {'null'};
%   StimulusDirectories.Null.directory = [];
%   
%   % Response keys and conditions
%   rightKey = 'm';
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
%   SearchResults = dir(searchInput);
%   exampleImageFile = fullfile(directoryExampleImage, SearchResults(1).name);
%   exampleImage = imread(exampleImageFile);
%   exampleImageSize = size(exampleImage);
%   exampleImageSize = exampleImageSize(1 : 2);
%   exampleImageHeight = exampleImageSize(1);
%   largestPossibleScaling = screenHeight / exampleImageHeight;
%   cImageScale = cImageDownsize * largestPossibleScaling;
%   imageSize = exampleImageSize * cImageScale;
%   clear exampleImage searchInput searchResults directoryExampleImage;
%   
%   % Experimental stimuli
%   directoryExperimentalStimuli = fullfile(directoryStimuli, 'pathways');
%   searchInput = fullfile(directoryExperimentalStimuli, ['*' imageExtension]);
%   SearchResults = dir(searchInput);
%   nStimuli = length(SearchResults);
%   experimentalStimuli = cell(nStimuli, 1);
%   for iStimuli = 1 : nStimuli
%       experimentalStimuli{iStimuli} = fullfile(directoryExperimentalStimuli,  SearchResults(iStimuli).name);
%   end
%   Stimuli.experimental = experimentalStimuli;
%   
%   % Target stimuli
%   directoryTargetStimuli = fullfile(directoryStimuli, 'target');
%   searchInput = fullfile(directoryTargetStimuli, ['*' imageExtension]);
%   SearchResults = dir(searchInput);
%   nStimuli = length(SearchResults);
%   targetStimuli = cell(nStimuli, 1);
%   for iStimuli = 1 : nStimuli
%       targetStimuli{iStimuli} = fullfile(directoryTargetStimuli,  SearchResults(iStimuli).name);
%   end
%   targetStimuli = targetStimuli(5:8);
%   Stimuli.target = targetStimuli;
%   
%   % Instructions
%   instructions = [
%       'Please fixate on the crosshair and pay attention to each scene.\n\n'...
%       'Press the right button if the scene is a bathroom.\n\n'...
%       'Get ready!\n\n'
%       ]; 
%   
%   % Run this session
%   SessionParameters.isTransparentDisplay = isTransparentDisplay;
%   SessionParameters.Stimuli = Stimuli;
%   SessionParameters.ResponseParameters = ResponseParameters;
%   SessionParameters.Timing = Timing;
%   SessionParameters.imageSize = imageSize;
%   SessionParameters.instructions = instructions;
%   SessionParameters.giveFeedback = false;
%   ptbTargetCategoryExperimentA_Training(SessionParameters)
% 
%% See also
%
% * <file:ptbTargetCategoryExperimentA.html ptbTargetCategoryExperimentA>
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

function ptbTargetCategoryExperimentA_Training(SessionParameters)


%% Assign variables

% SessionParameters inputs 
isDebuggingRun = true;
isTransparentDisplay = SessionParameters.isTransparentDisplay;
Stimuli = SessionParameters.Stimuli;
ResponseParameters = SessionParameters.ResponseParameters;
Timing = SessionParameters.Timing;
imageSize = SessionParameters.imageSize;
instructions = SessionParameters.instructions;
giveFeedback = SessionParameters.giveFeedback;

% Seed random number generator
rand('seed',sum(100*clock));

% More input parsing
responseKeys = ResponseParameters.responseKeys;
cStimulusDuration = Timing.cStimulusDuration;
cTrialDuration = Timing.cTrialDuration;

% Delay before displaying stimulus in debuggind mode
cOnsetDelay = 0;  

% Stimuli
experimentalStimuli = Stimuli.experimental(randperm(length(Stimuli.experimental)));  % randomize
nExperimentalStimuli = length(experimentalStimuli);
targetStimuli = Stimuli.target;
nTargetStimuli = length(targetStimuli);



%% Create sequence

% stimulusSequence = SequenceInfo.stimulusSequence;
% conditionSequence = SequenceInfo.conditionSequence;

proportionNull = 0.1;
nNullEvents = round(proportionNull * (nExperimentalStimuli + nTargetStimuli));

conditions = [repmat({'experimental'}, [nExperimentalStimuli, 1]); repmat({'target'}, [nTargetStimuli, 1]); repmat({'null'}, [nNullEvents, 1])];
conditionSequence = conditions(randperm(length(conditions)));



%% Set experiment parameters

% Make display transparent when debugging
if isTransparentDisplay
    screenOpacity = 0.75;
    PsychDebugWindowConfiguration(0, screenOpacity);  % note that time-stamping will be inaccurate in this mode
end

% Reseed the random-number generator
rand('state', sum(100 * clock));

% PsychToolbox settings
hScreen = ptbScreenSettings;  % screen settings, including a standard gray background
AssertOpenGL;  % Check for OpenGL compatibility, abort otherwise
KbName('UnifyKeyNames'); % Make sure keyboard mapping is the same on all supported operating systems: Apple MacOS/X, MS-Windows and GNU/Linux:

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
    KbWait;  
end



%% Present stimuli

% Get number of events in loop
nTrials = length(conditionSequence);

timeZero = 0;
isTimeZero = false;
experimentalStimulusCounter = 1;
targetStimulusCounter = 1;
for iTrials = 1 : nTrials

    % Condition and stimulus information
    thisCondition = conditionSequence{iTrials};
    if strcmp(thisCondition, 'experimental')
        thisStimulusFile = experimentalStimuli{experimentalStimulusCounter};
        experimentalStimulusCounter = experimentalStimulusCounter + 1;
    elseif strcmp(thisCondition, 'target')
        thisStimulusFile = targetStimuli{targetStimulusCounter};
        targetStimulusCounter = targetStimulusCounter + 1; 
    end

    % Condition-specific routines
    if strcmp(thisCondition, 'null')  
        
        % Double null events
        
        % First null
        WaitParameters.isDebuggingRun = isDebuggingRun;
        WaitParameters.isTimeZero = isTimeZero;
        WaitParameters.timeZero = timeZero;
        WaitParameters.cTrialDuration = cTrialDuration;  % used only in debugging mode
        ptbWaitForT(WaitParameters);

        % Second null
        ptbWaitForT(WaitParameters);
   
    else
        
        % Stimulus trials: 
        % * startUp
        % * pathways
        % * target
        
        % Load stimulus image
        thisImage = imread(thisStimulusFile);
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
        thisTrialOnset = WaitOutput.thisTrialOnset;

        % Create KbQueue for responses
        ptbKbQueueCreate(responseKeys)
        KbQueueFlush(); % removes all keyboard presses
        
        % Display stimulus
        [~, thisStimulusOnset] = Screen('Flip', hScreen);  
        
        % Get key response while stimulus is up 
        [thisResponseKey, ~, ~] = ptbGetResponse(thisStimulusOnset, cStimulusDuration);

        % Compute accuracy
        thisTrialAccuracy = ptbResponseAccuracy(thisResponseKey, thisCondition, ResponseParameters);
        
        % Feedback
        if giveFeedback
            if strcmp(thisCondition, 'target')
                if thisTrialAccuracy==1
                    InstructionsParameters.instructions = 'Correct. That was a target trial.';
                    InstructionsParameters.screenHandle = hScreen;
                    InstructionsParameters.textColor = [0, 0, 255];
                    ptbInstructions(InstructionsParameters);
                    WaitSecs(2)
                else
                    InstructionsParameters.instructions = 'Incorrect. That was a target trial.';
                    InstructionsParameters.screenHandle = hScreen;
                    InstructionsParameters.textColor = [255, 0, 0];
                    ptbInstructions(InstructionsParameters);
                    WaitSecs(2)
                end  % if thisTrialAccuracy==1
            end  % if strcmp(thisCondition, 'target')
        end  % if giveFeedback

        % Display crosshair
        Screen('Close');
        ptbCrosshair(CrosshairParameters);
        Screen('Flip', hScreen);

        % Interstimulus interval (one 't')
        IntervalParameters.thisTrialOnset = thisTrialOnset;
        IntervalParameters.isDebuggingRun = isDebuggingRun;
        IntervalParameters.isTimeZero = isTimeZero;
        IntervalParameters.timeZero = timeZero;
        IntervalParameters.cTrialDuration = cTrialDuration;  % used only in debugging mode
        ptbInterStimulusInterval(IntervalParameters);

    end  % if strcmp(thisCondition, 'null')
    
    Screen('Close');
    
end  % for iTrials = 1 : nTrials



%%  End session

EndRunParameters.screenHandle = hScreen;
EndRunParameters.message = 'Great job!';
EndRunParameters.textColor = WhiteIndex(hScreen);
ptbEndRun(EndRunParameters)


end  % function ptbTargetCategoryExperimentA_Training(subjectNumber, runNumber)
