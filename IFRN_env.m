function IFRN_env()
clc;clear;

% Input the reqired parameters
cell_num=input('Input the number of cells: ');
reuse_factor=input('Frequency reuse factor N: ');
Nc=input('Number of frequency channels: ');
Um=input('Average number of users per cell: ');
SNRdB=input('Input the range of SNR in dB: ');
fprintf('\n')
snr=10.^(SNRdB./10);
P=1;
sigma=sqrt(P./snr);
r=0.9;

cell_struct=cell_builder(cell_num);
alloc_table=IFRN_alloc(cell_num, reuse_factor);

f=freq_assign(Nc, reuse_factor, cell_num, cell_struct, alloc_table);
rho=rho_generator(f,r,cell_num,cell_struct);


for m=1:length(SNRdB)
    % Do 3000 times of simulation
    for n=1:3000
        % Setting the number of active users for all the cells
        for c=1:cell_num
            U(c)=poissrnd(Um);
            Nchannel(c)=length(find(f(c,:)>0));
        end
        % Generate the channels between the BSs and users
        for c=1:cell_num
            for c_=1:cell_num
                for u=1:min(U(c), Nchannel(c))
                    h(c_,c,u)=(randn+1i*randn)/sqrt(2);
                end
            end
        end
        % Computing the capacity for each user in all cells
        for c=1:cell_num
            for u=1:min(U(c),Nchannel(c))
                I(c,u)=0;
                % Interference
                for c_=1:cell_num
                    if rho(c_,c)~=0&&c_~=c
                        if U(c_)>=u&&Nchannel(c_)>=u
                            I(c,u)=I(c,u)+rho(c_,c)*P*abs(h(c_,c,u))^2;
                        end
                    end
                end
                
                SINR(c,u)=P*abs(h(c,c,u))^2/(I(c,u)+sigma(m)^2);
                Capacity(c,u)=log2(1+SINR(c,u));
            end
            if min(U(c), Nchannel(c))>=1
                cap_cell(c)=sum(Capacity(c,1:min(U(c),Nchannel(c))));
            else
                cap_cell(c)=0;
            end
            
        end
        
        cap_net(m,n)=sum(cap_cell);
    end
    cap_net_avg(m)=mean(cap_net(m,:));
    
    fprintf('\n')
    fprintf('For a %d cell network, for SNR = %g dB, the average Network Capacity with IFR %d is %g \n', ...
        cell_num, SNRdB(m), reuse_factor, cap_net_avg(m));
    fprintf('\n');
end
plot(SNRdB, cap_net_avg);

end

