function avg_cap_N_plot()
cell_num=60;
Nc=56;
Um=8;
SNRdB=1:20;

cap1=function_IFRN(cell_num, 1, Nc, Um, SNRdB);

cap3=function_IFRN(cell_num, 3, Nc, Um, SNRdB);

cap7=function_IFRN(cell_num, 7, Nc, Um, SNRdB);

cap13=function_IFRN(cell_num, 13, Nc, Um, SNRdB);

cap19=function_IFRN(cell_num, 19, Nc, Um, SNRdB);


plot(SNRdB,cap1,'-o', 'linewidth',1)
hold on
plot(SNRdB,cap3,'-o', 'linewidth',1)
hold on
plot(SNRdB,cap7,'-o', 'linewidth',1)
hold on
plot(SNRdB,cap13,'-o', 'linewidth',1)
hold on
plot(SNRdB,cap19,'-o', 'linewidth',1)
hold on
grid on
legend('IFR1','IFR3','IFR7','IFR13','IFR19')
xlabel('SNR(dB)');
ylabel('Average network capacity in bps/Hz');

end