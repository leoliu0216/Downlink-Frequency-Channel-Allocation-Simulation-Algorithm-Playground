function dropout_rate_plot()
cell_num=100;
Nc=48;
N0=8;
N_total=56;
Um=8;
SNRdB=10;

% IFRN+FFR
drop_rate(1)=function_IFRN_FFR(cell_num, 1, N0, Nc, Um, SNRdB);

drop_rate(2)=function_IFRN_FFR(cell_num, 3, N0, Nc, Um, SNRdB);

drop_rate(3)=function_IFRN_FFR(cell_num, 7, N0, Nc, Um, SNRdB);

drop_rate(4)=function_IFRN_FFR(cell_num, 13, N0, Nc, Um, SNRdB);

drop_rate(5)=function_IFRN_FFR(cell_num, 19, N0, Nc, Um, SNRdB);

% IFRN
drop_rate1(1)=function_IFRN(cell_num, 1, N_total, Um, SNRdB);

drop_rate1(2)=function_IFRN(cell_num, 3, N_total, Um, SNRdB);

drop_rate1(3)=function_IFRN(cell_num, 7, N_total, Um, SNRdB);

drop_rate1(4)=function_IFRN(cell_num, 13, N_total, Um, SNRdB);

drop_rate1(5)=function_IFRN(cell_num, 19, N_total, Um, SNRdB);

N=[1 3 7 13 19];

plot(N, 100.*drop_rate1,'-o', 'linewidth',1)
hold on
grid on
plot(N, 100.*drop_rate,'-o', 'linewidth',1)
hold on
grid on
legend('Pure IFRN', 'IFRN+FFR')
xlabel('Reuse factor N');
ylabel('Dropout rate %');
end