clear
close all
clc

% read ECG data from file
ecg = load('ecg.txt');

% define parameters
threshold = 0.75;
window_size = 15;
s_window_size = 10;
qrs_locations = [];
fs = 100;

% find QRS complex locations
for i = window_size : length(ecg) - window_size
    % Check if value is above threshold and is a local maximum
    if ecg(i) > threshold && ecg(i) == max(ecg(i - window_size:i + window_size +1))
        % Find R peak
        r = i;
        while r < length(ecg) - 1 && ecg(r + 1) >= ecg(r)
            r = r + 1;
        end
        % Find Q peak
        q = find(ecg(i - window_size:r) == min(ecg(i - window_size:r)), 1, 'last') + i - window_size;
        % Find S peak
        
        s_candidates = ecg(r:r + window_size);
        if isempty(s_candidates)
            continue;
        end
        [idx,s ] = min(s_candidates);
        s = s + r ;
        % Add QRS complex location to list
        qrs_locations = [qrs_locations; [q, r, s]];
    end
end

% Find P and T wave locations
pt_locations = [];
for i = 1:length(qrs_locations)
    q = qrs_locations(i,1);
    r = qrs_locations(i,2);
    s = qrs_locations(i,3);
    p_candidates = ecg(q-window_size:q);
    if isempty(p_candidates)
        [, idx] = max(p_candidates);
        p = idx + q - window_size - 1;
    else
        p = q;
    end
    if s+s_window_size < length(ecg)
        t_candidates = ecg(s:s+s_window_size);
    end
    if isempty(t_candidates)
        [, idx] = max(t_candidates);
        t = idx + s - 1;
    else
        t = s;
    end
end


% print the shape of list qrs_locations
disp(['Shape of qrs_locations:', num2str(size(qrs_locations))]);

% plot first 15 QRS complexes
fig = figure;
set(fig, 'Position', [100 100 1400 800]);
for i = 1:15
    q = qrs_locations(i,1); r = qrs_locations(i,2); s = qrs_locations(i,3);
    t = (1:s+50)/fs;
    plot(t, ecg(1:s+50));
    hold on;
end
hold off;
xlabel('Time (s)');
ylabel('ECG signal Voltage (mV)');
title('First 15 QRS complexes');
exportgraphics(fig, 'first_15_QRS.png', 'Resolution', 200);
% number of pulses
disp(['Number of pulses:', num2str(length(qrs_locations))]);


fig = figure;
set(fig, 'Position', [100 100 1400 800]);

% plot ECG signal and three square pulses
subplot(2,1,1);

% initialize a vector of zeros with the same length as the ECG signal
y = zeros(1, length(ecg));

% set the samples corresponding to QRS complexes to 1
for i = 1:length(qrs_locations)
    q = qrs_locations(i,1); 
    r = qrs_locations(i,2); 
    s = qrs_locations(i,3);
    y(q:s) = 1;
end
t = (1:length(ecg))/fs;
plot(t,y)
% set x labels to Time (s)
xlabel('Time (s)');
ylabel('Square pulses');
title('Detected QRS complexes');
ylim([-0.1,1.5])


subplot(2,1,2);
% plot ECG signal
plot(t, ecg, 'k');

hold on;
plot(t,y)

% set x labels to Time (s)
xlabel('Time (s)');
ylabel('ECG signal (mV)');
title('ECG signal with detected QRS complexes');
grid on;

exportgraphics(fig, 'all_pulse.png', 'Resolution', 150);



fig = figure;
set(fig, 'Position', [100 100 1400 800]);
% plot ECG signal and three square pulses
subplot(2,1,1);

% initialize a vector of zeros with the same length as the ECG signal
y = zeros(1, length(ecg));

% set the samples corresponding to QRS complexes to 1
for i = 1:16
    q = qrs_locations(i,1); 
    r = qrs_locations(i,2); 
    s = qrs_locations(i,3);
    y(q:s) = 1;
end
t = (1:length(ecg(1:s+50)))/fs;
y = y(1:length(ecg(1:s+50)));
plot(t,y)
% set x labels to Time (s)
xlabel('Time (s)');
ylabel('Square pulses');
title('Detected QRS complexes');
ylim([-0.1,1.5])


subplot(2,1,2);
% plot ECG signal
plot(t, ecg(1:s+50), 'k');

hold on;
plot(t,y)

% set x labels to Time (s)
xlabel('Time (s)');
ylabel('ECG signal (mV)');
title('ECG signal with detected QRS complexes');
grid on;
exportgraphics(fig, 'first_15_QRS_pulse.png', 'Resolution', 150);
