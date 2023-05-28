% Clear workspace, close figures, and clear command window
clear;
close all;
clc;

% Load ECG signal data from file
try
    ecg_signal = load('ecg.txt');
catch
    error('Failed to load ECG signal data file');
end

% Set sampling frequency (in Hz)
sampling_frequency = 100;

% Create time vector
time_vector = (0:length(ecg_signal)-1) / sampling_frequency;

% Calculate the DCT of the signal
dct_signal = dct(ecg_signal);

% Sort the DCT coefficients in descending order of magnitude
[sorted_signal, sort_idx] = sort(abs(dct_signal), 'descend');

% Keep only the top 20% of the DCT coefficients
keep_coefficients = round(length(dct_signal)*0.2);
dct_signal(sort_idx(keep_coefficients+1:end)) = 0;

% Calculate the inverse DCT to reconstruct the signal
reconstructed_signal = idct(dct_signal);

% Calculate the Peak Reconstruction Difference (PRD)
prd = norm(ecg_signal - reconstructed_signal) / norm(ecg_signal);
disp(['PRD: ', num2str(prd), '%']);

% Plot the original and reconstructed signals
figure;
plot(time_vector, ecg_signal);
hold on;
plot(time_vector, reconstructed_signal);
title('Original vs Reconstructed ECG Signal');
xlabel('Time (s)');
ylabel('Amplitude');
legend('Original Signal', 'Reconstructed Signal');


% PRD: 0.34472%

