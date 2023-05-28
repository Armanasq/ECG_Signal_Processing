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

% Define the degree of the autoregressive model
degree = 10;

% Convert the ECG signal to a column vector
ecg_signal = ecg_signal(:);

% Normalize the ECG signal to have zero mean and unit variance
ecg_signal = (ecg_signal - mean(ecg_signal)) / std(ecg_signal);

% Estimate the coefficients of the autoregressive model
ar_model = ar(ecg_signal, degree);

% Extract the autoregressive coefficients from the estimated model
ar_coefficients = ar_model.A;

% Display the estimated autoregressive coefficients
disp('Estimated Autoregressive Coefficients:');
disp(ar_coefficients');

% Generate the autoregressive model output
ar_output = filter(ar_coefficients, 1, ecg_signal);

% Add normal noise to the autoregressive model output
noise_variance = 0.01; % Adjust the noise variance as needed
noise_signal = sqrt(noise_variance) * randn(size(ar_output));
ar_output_with_noise = ar_output + noise_signal;

% Calculate y[n] for 6000 time steps
n = 1:6000;
y = filter(1, ar_coefficients, ar_output_with_noise);
y = y(n);

% Plot y[n]
t = n / sampling_frequency;
plot(t, y, 'b', 'LineWidth', 1.5);
title('Output y[n] of Autoregressive Model with Noise');
xlabel('Time (seconds)');
ylabel('Amplitude');

%{
Estimated Autoregressive Coefficients:
    1.0000
   -1.3571
    1.1116
   -0.4674
    0.1535
   -0.0867
    0.1888
   -0.1949
    0.1771
   -0.1122
    0.0489
%}