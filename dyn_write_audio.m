function dyn_write_audio(folder, fs, freqd, tone_type)
%==========================================================================
% This creates auditory stimuli at specific deviations from a given base
% frequency and saves them in a subfolder of the directory given 
% INPUT     folder  = base directory for analysis (subdirectory: Stimuli)
%           freq    = principal frequency

% Set up variables
%--------------------------------------------------------------------------
sep     = filesep;
dur     = 0.080;        % duration of each event
loud    = 0.2;          % loudness
ramp_l  = 0.01;         % Defines amplitude ramp length to avoid click
freq    = freqd(1);

% Build waves for pure tones
%--------------------------------------------------------------------------
t       = 0:1 / fs:dur;         % calculates time steps at sampling rate

ramp    = ones(size(t));       
up      = 0:1 / fs:ramp_l;
up      = up*100;
down    = flip(up);
ramp(1:length(up))                      = up;
ramp(length(ramp)-length(down)+1:end)   = down;

tones = zeros(length(freqd),length(t)); 

% Prepare directory for writing sound files
%--------------------------------------------------------------------------
stim_dir = [folder sep 'Stimuli'];
if ~exist(stim_dir, 'dir')
    mkdir(stim_dir);
    addpath(genpath(folder));
end;

% Generate sound files as described by 'type'
%--------------------------------------------------------------------------
% TYPE:     simple - single frequency
%           complex - frequency with 2nd and 3rd harmonic

switch tone_type
    
    case 'puretone'
    %----------------------------------------------------------------------
        for j = 1:length(freqd)               % generate waves for each frequency
            tone = sin(2*pi*freqd(j)*t);    % calculates sine waves at sampling intervals t
            tone = tone.*ramp;
            amp = loud*tone;
            tones(j,:) = amp';
        end;        
        
    case 'harmonic'
    %----------------------------------------------------------------------
        for j = 1:length(freqd)
            tone   = sin(2*pi*freqd(j)*t);
            tone_2 = sin(2*pi*2*freqd(j)*t);  
            tone_3 = sin(2*pi*3*freqd(j)*t);
            tone = (tone+tone_2+tone_3).*ramp;
            amp = loud*tone;
            tones(j,:) = amp';
        end;
end

for j=1:length(freqd)
    audiowrite([stim_dir sep num2str(freqd(j)) '_' tone_type '.wav'], tones(j,:), fs);
end;
