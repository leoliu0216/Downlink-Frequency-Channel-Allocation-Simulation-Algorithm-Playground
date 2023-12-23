function FFR_P2_plot()
cell_num=100;
Nc=48;
N0=8;
Um=15;
SNRdB=5;
reuse_factor=13;
n=1;

for P2=0.1:0.3:1
    cap(n)=function_IFRN_FFR(cell_num, reuse_factor, N0, Nc, Um, SNRdB, P2);
    fprintf('%d\n', n);
    n=n+1;
end

x=0.1:0.3:1;
plot(x,cap,'-o', 'linewidth',1)
hold on
grid on
xlabel('Center cell power');
ylabel('Average network capacity in bps/Hz');

end

