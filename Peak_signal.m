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

% Plot the filtered ECG signal
plot(time_vector, filtered_ecg_signal);

% Label the axes
xlabel('Time (s)');
ylabel('Amplitude');

% Add a marker at each R-peak
hold on;
plot(time_vector(r_locs), filtered_ecg_signal(r_locs), 'rx', 'MarkerSize', 10, 'LineWidth', 2);
hold off;

% Display the R-R intervals
disp(['R-R intervals: ', num2str(rr_intervals'), ' s']);

% R-R intervals: 
% 0.89        0.84        0.83        0.82        0.88        0.94        0.97        0.94        0.93        0.94           1        1.03        1.01        0.98        0.97        0.96        0.97        1.01        0.95         0.9        0.85        0.86        0.96        0.94        0.92        0.84        0.78        0.77        0.81        0.81        0.84        0.83        0.82        0.82         0.9        0.99        0.93        0.89        0.86        0.85        0.86         0.9         0.9        0.92        0.89        0.96        1.01        0.93        0.87        0.82        0.83        0.88        0.88        0.88        0.92         0.9        0.89        0.93        0.89         0.9        0.91        0.92        0.88        0.88        0.93        0.89 s

