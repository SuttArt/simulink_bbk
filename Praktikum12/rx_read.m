function [ rx_sig ] = rx_read( filename )

% Load waveform from .bin file
fid = fopen(filename, 'r');
sig_vec = fread(fid, [2 inf], 'short');

clear rx_sig
rx_sig = sig_vec(1, :) + j*sig_vec(2, :);

fclose(fid);

% High-pass filtering to remove low frequency RF impairment components
HF = dsp.HighpassFilter('SampleRate',20e6,'PassbandFrequency',50e3);
rx_sig = step( HF, transpose( rx_sig ) );

% Plot raw RX waveform
close all
figure; subplot(2,1,1); 
plot( real( rx_sig) ); hold; plot( imag( rx_sig ) ); 
grid on; xlim([0 length(rx_sig)]);
title('Raw RX waveform');

% Load the pre-define OFDM frame preamble needed for frame detection
load('OFDM_preamble.mat');

% Detect start of burst of 10 OFDM frames
xc_thd = 0.6; % Cross-correlation threshold, default to 80%
% NOTE: In case of interference in the recorded waveform, adjust this
% threshold accordingly such that the OFDM frames can be detected at the
% output of the cross-correlator.
xc = xcorr( rx_sig, OFDM_preamble);
xc = xc( end-length( rx_sig )+1:end );
%figure; plot( abs( xc ) );
xc = xc ./ max( abs( xc ) );
[~, ids] = findpeaks(abs(xc), 'MinPeakHeight', xc_thd*max(abs(xc)) );
for i = 1 : 1 : length( ids ) - 9
    maxval = max( ids( i+1:i+9 ) - ids( i:i+8 ) );
    minval = min( ids( i+1:i+9 ) - ids( i:i+8 ) );
    if(  abs( minval ) > 0.8 * 3840*2 && abs( maxval ) < 1.2 * 3840*2 )
        loc = ids( i );
        break;
    end;
end;

% Check if the detection was successful
if( ~exist( 'loc' ) )
    disp('Error: Detection of OFDM frames failed. Check the xcorr threshold.'); 
    return;
end;

% Mark the position of the detected burst to be extracted from the raw 
% RX waveform
subplot(2,1,1); plot( loc+38400, -1.2*max(abs(rx_sig)),...
                      'b^','markersize', 10, 'LineWidth', 2 ); 

% Extract length of 10 OFDM frames
rx_sig = rx_sig( loc - 320*2 : loc - 320*2 + 38400*2 - 1 );
% Normalize rx_sig to peak magnitude of 1
rx_sig = rx_sig ./ max( abs( rx_sig ) ); 

% Zero-padding with a length of 10 OFDM Frame (38400 Sa), needed to match 
% the vector length of the simulated transmission in the Simulink model.
%rx_sig = [ rx_sig; complex( zeros( 38400, 1 ) ) ];

% Plot the extracted burst of 10 OFDM frames for the post-processing
subplot(2,1,2); 
plot( real( rx_sig) ); hold; plot( imag( rx_sig ) ); 
grid on; xlim([0 length(rx_sig)]);
title('Extracted burst of 10 OFDM frames'); 

disp(['Info: ' filename ' is successfully loaded.'])

end