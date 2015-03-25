%% ptbScreenSettings
%
% Set standard screen settings with a gray backrgound and return the screen
% handle
% 
%% Syntax
% 
% hScreen = ptbScreenSettings
% 
%% Description
% 
% ptbScreenSettings does the following:
% 
% * Gets the screen index
% * Gets the gray index
% * Hides the cursor
% * Sets the blend function to allow for transparent images
% * Gets the sceen handle (hScreen)
% * Sets the handled screen to maximum priority
% 
% * hScreen     - screen handle to use for stimulus presentation
% 
%% Example
%
%  hScreen = ptbScreenSettings;
% 
%% See also
% 
% * ptbEndRun
% 
% Michael F. Bonner | University of Pennsylvania | <http://www.michaelfbonner.com> 



%% Function

function hScreen = ptbScreenSettings


%%  Screen settings

allConnectedScreenIndices = Screen('Screens');
maxScreenIndex = max(allConnectedScreenIndices);  % Grab the display with the maximum index (which should always be the right one on our machines)
grayValue = GrayIndex(maxScreenIndex);  % mean gray value of screen
hScreen = Screen('OpenWindow', maxScreenIndex, grayValue); % gray background 
Screen(hScreen, 'BlendFunction', GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA); % Allow for transparent images
HideCursor
priorityLevel = MaxPriority(hScreen);  % Set priority for script execution to realtime priority:
Priority(priorityLevel);


end  % function hScreen = ptbScreenSettings
