% Define the parameters
fc1 = 1000; % Carrier frequency of the first signal
fc2 = 2000; % Carrier frequency of the second signal
fs = 8000; % Sampling frequency
t = 0:1/fs:1-1/fs; % Time vector
fDev = 50;

% Define the signals
x1 = sin(2*pi*100*t); % First sine wave signal
t=linspace(0,length(x1 )/fs,length(x1));
figure;
plot(t,x1);
title('x1')
xlabel('time')
ylabel('amplitude')
pause(2);
sound(x1, fs);
pause(5);


x2 = sin(2*pi*200*t); % Second sine wave signal
t=linspace(0,length(x2)/fs,length(x2));
figure;
plot(t,x2);
title('x2')
xlabel('time')
ylabel('amplitude')
pause(2);
sound(x2, fs);
pause(5);

% Modulate the signals using VCO circuits
y1 = fmmod(x1, fc1, fs,fDev); % Modulated signal 1
y2 = fmmod(x2,fc2, fs,fDev); % Modulated signal 2

% Sum the two modulated signals
y = y1 + y2;

% Pass the modulated signals through a power amplifier
gain = 2; % Amplifier gain
y_amp = y * gain;

% Transmit the amplified signal

% Demodulate the transmitted signal using a phase-locked loop (PLL)
f0 = fc1 + fc2; % Carrier frequency of the transmitted signal
fDev = 50; % Frequency deviation of the transmitted signal
y_demod = fmmod(y_amp, f0, fs, fDev); % Demodulated signal

% Pass the demodulated signal through a selection circuit that chooses between the two input signals using a switch
switch_pos = 0; % Switch position (0 or 1)
if switch_pos == 0
    y_sel = y2;
    f0=fc2;
else
    y_sel = y1;
    f0=fc1;
end

% Demodulate the selected signal using another phase-locked loop (PLL)
%f0 = fc1; % Carrier frequency of the selected signal
fDev = 50; % Frequency deviation of the selected signal
y_demod_sel = fmdemod(y_sel, f0, fs, fDev); % Demodulated signal

% Pass the demodulated selected signal through another power amplifier and output in speaker
y_audio_sel = y_demod_sel * gain; % Amplified audio signal
sound(y_audio_sel, fs); % Output audio signal in speaker
t=linspace(0,length(y_audio_sel )/fs,length(y_audio_sel));
figure;
plot(t,y_audio_sel );
title('y_audio_sel ')
xlabel('time')
ylabel('amplitude')