function dyn_soundcheck(varargin)
duration    = 0.1;
freq        = 500;
tone_type   = 'harmonic';

switch nargin       
    case 1
        duration    = varargin{1};
    case 2
        duration    = varargin{1};
        freq        = varargin{2};
    case 3
        duration    = varargin{1};
        freq        = varargin{2};
        tone_type        = varargin{3};
end

% General Housekeeping
%==========================================================================
InitializePsychSound();
sep         = filesep;
fs          = 44000;
folder      = 'C:\Users\rrosch\Dropbox\Research\Friston Lab\1510 Dynamite\Paradigms';
stim_dir    = [folder sep 'Stimuli'];
audio_handle = PsychPortAudio('Open', [], [], 0, fs, 1, [], .05);
startTime   = GetSecs;
currentTime = startTime;

% Stimulus presentation loop
%--------------------------------------------------------------------------
while currentTime < startTime + 60*duration
    [stimulus, ff] = audioread([stim_dir sep num2str(freq) '_' tone_type '.wav']);
    stimulus = stimulus';
    PsychPortAudio('FillBuffer', audio_handle, stimulus);
    currentTime = PsychPortAudio('Start', audio_handle, 1, 0, 1);
    jitter = 0.05 * (rand-.5);
    WaitSecs(0.4 + jitter);
end

end