function stimulus_indices = dyn_oddball_paradigms(paradigm, no_stimuli)
freq_index = 1:no_stimuli;
switch paradigm
case 'roving'
% Roving Oddball Paradigm
%==========================================================================
% Define Trial Order
%-------------------------------------------------------------------------
% Blocks define the number of repetitions per block - these are randomly
% chosen from 5-11 repetitions per block according to the block_order
% variable

blocks = 250;
block_order     = [     ones(1,blocks)*5, ones(1,blocks)*6, ...
                        ones(1,blocks)*7, ones(1,blocks)*8, ...
                        ones(1,blocks)*9, ones(1,blocks)*10, ...
                        ones(1,blocks)*11]; 
                    
block_order     = block_order(randperm(length(block_order))); % produces random vector of blocks
current_freq    = datasample(freq_index, 1);
stimulus_indices = [];

for b = 1:length(block_order)
    this_block = block_order(b); 
    while freq_index(1) == current_freq;    % chooses a new frequency randomly until it is different from current freq
        freq_index = freq_index(randperm(length(freq_index)));
    end;
    current_freq = freq_index(1);       	% defines current frequency  
    
    for t = 1:this_block                    % appends correct no of reps 
        stimulus_indices = [stimulus_indices, current_freq];
    end;
end;
      

case 'hierarchical_short'
%% Hierarchical Roving Paradigm - short standards
%==========================================================================
% Blocks have either 5 (common, i.e. 80% of the time), or 8 (rare, i.e. 20%
% of the time) repetitions

blocks = 1500;
comm_n = blocks * 0.8;
rare_n = blocks - comm_n;

block_order     = [ ones(1,comm_n)*5, ones(1,rare_n)*8 ]; 
block_order     = block_order(randperm(length(block_order)));

current_freq    = datasample(freq_index, 1);
stimulus_indices = [];

for b = 1:length(block_order)
    this_block = block_order(b); 
    while freq_index(1) == current_freq;    % chooses a new frequency randomly until it is different from current freq
        freq_index = freq_index(randperm(length(freq_index)));
    end;
    current_freq = freq_index(1);       	% defines current frequency  
    
    for t = 1:this_block                    % appends correct no of reps 
        stimulus_indices = [stimulus_indices, current_freq];
    end;
end;

case 'hierarchical_long'
%% Reverse directional hiearchical roving paradigm 
%==========================================================================
% This paradigm runs the hierarchical paradigm above in reverse 
% 8 repetitions (.8 common) and 5 repetitions (.2 rare) 
% This allows for a full 2*2 design (global/local by standard/deviant)

blocks = 1500;
comm_n = blocks * 0.8;
rare_n = blocks - comm_n;

block_order     = [ ones(1,comm_n)*8, ones(1,rare_n)*5 ]; 
block_order     = block_order(randperm(length(block_order)));

current_freq    = datasample(freq_index, 1);
stimulus_indices = [];

for b = 1:length(block_order)
    this_block = block_order(b); 
    while freq_index(1) == current_freq;    % chooses a new frequency randomly until it is different from current freq
        freq_index = freq_index(randperm(length(freq_index)));
    end;
    current_freq = freq_index(1);       	% defines current frequency  
    
    for t = 1:this_block                    % appends correct no of reps 
        stimulus_indices = [stimulus_indices, current_freq];
    end;
end;

case 'aaaaB'
%% Hierarchical paradigm 1 according to Dehaene
%==========================================================================
% This paradigm is adapted from the Dehaene group to replicate some of
% their features

blocks  = 1500;
aaaaB   = 0.8 * blocks;
aaaaa   = 1500 - aaaaB;
block_order     = [ ones(1,aaaaB)*1, zeros(1,aaaaa) ]; 
block_order     = block_order(randperm(length(block_order)));

current_freq    = datasample(freq_index, 1);
while freq_index(1) == current_freq;    % chooses a new frequency randomly until it is different from current freq
    freq_index  = freq_index(randperm(length(freq_index)));
end;
stimulus_indices = [];

for b = 1:length(block_order)
    this_block      = block_order(b); 
    block_freqs     = ones(1,5) * current_freq;

    while freq_index(1) == current_freq;    % chooses a new frequency randomly until it is different from current freq
        freq_index = freq_index(randperm(length(freq_index)));
    end;
    current_freq = freq_index(1);       	% defines current frequency  
    
    if this_block == 1
        block_freqs(5) = current_freq;
    end
    stimulus_indices = [stimulus_indices, block_freqs];
    
end;
end;
