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

% Find the R-peaks using the 'findpeaks' function
[~, r_locs] = findpeaks(filtered_ecg_signal, 'MinPeakHeight', 0.6, 'MinPeakDistance', 0.3*sampling_frequency);

% Calculate the R-R intervals
rr_intervals = diff(r_locs) / sampling_frequency;

% Set the DCT parameters
num_coeffs = 20; % number of coefficients to keep
window_length = 256; % window length for DCT

% Apply DCT to each window of the filtered signal
dct_coeffs = zeros(size(filtered_ecg_signal));
for i = 1:window_length:length(filtered_ecg_signal)-window_length+1
    window = filtered_ecg_signal(i:i+window_length-1);
    dct_window = dct(window);
    dct_window(num_coeffs+1:end) = 0; % discard coefficients
    idct_window = idct(dct_window);
    dct_coeffs(i:i+window_length-1) = idct_window;
end

% Plot the filtered ECG signal and the DCT coefficients
plot(time_vector, filtered_ecg_signal);
hold on;
plot(time_vector, dct_coeffs, 'r');
hold off;

% Label the axes
xlabel('Time (s)');
ylabel('Amplitude');

% Add a marker at each R-peak
hold on;
plot(time_vector(r_locs), filtered_ecg_signal(r_locs), 'rx', 'MarkerSize', 10, 'LineWidth', 2);
hold off;

% Display the R-R intervals
disp(['R-R intervals: ', num2str(rr_intervals'), ' s']);
