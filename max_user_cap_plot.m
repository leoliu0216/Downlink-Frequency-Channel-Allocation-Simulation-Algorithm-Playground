function max_user_cap_plot()
cell_num=200;
Nc=64;
Um=10;
SNRdB=20;

cap(1)=function_IFRN(cell_num, 1, Nc, Um, SNRdB);

cap(2)=function_IFRN(cell_num, 3, Nc, Um, SNRdB);

cap(3)=function_IFRN(cell_num, 7, Nc, Um, SNRdB);

cap(4)=function_IFRN(cell_num, 13, Nc, Um, SNRdB);

cap(5)=function_IFRN(cell_num, 19, Nc, Um, SNRdB);

N=[1 3 7 13 19];

plot(N, cap,'-o','linewidth',1);
grid on
xlabel('Reuse factor N');
ylabel('Max single user capacity');
end