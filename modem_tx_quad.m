Fs = 8192;
f_c = 1000;
bits_to_send_cosine = StringToBits('May the 4th be with you!');
bits_to_send_sine = StringToBits('Live long and prosper.  ');
% for now, strings must have equal lengths
msg_length = length(bits_to_send_cosine)/8;
SymbolPeriod = 100;

% convert the vector of 1s and 0s to 1s and -1s
m_c = 2*bits_to_send_cosine-1;
% create a waveform that has a positive box to represent a 1
% and a negative box to represent a zero
m_c_us = upsample(m_c, SymbolPeriod);
m_c_boxy = conv(m_c_us, ones(SymbolPeriod, 1));
% figure; plot(m_c_boxy); % visualize the boxy signal

% create a cosine with analog frequency f_c
c_c = cos(2*pi*f_c/Fs*[0:length(m_c_boxy)-1]');
% create the transmitted signal
x_c_tx = m_c_boxy.*c_c;
% figure; plot(x_c_tx)  % visualize the transmitted signal

% convert the vector of 1s and 0s to 1s and -1s
m_s = 2*bits_to_send_sine-1;
% create a waveform that has a positive box to represent a 1
% and a negative box to represent a zero
m_s_us = upsample(m_s, SymbolPeriod);
m_s_boxy = conv(m_s_us, ones(SymbolPeriod, 1));
% figure; plot(m_s_boxy); % visualize the boxy signal

% create a cosine with analog frequency f_c
c_s = sin(2*pi*f_c/Fs*[0:length(m_s_boxy)-1]');
% create the transmitted signal
x_s_tx = m_s_boxy.*c_s;
% figure; plot(x_s_tx)  % visualize the transmitted signal

% create  noise-like signal 
% to synchronize the transmission
% this same noise sequence will be used at
% the receiver to line up the received signal
% This approach is standard practice in real communications
% systems.
randn('seed', 1234);
x_sync = randn(Fs/4,1);
x_sync = x_sync/max(abs(x_sync))*0.5;

% stick it at the beginning of the transmission
x_tx = x_c_tx/2 + x_s_tx/2;

% figure
% hold on
% plot(x_c_tx, 'b')
% plot(x_s_tx, 'r')
% plot(x_tx, 'g')
% xlim([10000, 10500])

figure
plot_ft_rad(x_c_tx, Fs)
figure
plot_ft_rad(x_s_tx, Fs)
figure
plot_ft_rad(x_tx, Fs)

x_tx = [x_sync;x_tx];
save sync_noise.mat x_sync Fs msg_length
% write the data to a file
% audiowrite('quad_message.wav', x_c_tx, Fs);
audiowrite('quad_message.wav', x_tx, Fs);


