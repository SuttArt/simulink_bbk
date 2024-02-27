% Extract 10 OFDM frames to be transmitted from the generated waveform in
% the Simulink model
sig = transpose( out.tx_sig(1:2*10*3840) );

% Create .bin file
filename = 'TX.bin';
fid = fopen(filename, 'w');

% Define number of waveform repetitions and guard interval
repetitions = 1;
guard = length(sig);

% Format the I and Q components as required by the SDR link
sig_vec_c = [ real(sig); imag(sig) ];
max_abs = max(abs([real(sig) imag(sig)]));

% Limit DAC output to prevent output power non-linearities
max_int_val = round(32768*0.5);

sig_vec = (max_int_val/max_abs)*reshape(sig_vec_c, 1, []);

sig_vec_2 = [];
for i = 1:repetitions
    sig_vec_2 = [sig_vec_2 sig_vec zeros(1, 2*guard)];
end

% Save .bin file 
fwrite(fid, sig_vec_2, 'short');
fclose(fid);

disp('Info: TX.bin is successfully generated.')

