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

% Select first 1000 time steps
ecg_signal = ecg_signal(1:1000);

% Create time vector
time_vector = (0:length(ecg_signal)-1) / sampling_frequency;

% Calculate EMD to level 5
[imf, residual] = emd(ecg_signal, 'MaxNumIMF', 5);

% Plot results
figure;
subplot(6,1,1);
plot(time_vector, ecg_signal);
title('ECG Signal');
ylabel('Amplitude');
xlabel('Time (s)');
grid on;

for i = 1:5
    subplot(6,1,i+1);
    plot(time_vector, imf(:,i));
    title(['IMF ', num2str(i)]);
    ylabel('Amplitude');
    xlabel('Time (s)');
    grid on;
end

subplot(6,1,6);
plot(time_vector, residual);
title('Residual');
ylabel('Amplitude');
xlabel('Time (s)');
grid on;
