function main_plot()
cell_num=60;
reuse_factor=13;
N0=12;
Nc=52;
Um=6;
N=N0+Nc;
SNRdB=1:15;
U_max=20;

net_cap_IFRN=function_IFRN(cell_num, reuse_factor, N, Um, SNRdB);
net_cap_IFRN_FFR=function_IFRN_FFR(cell_num, reuse_factor, N0, Nc, Um, SNRdB);
net_cap_IFRN_FFR_SWF=function_IFRN_FFR_SWF(cell_num, reuse_factor, N0, Nc, Um, SNRdB);

plot(SNRdB,net_cap_IFRN,'-o', 'linewidth',1)
hold on
plot(SNRdB, net_cap_IFRN_FFR,'-o', 'linewidth',1)
hold on
plot(SNRdB, net_cap_IFRN_FFR_SWF,'-o', 'linewidth',1);
grid on
hold on
legend('IFRN','IFRN+FFR','IFRN+FFR(SWF)')
xlabel('SNR(dB)');
ylabel('Average network capacity in bps/Hz');
end