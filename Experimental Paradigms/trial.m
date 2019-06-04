%%%% FLY ON BALL _ SAPTARSHI TRIAL %%%%
%%          TRIAL STRUCTURE          %%
% 10s WAIT; 40s CLOSED LOOP; 10s WAIT %
% 27.5s WAIT; LEDPULSE 5s; 27.5s WAIT %              

close all ;

% Get NIDAQ Device
HWlist=daq.getDevices;
for i=1:length(HWlist)
    if strcmpi(HWlist(i).Model,'USB-6001')
        NIdaq.dev=HWlist(i).ID;
    end
end
if ~isfield(NIdaq,'dev')
    error('Cannot connect to USB-6001')
end

% Create NIDAQ Session
Session = daq.createSession('ni');

% Setup Sampling
Session.Rate = 1000;

% Camera Channel
Session.addAnalogOutputChannel(NIdaq.dev,'ao1','Voltage');
% LED Channel
Session.addAnalogOutputChannel(NIdaq.dev,'ao0','Voltage');


% LED Output
LedIntensity = 5;
Stim = zeros(Session.Rate*6,1);
Stim(Session.Rate*2:Session.Rate*5) = LedIntensity*ones;
Stim = [Stim; 0] ; 

CameraTrigger = zeros(size(Stim)) ; 
CameraTrigger(1:50) = 5 ; 

plot(Stim,'ro'); hold on; 
plot(CameraTrigger,'bo') ; 
queueOutputData(Session,[Stim CameraTrigger]);
startForeground(Session);
% outputSingleScan(Session,0)