%%

recorder = audiorecorder(Fs, 8, 1); % create an audiorecorder object
record(recorder, 10); % record for 10 seconds
pause(10);
p = play(recorder); % listen to recording to verify
y_r = getaudiodata(recorder, "double");

%%

t = [0:length(y_r)-1]*1/Fs;
subplot(211)
plot(t, y_r);
title('Time domain signal');
subplot(212)
plot_ft_rad(y_r, Fs);
title('Magnitude of frequency domain signal');

%%

save custom_modem_rx_quad3.mat y_r Fs f_c msg_length x_sync SymbolPeriod