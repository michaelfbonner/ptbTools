%% ptbEndRun
%
% Display message and run common wrap-up functions
% 
%% Syntax
% 
% ptbEndRun(EndRunParameters)
% 
%% Description
% 
% ptbEndRun displays a message and then closes all screens, shows the
% cursors and resets the screen priority
% 
% * EndRunParameters.screenHandle   - screen handle
% * EndRunParameters.message   - message to display 
% * EndRunParameters.textColor   - color of message text 
%
%% Example
%
%  EndRunParameters.screenHandle = hScreen;
%  EndRunParameters.message = 'Great job!';
%  EndRunParameters.textColor = WhiteIndex(hScreen);
%  ptbEndRun(EndRunParameters)
% 
%% See also
%
% * ptbScreenSettings
% 
% Michael F. Bonner | University of Pennsylvania | <http://www.michaelfbonner.com> 



%% Function

function ptbEndRun(EndRunParameters)


%% Assign variables

% Inputs
hScreen = EndRunParameters.screenHandle;
message = EndRunParameters.message;
textColor = EndRunParameters.textColor;



%% Display message

DrawFormattedText(hScreen, message, 'center', 'center', textColor);
Screen('Flip', hScreen);
WaitSecs(2);



%% Wraup-up experiment

Screen('CloseAll');
ShowCursor;
Priority(0);


end  % function ptbEndRun(hScreen)


