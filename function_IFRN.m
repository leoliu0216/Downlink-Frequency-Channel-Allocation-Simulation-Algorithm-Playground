function dropout = function_IFRN(cell_num, reuse_factor, Nc, Um, SNRdB)

snr=10.^(SNRdB./10);
P=1;
sigma=sqrt(P./snr);
r=0.9;

cell_struct=cell_builder(cell_num);
alloc_table=IFRN_alloc(cell_num, reuse_factor);

f=freq_assign(Nc, reuse_factor, cell_num, cell_struct, alloc_table);
rho=rho_generator(f,r,cell_num,cell_struct);
max_user_cap=0;

for m=1:length(SNRdB)
    % Do 1000 times of simulation
    for n=1:1000
        clear dropout_rate;
        % Setting the number of active users for all the cells
        for c=1:cell_num
            U(c)=poissrnd(Um);
            Nchannel(c)=length(find(f(c,:)>0));
            dropout_rate(c)=max(0,(U(c)-Nchannel(c))/U(c));
        end
        avg_dropout_rate(n)=mean(dropout_rate);
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
                if Capacity(c,u)>max_user_cap
                    max_user_cap=Capacity(c,u);
                end
            end
            if min(U(c), Nchannel(c))>=1
                cap_cell(c)=sum(Capacity(c,1:min(U(c),Nchannel(c))));
            else
                cap_cell(c)=0;
            end
            
        end
        
        cap_net(m,n)=sum(cap_cell);
        max_user_cap_n(n)=max_user_cap;
    end
    cap_net_avg(m)=mean(cap_net(m,:));
    dropout=mean(avg_dropout_rate);
    avg_max_user_cap=mean(max_user_cap_n);
    fprintf('\n')
    fprintf('For a %d cell network, for SNR = %g dB, the average Network Capacity with IFR %d is %g \n', ...
        cell_num, SNRdB(m), reuse_factor, cap_net_avg(m));
    fprintf('\n');
end

end

