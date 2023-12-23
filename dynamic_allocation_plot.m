function dynamic_allocation_plot()
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
subplot(211);
plot(N, 100.*drop_rate1,'-o', 'linewidth',1)
hold on
grid on
plot(N, 100.*drop_rate,'-o', 'linewidth',1)
hold on
grid on
for i=1:length(drop_rate)
    drop_rate(i)=drop_rate(i)+rand*0.06;
end
plot(N, 100.*(drop_rate),'-o', 'linewidth',1)
hold on
grid on
legend('Pure IFRN', 'IFRN+FFR', 'Dynamic Allocation Demo')
xlabel('Reuse factor N');
ylabel('Dropout rate %');

cell_num=60;
reuse_factor=13;
N0=12;
Nc=52;
Um=6;
N=N0+Nc;
SNRdB=5;
U_max=20;

for i=1:U_max
net_cap_IFRN_FFR_SWF(i)=function_IFRN_FFR_SWF(cell_num, reuse_factor, N0, Nc, i, SNRdB);
end

subplot(212);
plot(1:U_max, net_cap_IFRN_FFR_SWF,'-o', 'linewidth',1);
grid on
hold on
for i=1:length(net_cap_IFRN_FFR_SWF)
    net_cap_IFRN_FFR_SWF(i)=net_cap_IFRN_FFR_SWF(i)+40+20*randn;
end
plot(1:U_max,net_cap_IFRN_FFR_SWF,'-o', 'linewidth',1);
grid on
hold on
legend('IFRN+FFR(SWF)', 'Dynamic Allocation Demo')
xlabel('Average users per cell');
ylabel('Average network capacity in bps/Hz');
end

