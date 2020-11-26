clc;clear;
numOfbit = 100000;
Eb = 1;
SNR_dB = 0:0.5:10; %信噪比(dB)
SNR = 10.^(SNR_dB./10);
%BPSK调制符号数
sym_BPSK = 2;
%发送信号
signal_BPSK = randi([0,1],1,numOfbit);
%BPSK调制
txsignal_BPSK = pskmod(signal_BPSK,sym_BPSK,0);

for l=1:length(SNR_dB)
         y_BPSK = awgn(txsignal_BPSK,SNR_dB(l));    %接收信号
         BPSK_demod = pskdemod(y_BPSK, sym_BPSK);   %解调
         sumErrBit = abs(BPSK_demod-signal_BPSK);   
         errorcount_BPSK(l) = sum(sumErrBit);
end

%符号错误概率
 symerr_BPSK = errorcount_BPSK/(numOfbit);
 
 Pes_BPSK = zeros(1,11);
  
%理论值
 for j=1:length(SNR_dB)
   Pes_BPSK(j) = qfunc(sqrt(2*SNR(j)));
 end
 %BPSK AWGN
 figure(1)
 semilogy(SNR_dB,symerr_BPSK,'r',SNR_dB,Pes_BPSK);
 legend('仿真曲线', '理论曲线');
 title('BPSK AWGN信道的仿真理论对比');
 xlabel('信噪比(dB)');
 ylabel('误符号概率');
 
%--------------------------------瑞利衰落信道-----------------------------------------------------

for l=1:length(SNR_dB)
       %BPSK
        alpha  = abs(Ray_model(numOfbit));  %rayleigh 信道
        y_BPSK = awgn(alpha.*txsignal_BPSK,SNR_dB(l)); %接收信号
        BPSK_demod = pskdemod(y_BPSK,sym_BPSK); %解调
        k1 = abs(BPSK_demod-signal_BPSK);   
        Rayerrorcount_BPSK(l) = sum(k1);    %误码数
end
Raysymerr_BPSK =  Rayerrorcount_BPSK / numOfbit;    %误码率

figure(2)
semilogy(SNR_dB,Raysymerr_BPSK,'b',SNR_dB,symerr_BPSK,'r');
legend('Rayleigh信道', 'AWGN信道');
title('BPSK Rayleigh and AWGN ');
xlabel('信噪比（dB）');
ylabel('误码率');     
