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

% Select first 300 time steps
ecg_signal = ecg_signal(1:300);

% Create 10 different signals with added noise
num_signals = 10;
noise_mean = 0;
noise_var = 2;

signals = zeros(num_signals, length(ecg_signal));

for i = 1:num_signals
    noise = normrnd(noise_mean, noise_var, size(ecg_signal));
    signals(i,:) = ecg_signal + noise;
end

% Plot first three signals
figure;
plot(time_vector(1:300), signals(1:3, 1:300));
xlabel('Time (s)');
ylabel('Amplitude');
title('ECG signals with added noise');

% Calculate average of all signals and plot
average_signal = zeros(1,300);
for i = 1:num_signals
    average_signal = signals(i,1:300) + average_signal;
end
average_signal = average_signal/10;

figure;
plot(time_vector(1:300), average_signal(1:300));
xlabel('Time (s)');
ylabel('Amplitude');
title('Average ECG signal with added noise');
