%% ptbTools_CodeDescriptions  
%
% Generate HTML documentation from filenames and descriptions
% 
%% Syntax
% 
% ptbTools_CodeDescriptions
% 
%% Description
% 
% The name and description of each code file should be entered into the
% CodeNotes structure. These will be written to a TABLE_OF_CONTENTS.m file.
% This and all other m-files in this directory will be published to the
% HTML documentation.
% 
%
%% Example
%
%  ptbTools_CodeDescriptions;
% 
%% See also
% 
% * TABLE_OF_CONTENTS
% * htmlMakeTableOfContents
% * htmlPublishDirectory
% * htmlPublishProject
%
% Michael F. Bonner | University of Pennsylvania | <http://www.michaelfbonner.com> 



%% Assign variables

projectName = 'ptbTools';

% Project directory
thisFullPath = mfilename('fullpath');
directoryMisc = fileparts(thisFullPath);
directoryProject = fileparts(directoryMisc);
cd(directoryProject);



%% Notes on publish directory

thisDirectory = 'ptbTools';
CodeNotes.(thisDirectory).name = thisDirectory;
CodeNotes.(thisDirectory).code = {
   
'ptbSetToolboxDefaults.m'     'Set default parameters and variables';
'ptbScreenSettings.m'   'Set standard screen settings with a gray backrgound and return the screen handle';
'ptbFullfileByCondtion.m'   'Create full filepath for a stimulus dependent on condition';
'ptbWaitForT.m'     'Wait for t';
'ptbDoubleNull.m'   'Double null trial';
'ptbSingleNull.m'   'Single null trial';
'ptbRelativeToTimeZero.m'   'Time stamp relative to time-zero in milliseconds';
'ptbBufferImageAndCrosshairAndWaitForT.m'   'Load image and crosshair to backbuffer and wait for a t';
'ptbInterStimulusInterval.m'    'Wait for a single t';
'ptbCreateRandomTrialSequence.m'    'Create a random sequence bookended by start-up and wrap-up trials';
'ptbCrosshair.m'    'Draw a crosshair to the backbuffer';
'ptbEndRun.m'   'Display message and run common wrap-up functions';
'ptbGetResponse.m'  'Get key response while during stimulus duration';
'ptbInstructions.m'     'Display instructions';
'ptbKbQueueCreate.m'    'Start listening for keys using the KbQueue functions';
'ptbRelativeTime.m'     'Compute relative and rounded time (in milliseconds)';
'ptbResponseAccuracy.m'     'Get response accuracy';
'ptbRunExperiment.m'    'Run all sessions of an experiment';
'ptbTargetCategoryExperimentA.m'    'Category-detection task for fMRI';

};



%% Publish project

PublishProjectParameters.CodeNotes = CodeNotes;
PublishProjectParameters.projectName = projectName;
PublishProjectParameters.directoryProject = directoryProject;
htmlPublishProject(PublishProjectParameters)

