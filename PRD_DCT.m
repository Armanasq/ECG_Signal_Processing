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

% Filter the ECG signal using a bandpass filter
[b, a] = butter(2, [5, 15]/(sampling_frequency/2), 'bandpass');
filtered_ecg_signal = filtfilt(b, a, ecg_signal);

% Apply DCT to the filtered ECG signal
dct_coeffs = dct(filtered_ecg_signal);
num_coeffs = length(dct_coeffs);
num_preserved_coeffs = round(num_coeffs * 0.2);
dct_coeffs_preserved = dct_coeffs;
dct_coeffs_preserved(num_preserved_coeffs+1:end) = 0;
filtered_ecg_signal_reconstructed = idct(dct_coeffs_preserved);

% Calculate the PRD between the original ECG signal and the reconstructed signal
prd = norm(filtered_ecg_signal - filtered_ecg_signal_reconstructed) / norm(filtered_ecg_signal) * 100;

% Display the PRD
disp(['PRD: ', num2str(prd), '%']);

% Plot the original ECG signal and the reconstructed signal
figure;
plot(time_vector, ecg_signal);
hold on;
plot(time_vector, filtered_ecg_signal_reconstructed);
xlabel('Time (s)');
ylabel('Amplitude');
legend('Original', 'Reconstructed');
