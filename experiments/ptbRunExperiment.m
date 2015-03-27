%% ptbRunExperiment
%
% Run all sessions of an experiment
% 
%% Syntax
% 
% ptbRunExperiment(ExperimentParameters)
% 
%% Description
% 
% ptbRunExperiment runs all sessions for an experiment by iteratively
% passing the subjectNumber and runNumber to the experiment function. This
% function creates a RunLog file and updates after each run. The RunLog
% file is used to determine which runs have already been completed for this
% subject.
% 
% * ExperimentParameters.directoryOutput    - directory to save the RunLog
% to
% * ExperimentParameters.nRuns  - number of runs in the experiment
% * ExperimentParameters.experimentFunction     - name of the experiment
% function
%
%% Example
%
%   % Import default settings
%   setPtbParameters_TargetCategory_v001;
%   
%   % Directories
%   directorySequences = PtbParameters.directorySequences;
%   directoryOutput = PtbParameters.directoryOutput;
%   directoryPtbTools = PtbParameters.directoryPtbTools;
%   
%   % Add ptbTools paths
%   addpath(directoryPtbTools);
%   
%   % Get total number of runs
%   SequenceParametersFullFile = fullfile(directorySequences, 'SequenceParameters.mat');
%   load(SequenceParametersFullFile);  % Loads SequenceParameters
%   nRuns = SequenceParameters.nRuns;
%   clear SequenceParameters;
%    
%   % Run experiment
%   ExperimentParameters.directoryOutput = directoryOutput;
%   ExperimentParameters.nRuns = nRuns;
%   ExperimentParameters.experimentFunction = 'scannerProtocol_ptbTargetCategory_v001';
%   ptbRunExperiment(ExperimentParameters)
% 
%% See also
% 
% * <file:ptbTargetCategoryExperimentA.html ptbTargetCategoryExperimentA>
% 
% Michael F. Bonner | University of Pennsylvania | <http://www.michaelfbonner.com> 



%% Function

function ptbRunExperiment(ExperimentParameters)


%% Assign variables

% Inputs
directoryOutput = ExperimentParameters.directoryOutput;
nRuns = ExperimentParameters.nRuns;
experimentFunction = ExperimentParameters.experimentFunction;

% Output directory
if ~exist(directoryOutput, 'dir')
    mkdir(directoryOutput);
end

% Prompt for subject number
clc
subjectNumber = input('Subject number?: ');
subjectName = ['subj' num2str(subjectNumber, '%03d')];



%% Check if any sessions have already been run for this subject
% 
% Load the RunLogFullFile, which loads the RunLog structure:
% * RunLog.(subjectName).Runs(runNumber).complete

% Log file
RunLogFile = 'RunLog.mat';
RunLogFullFile = fullfile(directoryOutput, RunLogFile);

% Load RunLog and calculate startRun
if exist(RunLogFullFile, 'file')
    load(RunLogFullFile);
    nRunsComplete = length(RunLog.(subjectName).Runs);
else
    nRunsComplete = 0;
end
startRun = nRunsComplete + 1;

% Ask if the startRun is correct
startRunPrompt = [num2str(nRunsComplete) ' runs have already been run for this subject. Start at run ' num2str(startRun) '? (y or n): '];
clc
startRunResponse = input(startRunPrompt, 's');
isStartRunCorrect = strcmp('y', startRunResponse);

% Abort experiment if the start run is incorrect
if ~isStartRunCorrect
    disp('Experiment stopped because of incorrect start run. You may need to edit the RunLog to fix this.')
    clear
    return  
end



%% Loop through experimental runs
%
% Execute each run of the experiment. Give the experimenter the option to
% abort between runs and save the RunLog file. If there is an error during
% the run, the RunLog file is saved before exiting. This means that
% experimenter should be able to clear the workspace and just run the
% script again once the error has been resolved.

for iRuns = startRun : nRuns
    
    % Run experiment
    try
        feval(experimentFunction, subjectNumber, iRuns);
    catch ME
        save(RunLogFullFile, 'RunLog');  % save before exiting
        rethrow(ME)
    end
    
    % Update RunLog
    RunLog.(subjectName).Runs(iRuns).complete = true;
    
    % Prompt to start next experiment
    if iRuns < nRuns
        nextRunPrompt = ['Start run ' num2str(iRuns + 1)  ' of ' num2str(nRuns) '? (y or n):'];
        clc
        nextRunResponse = input(nextRunPrompt, 's');
        isReadyForNextRun = strcmp('y', nextRunResponse);
        if ~isReadyForNextRun
            save(RunLogFullFile, 'RunLog');  % save before exiting
            disp('Experiment stopped. The RunLog was saved. When ready, run this script again to continue to the next run.')
            break
        end  % if ~isReadyForNextRun
    else
        disp('End of experiment')
    end  % if iRuns < nRuns
    
end  % for iRuns = startRun : nRuns

% Save RunLog
save(RunLogFullFile, 'RunLog');


end  % function ptbRunExperiment(ExperimentParameters)

