%% ptbInstructions
%
% Display instructions
% 
%% Syntax
% 
% ptbInstructions(InstructionsParameters)
% 
%% Description
% 
% ptbInstructions displays the instruction message
% 
% * InstructionsParameters.screenHandle   - screen handle
% * InstructionsParameters.instructions   - message to display 
% * InstructionsParameters.textColor   - color of message text 
%
%% Example
%
%  InstructionsParameters.screenHandle = hScreen;
%  InstructionsParameters.instructions = [
%     'Please fixate on the crosshair and pay attention to each scene.\n\n'...
%     'Press the right button if it is the target category.\n\n'...
%     'Get ready!\n\n'
%     ]; 
%  InstructionsParameters.textColor = WhiteIndex(hScreen);
%  ptbInstructions(InstructionsParameters);
% 
%% See also
%
% * ptbEndRun
% 
% Michael F. Bonner | University of Pennsylvania | <http://www.michaelfbonner.com> 


%% Function

function ptbInstructions(InstructionsParameters)


%% Assign variables

% Inputs
hScreen = InstructionsParameters.screenHandle;
instructions = InstructionsParameters.instructions;
textColor = InstructionsParameters.textColor;



%% Display message

DrawFormattedText(hScreen, instructions, 'center', 'center', textColor);
Screen('Flip', hScreen);
Screen('Close');


end  % function ptbInstructions(InstructionsParameters)

