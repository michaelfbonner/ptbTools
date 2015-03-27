%% ptbFullfileByCondtion
%
% Create full filepath for a stimulus dependent on condition
% 
%% Syntax
% 
% thisStimulusFullFile = ptbFullfileByCondtion(FullfileParameters)
% 
%% Description
% 
% ptbFullfileByCondtion creates a full filepath for the stimulus file based
% on its condition label
% 
% * subjectNumber  - subject number
% * runNumber  - run number
% 
% 
%% Example
% 
%  StimulusDirectories.StartUp.conditions = {'startUp'};
%  StimulusDirectories.StartUp.directory = directoryStartUp;
%  StimulusDirectories.Experimental.conditions = {'pathways', 'targetCarryover', 'fillerCarryover', 'nullCarryover'};
%  StimulusDirectories.Experimental.directory = directoryExperimental;
%  StimulusDirectories.Target.conditions = {'target'};
%  StimulusDirectories.Target.directory = directoryTarget;
%  StimulusDirectories.Filler.conditions = {'filler'};
%  StimulusDirectories.Filler.directory = directoryFiller;
%  StimulusDirectories.Null.conditions = {'null'};
%  StimulusDirectories.Null.directory = [];
%  StimulusDirectories.WrapUp.conditions = {'wrapUp'};
%  StimulusDirectories.WrapUp.directory = [];
%  
%  FullfileParameters.StimulusDirectories = StimulusDirectories;
%  FullfileParameters.thisCondition = thisCondition;
%  FullfileParameters.thisStimulusFile = thisStimulusFile;
%  
%  thisStimulusFullFile = ptbFullfileByCondtion(FullfileParameters);
% 
%% See also
% 
% Michael F. Bonner | University of Pennsylvania | <http://www.michaelfbonner.com> 


%% Function 

function thisStimulusFullFile = ptbFullfileByCondtion(FullfileParameters)


%% Assign variables

% Stimulus information
thisCondition = FullfileParameters.thisCondition;
thisStimulusFile = FullfileParameters.thisStimulusFile;

% Directories
StimulusDirectories = FullfileParameters.StimulusDirectories;
stimulusSets = fieldnames(StimulusDirectories);
nStimulusSets = length(stimulusSets);



%%  Create full filepath for stimulus

% Assign directory based on condition
thisStimulusFullFile = [];
for iStimulusSets = 1 : nStimulusSets
    
    % Stimulus set 
    thisStimulusSet = stimulusSets{iStimulusSets};
    
    % Conditions associated with this stimulus directory
    theseConditions = StimulusDirectories.(thisStimulusSet).conditions;
    
    % Create fullfile based on stimulus condition
    isCondition = ismember(theseConditions, thisCondition);
    if any(isCondition)
        thisDirectory = StimulusDirectories.(thisStimulusSet).directory;
        
        % If the directory is empty return 'null', otherwise return the
        % full filepath
        if isempty(thisDirectory)
            thisStimulusFullFile = 'null';  
        else
            thisStimulusFullFile = fullfile(thisDirectory, thisStimulusFile);
        end

    end
    
end

% Error checking
if isempty(thisStimulusFullFile)
    error('thisCondition not recognized')
end


end  % function thisStimulusFullFile = ptbFullfileByCondtion(StimulusDirectories)

