% Define parameters
fc1 = 1000;             % Carrier frequency of the first signal
fc2 = 2000;             % Carrier frequency of the second signal
fs = 8000;              % Sampling frequency (sampling rate)
fDev = 50;              % Frequency deviation
gain = 2;               % Amplifier gain
t = 0:1/fs:1-1/fs;      % Time vector

% Define the input signals
x1 = sin(2*pi*100*t);   % First signal
x2 = sin(2*pi*200*t);   % Second signal

% Plot the input signals in time domain
figure;
t = linspace(0, length(x1)/fs, length(x1));
subplot(1,2,1)
plot(t, x1);
xlim([0 0.1])
title('Signal 1 (Time Domain)')
xlabel('time')
ylabel('amplitude')
pause(2);
sound(x1, fs);
pause(5);

t = linspace(0, length(x2)/fs, length(x2));
subplot(1,2,2)
plot(t, x2);
xlim([0 0.1])
title('Signal 2 (Time Domain)')
xlabel('time')
ylabel('amplitude')
pause(2);
sound(x2, fs);
pause(5);

% Find the frequency domain representation of the signal
X1 = fftshift(fft(x1));     
X2 = fftshift(fft(x2));

% Plot the input signals in frequency domain
figure;
f = fs/2*linspace(-1, 1, fs);
subplot(1,2,1)
plot(f, abs(X1));
xlim([-fs/2 fs/2])
title('Signal 1 (Frequency Domain)')
xlabel('frequency')
ylabel('amplitude')

subplot(1,2,2)
plot(f, abs(X2));
xlim([-fs/2 fs/2])
title('Signal 2 (Frequency Domain)')
xlabel('frequency')
ylabel('amplitude')
pause(3);

% Modulate the input singals
y1 = fmmod(x1, fc1, fs, fDev);      % Modulation of signal 1
y2 = fmmod(x2, fc2, fs, fDev);      % Modulation of signal 2
y = y1 + y2;                        % Summation of the two modulated signals for transmission

% Calculate the Fast Fourier Transform of modulated signals
Y1 = fftshift(fft(y1));     
Y2 = fftshift(fft(y2));
Y = fftshift(fft(y));

% Plot the modulated signals
figure;
subplot(2,2,1)
plot(f, abs(Y1));
xlim([-fs/2 fs/2])
title('Modulation of Signal 1')
xlabel('frequency')
ylabel('amplitude')

subplot(2,2,2)
plot(f, abs(Y2));
xlim([-fs/2 fs/2])
title('Modulation of Signal 2')
xlabel('frequency')
ylabel('amplitude')

t = linspace(0, length(y)/fs, length(y));
subplot(2,2,3)
plot(t, y);
xlim([0 0.1])
title('Transmission Signal (Time)')
xlabel('Time')
ylabel('amplitude')

subplot(2,2,4)
plot(f, abs(Y));
xlim([-fs/2 fs/2])
title('Transmission Signal (Freq)')
xlabel('frequency')
ylabel('amplitude')
pause(3);

% Amplify the transmission signal
y_amp = y * gain;

% Select the desired signal
switch_pos = 1;         % Switch position (0 or 1)
if switch_pos == 0
    f0 = fc1;
else
    f0 = fc2;
end
y_sel = bandpass(y_amp, [f0-250, f0+250], fs);

% Demodulate the selected signal
y_demod = fmdemod(y_sel, f0, fs, fDev); % Demodulated signal

% Amplify and play the output signal
y_audio_sel = y_demod * gain;           % Amplified output audio signal
sound(y_audio_sel, fs);                 % Play signal through speaker

% Plot the output signal
t = linspace(0, length(y_audio_sel)/fs, length(y_audio_sel));
figure;
subplot(1,2,1)
plot(t, y_audio_sel);
xlim([0.01 0.1])
title('Output Signal (Time)')
xlabel('time')
ylabel('amplitude')

Y_demod = fftshift(fft(y_demod));
subplot(1,2,2)
plot(f, abs(Y_demod));
xlim([-fs/2 fs/2])
title('Output Signal (Freq)')
xlabel('frequency')
ylabel('amplitude')
