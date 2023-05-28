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

% Load noisy ECG signal data from file
try
    noisy_ecg_signal = load('EcgNoise.txt');
catch
    error('Failed to load noisy ECG signal data file');
end

% Set sampling frequency (in Hz)
sampling_frequency = 100;

% Create time vector
time_vector = (0:length(ecg_signal)-1) / sampling_frequency;

% Compute FFT of original ECG signal
[original_signal_fft, frequency_vector] = compute_fft(ecg_signal, sampling_frequency);

% Plot magnitude spectrum of original ECG signal
plot_fft_magnitude_spectrum(frequency_vector, original_signal_fft, 'Magnitude Spectrum of Original ECG Signal');

% Compute FFT of noisy ECG signal
[noisy_signal_fft, frequency_vector] = compute_fft(noisy_ecg_signal, sampling_frequency);

% Plot magnitude spectrum of noisy ECG signal
plot_fft_magnitude_spectrum(frequency_vector, noisy_signal_fft, 'Magnitude Spectrum of Noisy ECG Signal');

% Function to compute FFT of a signal
function [signal_fft, frequency_vector] = compute_fft(signal, sampling_frequency)
    signal_length = length(signal);
    signal_fft = fft(signal);
    signal_fft_magnitude = abs(signal_fft / signal_length);
    frequency_vector = sampling_frequency * (0:signal_length/2) / signal_length;
    signal_fft = signal_fft_magnitude(1:length(frequency_vector));
end

% Function to plot FFT magnitude spectrum
function plot_fft_magnitude_spectrum(frequency_vector, signal_fft, plot_title)
    fig = figure;
    set(fig, 'Position', [100 100 1400 800]);
    plot(frequency_vector, signal_fft);
    title(plot_title);
    xlabel('Frequency (Hz)');
    ylabel('Magnitude');
    xlim([0, 50]);
    if contains(plot_title, "Noisy")
        file_name = "Noisy_ECG_FFT.png"
    else
        file_name = "ECG_FFT.png"
    end
    exportgraphics(fig, file_name, 'Resolution', 150);
end
