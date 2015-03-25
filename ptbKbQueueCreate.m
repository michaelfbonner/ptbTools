%% ptbKbQueueCreate
%
% Start listening for keys using the KbQueue functions
% 
%% Syntax
% 
% ptbKbQueueCreate
% 
%% Description
% 
% ptbKbQueueCreate uses the PsychToolbox KbQueue functions to create a
% queue and immediately start listening for keys
% 
% * kbQueueKeys - cell array of keys to listen for
%
%% Example
%
%  ptbKbQueueCreate({'r', 'b'})
%  KbQueueFlush(); % removes all keyboard presses
%  [~, stimulusOnsetTime] = Screen('Flip', hScreen);
% 
%% See also
%
% * ptbGetResponse
% * ptbRelativeTime
% * ptbResponseAccuracy
% 
% Michael F. Bonner | University of Pennsylvania | <http://www.michaelfbonner.com> 



%% Function

function ptbKbQueueCreate(kbQueueKeys)


%% Initiate a queue to start listening for keys

cNkeys = 256;
theseKeyCodeIndices = KbName(kbQueueKeys);
keylist = zeros(1, cNkeys);
keylist(theseKeyCodeIndices) = 1;
KbQueueCreate([], keylist); % Response queue
KbQueueStart(); % Start listening for key responses


end  % function ptbKbQueueCreate(kbQueueKeys)

