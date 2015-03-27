%% ptbCrosshair
%
% Draw a crosshair to the backbuffer
% 
%% Syntax
% 
% ptbCrosshair(CrosshairParameters)
% 
%% Description
% 
% ptbCrosshair draws a crosshair to the backbuffer. This crosshair will
% appear on the next call of Screen('Flip', hScreen).
% 
% * CrosshairParameters.color   - the clut index (scalar or [r g b] triplet) that you want to poke into each pixel
% * CrosshairParameters.thickness   - crosshair thickness in pixels
% * CrosshairParameters.width   - half-width (in pixels) from center
% * CrosshairParameters.height   - half-height (in pixels) from center
% * CrosshairParameters.screenCenterWidth   - position of screen center width
% * CrosshairParameters.screenCenterHeight   - position of screen center height
% * CrosshairParameters.screenHandle   - handle for screen to draw to
%
%% Example
%
%  % Position for center of screen
%  screenSize = Screen('Rect', hScreen); 
%  screenWidth = screenSize(4);
%  screenHeight = screenSize(3);
%  centerWidth = screenWidth / 2;
%  centerHeight = screenHeight / 2; 
%  
%  % Crosshair
%  CrosshairParameters.color = 50;
%  CrosshairParameters.thickness = 6;
%  CrosshairParameters.width = 20;
%  CrosshairParameters.height = 20;
%  CrosshairParameters.screenCenterWidth = centerWidth;
%  CrosshairParameters.screenCenterHeight = centerHeight;
%  CrosshairParameters.screenHandle = hScreen;
%  
%  ptbCrosshair(CrosshairParameters);
%  [~, crosshairOnsetTime] = Screen('Flip', hScreen);
% 
%% See also
% 
% Michael F. Bonner | University of Pennsylvania | <http://www.michaelfbonner.com> 



%% Function

function ptbCrosshair(CrosshairParameters)



%% Assign variables 

% Parameters
thisColor = CrosshairParameters.color;
thisThickness = CrosshairParameters.thickness;
thisWidth = CrosshairParameters.width;
thisHeight = CrosshairParameters.height;
centerWidth = CrosshairParameters.screenCenterWidth;
centerHeight = CrosshairParameters.screenCenterHeight;
hScreen = CrosshairParameters.screenHandle;



%% Draw crosshair to backbuffer

% Crosshair
Screen('DrawLine', hScreen, thisColor, centerHeight - thisHeight, centerWidth, centerHeight + thisHeight, centerWidth, thisThickness);  % Draw fixation cross in center of screen in backbuffer
Screen('DrawLine', hScreen, thisColor, centerHeight, centerWidth - thisWidth, centerHeight, centerWidth + thisWidth, thisThickness);

end  % function ptbCrosshair(CrosshairParameters)
