clc;clear;
numOfbit = 100000;
Eb = 1;
SNR_dB = 0:0.5:10; %�����(dB)
SNR = 10.^(SNR_dB./10);
%BPSK���Ʒ�����
sym_BPSK = 2;
%�����ź�
signal_BPSK = randi([0,1],1,numOfbit);
%BPSK����
txsignal_BPSK = pskmod(signal_BPSK,sym_BPSK,0);

for l=1:length(SNR_dB)
         y_BPSK = awgn(txsignal_BPSK,SNR_dB(l));    %�����ź�
         BPSK_demod = pskdemod(y_BPSK, sym_BPSK);   %���
         sumErrBit = abs(BPSK_demod-signal_BPSK);   
         errorcount_BPSK(l) = sum(sumErrBit);
end

%���Ŵ������
 symerr_BPSK = errorcount_BPSK/(numOfbit);
 
 Pes_BPSK = zeros(1,11);
  
%����ֵ
 for j=1:length(SNR_dB)
   Pes_BPSK(j) = qfunc(sqrt(2*SNR(j)));
 end
 %BPSK AWGN
 figure(1)
 semilogy(SNR_dB,symerr_BPSK,'r',SNR_dB,Pes_BPSK);
 legend('��������', '��������');
 title('BPSK AWGN�ŵ��ķ������۶Ա�');
 xlabel('�����(dB)');
 ylabel('����Ÿ���');
 
%--------------------------------����˥���ŵ�-----------------------------------------------------

for l=1:length(SNR_dB)
       %BPSK
        alpha  = abs(Ray_model(numOfbit));  %rayleigh �ŵ�
        y_BPSK = awgn(alpha.*txsignal_BPSK,SNR_dB(l)); %�����ź�
        BPSK_demod = pskdemod(y_BPSK,sym_BPSK); %���
        k1 = abs(BPSK_demod-signal_BPSK);   
        Rayerrorcount_BPSK(l) = sum(k1);    %������
end
Raysymerr_BPSK =  Rayerrorcount_BPSK / numOfbit;    %������

figure(2)
semilogy(SNR_dB,Raysymerr_BPSK,'b',SNR_dB,symerr_BPSK,'r');
legend('Rayleigh�ŵ�', 'AWGN�ŵ�');
title('BPSK Rayleigh and AWGN ');
xlabel('����ȣ�dB��');
ylabel('������');     
