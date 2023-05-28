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

% Make signal value zero for timesteps 10000 to 50000
ecg_signal(1000:5000) = 0;

% Compute FFT of modified ECG signal
[modified_signal_fft, frequency_vector] = compute_fft(ecg_signal, sampling_frequency);
disp(size((modified_signal_fft)))

% Compute inverse FFT of modified ECG signal
modified_signal_ifft = ifft(modified_signal_fft);
disp(size((modified_signal_ifft)))


% Plot original ECG signal
plot(time_vector, ecg_signal);
title('Original ECG Signal');
xlabel('Time (s)');
ylabel('Amplitude');

% Plot magnitude spectrum of original ECG signal
plot_fft_magnitude_spectrum(frequency_vector, modified_signal_fft, 'Magnitude Spectrum of Modified ECG Signal');

% Plot reconstructed ECG signal using iFFT
disp(size(time_vector))
plot(frequency_vector, real(modified_signal_ifft));
title('Reconstructed ECG Signal using iFFT');
xlabel('Time (s)');
ylabel('Amplitude');

% Calculate peak-to-peak amplitude of original ECG signal
pp_orig = max(ecg_signal) - min(ecg_signal);

% Calculate peak-to-peak amplitude of reconstructed ECG signal
pp_recon = max(modified_signal_ifft) - min(modified_signal_ifft);

% Calculate PRD

disp(size(ecg_signal))

disp(size(modified_signal_ifft))

disp(size(pp_orig))

disp(size(pp_recon))
prd = (1/length(ecg_signal)) * sqrt(sum((ecg_signal - modified_signal_ifft).^2)) / ((1/2) * (pp_orig + pp_recon)) * 100;

% Print PRD
fprintf('PRD: %.2f%%\n', prd);

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
    file_name = "ECG_FFT.png";
    exportgraphics(fig, file_name, 'Resolution', 150);
end
