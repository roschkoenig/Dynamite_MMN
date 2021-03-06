function dynamite_roving(paradigm, tone_type, dur_exp, min_f, max_f, sub, run, folder)

% sub - subject: 'patient1', 'subject1', ...
% run - run number: 1, 2,...
% dur_exp - duration of the experiment or run in minutes: 15

% General Housekeeping
%==========================================================================
InitializePsychSound();

% Manual definitions
%--------------------------------------------------------------------------
addpath(genpath(folder));

freq        = min_f;
freqd       = linspace(min_f, max_f, 10); 
freqd       = floor(freqd);

% Constant definitions and automatic calculations
%--------------------------------------------------------------------------
sep         = filesep;
fs          = 44100;


%% Create files and stimulus presentation order
%==========================================================================
% Write relevant sound files
%--------------------------------------------------------------------------
dyn_write_audio(folder, fs, freqd, tone_type);
stim_dir    = [folder sep 'Stimuli'];

% Define Trial Order
%--------------------------------------------------------------------------
stimulus_indices    = dyn_oddball_paradigms(paradigm, length(freqd));     


%% Stimulus presentation loop
%==========================================================================
startTime           = GetSecs;
currentTime         = startTime;                                    
presentation_count  = 1;      	% to count repetitions
i = 0;                         	% to index while-loop
datalog = [];                	% datalog records frequency, repetition number and time
audio_handle = PsychPortAudio('Open', [], [], 0, fs, 1, [], .05);    

% Loop through individual presentations
%--------------------------------------------------------------------------
while currentTime < startTime + dur_exp * 60            % loop until dur_exp (mins * 60s) has been reached
    i = i+1;
    
    [stimulus, fs] = audioread([stim_dir sep num2str(freqd(stimulus_indices(i))) '_' tone_type '.wav']); % read audio file into matlab vector
    stimulus = stimulus';                                           % transpose to row vector
    
    PsychPortAudio('FillBuffer', audio_handle, stimulus);           % read stimulus into audio buffer
    currentTime = PsychPortAudio('Start', audio_handle, 1, 0, 1);   % play buffered stimulus (returns time stamp)

    % Setting tested for GOS Synamps
    %----------------------------------------------------------------------
    if computer ~= 'MACI64';
        lptwrite(49144, -presentation_count-1);
        WaitSecs(0.03);
        lptwrite(49144, 255);
    end
    
    presentation_count
    %----------------------------------------------------------------------
    
    datalog = [datalog; freqd(stimulus_indices(i)) presentation_count currentTime];
    
    if strcmp(paradigm, 'aaaaB'),     
        if rem(i,5) == 4      
            WaitSecs(0.1);
            if stimulus_indices(i)~= stimulus_indices(i+1)
                presentation_count = 99;
            else presentation_count = presentation_count+1; 
            end
            
        elseif rem(i,5)==0 
            WaitSecs(0.7); 
            presentation_count = 1; 

        else
            presentation_count = presentation_count+1;
            WaitSecs(0.1);   
        end
    else
        WaitSecs(0.4);
        if stimulus_indices(i) == stimulus_indices(i+1)             % presentation_count tracks how often a stimulus has been presented
            presentation_count = presentation_count+1;              % add one if the next is the same stimulus
        else    presentation_count = 1;  
        end; 
  
    end   
end;

PsychPortAudio('Stop',audio_handle);
PsychPortAudio('Close',audio_handle);

if ~exist([folder filesep 'Datalogs'], 'dir')
    mkdir('Datalogs');
end;
save([folder filesep 'Datalogs' filesep sub '_' num2str(run) '_' paradigm '__' tone_type], 'datalog');
    