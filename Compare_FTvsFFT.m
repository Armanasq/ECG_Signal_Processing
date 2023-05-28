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

% Compute ft of original ECG signal
[original_signal_ft, frequency_vector] = compute_ft(ecg_signal, sampling_frequency);

% Compute FFT of original ECG signal
[original_signal_fft, frequency_vector_fft] = compute_fft(ecg_signal, sampling_frequency);

% Plot magnitude spectra of original ECG signal
fig = figure;
set(fig, 'Position', [100 100 1400 800]);
plot(frequency_vector, original_signal_ft, 'LineWidth', 2);
hold on;
plot(frequency_vector_fft, abs(original_signal_fft), 'LineWidth', 2);
title('Magnitude Spectra of Original ECG Signal - Fourier Transform vs. FFT');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
xlim([0, 50]);
legend('Fourier Transform With For Loop', 'Fast Fourier Transform');
file_name = "ECG_ft_vs_fft.png";
exportgraphics(fig, file_name, 'Resolution', 150);

% Function to compute ft of a signal
function [signal_ft, frequency_vector] = compute_ft(signal, sampling_frequency)
signal_length = length(signal);
t = (0:signal_length-1) / sampling_frequency; % time vector
frequency_vector = linspace(0, sampling_frequency/2, signal_length/2); % frequency vector
signal_ft = zeros(1, length(frequency_vector));
for k = 1:length(frequency_vector)
s = 0;
for n = 1:signal_length
s = s + signal(n) * exp(-1i * 2 * pi * frequency_vector(k) * t(n));
end
signal_ft(k) = abs(s / signal_length); % scale by signal length
end
end

% Function to compute FFT of a signal
function [signal_fft, frequency_vector] = compute_fft(signal, sampling_frequency)
signal_length = length(signal);
signal_fft = fft(signal);
signal_fft_magnitude = abs(signal_fft / signal_length);
frequency_vector = sampling_frequency * (0:signal_length/2) / signal_length;
signal_fft = signal_fft_magnitude(1:length(frequency_vector));
end