function IFRN_FFR_SWF_env()
clc;clear;

% Input the reqired parameters
cell_num=input('Input the number of cells: ');
reuse_factor=input('Frequency reuse factor N: ');
N0=input('Number of frequency channels at the centers: ');
Nc=input('Number of frequency channels at the edges: ');
Um=input('Average number of users per cell: ');
SNRdB=input('Input the range of SNR in dB: ');
fprintf('\n')
snr=10.^(SNRdB./10);
P1=1; % cell edge
P2=0.5; % cell center
sigma1=sqrt(P1./snr);
sigma2=sqrt(P2./snr);

r=0.9;


cell_struct=cell_builder(cell_num);
alloc_table_edge=IFRN_alloc(cell_num, reuse_factor);
alloc_table_center=IFRN_alloc(cell_num, 1);

f_edge=freq_assign(Nc, reuse_factor, cell_num, cell_struct, alloc_table_edge);
rho_edge=rho_generator(f_edge,r,cell_num,cell_struct);
f_center=freq_assign(N0, 1, cell_num, cell_struct, alloc_table_center);
rho_center=rho_generator(f_center,r,cell_num,cell_struct);


for m=1:length(SNRdB)
    % Do 100 times of simulation
    for n=1:100
        % Setting the number of active users for all the cells
        for c=1:cell_num
            U(c)=poissrnd(Um);
            U1(c)=round(rand*U(c)); % cell center
            U2(c)=U(c)-U1(c); % cell edge
            Nchannel(c)=length(find(f_edge(c,:)>0));
            % improve the original algorithm
            if U1(c)>N0
                U1(c)=N0;
                U2(c)=U(c)-U1(c);
            end
        end
        
        % Generate the channels between the BSs and users
        gain=1.5;
        
        H=gain*(randn(cell_num,cell_num,max(U1),N0)+1i*randn(cell_num,cell_num,max(U1),N0))/sqrt(2);
        p=sWFpa_MU(H,sigma2(m),P2,U1,rho_center);
        
        for c=1:cell_num
            for c_=1:cell_num
                if U2(c_)>0
                    for u=1:min(U2(c_), Nchannel(c_))
                        h(c,c_,u)=(randn+1i*randn)/sqrt(2);
                    end
                end
            end
        end
        
        % Computing the capacity for each user in all cells
        for c=1:cell_num
            % cell center users
            if U1(c)>0
                for u=1:U1(c)
                    capacity_center(c,u)=0;
                    for f=1:N0
                        I(f)=sigma2(m)^2;
                        for c_=1:cell_num
                            for u_=1:U1(c_)
                                if c_~=c||u_~=u
                                    I(f)=I(f)+rho_center(c,c_)*p(f,c_,u_)*abs(H(c_,c,u,f))^2;
                                end
                            end
                        end
                        sinr(f,c,u)=p(f,c,u)*abs(H(c,c,u,f))^2/I(f);
                        capacity_center(c,u)=capacity_center(c,u)+log2(1+sinr(f,c,u));
                    end
                end
            end
            
            % cell edge users
            if U2(c)>0
                for u=1:min(Nchannel(c),U2(c))
                    I(c,u)=0;
                    % Interference
                    for c_=1:cell_num
                        if rho_edge(c,c_)~=0 && c_~=c
                            if U2(c_)>=u && Nchannel(c_)>=u
                                I(c,u)=I(c,u)+rho_edge(c,c_)*P1*abs(h(c_,c,u))^2;
                            end
                        end
                    end
                    SINR_edge(c,u)=P1*abs(h(c,c,u))^2/(I(c,u)+sigma1(m)^2);
                    capacity_edge(c,u)=log2(1+SINR_edge(c,u));
                end
            end
            if U1(c)>0 && U2(c)>0
                cap_cell(c)=sum(capacity_center(c,1:min(N0,U1(c))))+sum(capacity_edge(c,1:min(Nchannel(c), U2(c))));
            elseif U1(c)>0 && U2(c)==0
                cap_cell(c)=sum(capacity_center(c,1:min(N0,U1(c))));
            elseif U1(c)==0 && U2(c)>0
                cap_cell(c)=sum(capacity_edge(c,1:min(Nchannel(c),U2(c))));
            end
        end
        
        % sum up the capacity
        cap_net(m,n)=sum(cap_cell);
    end
    cap_net_avg(m)=mean(cap_net(m,:));
    
    fprintf('\n');
    fprintf('For a %d cell network, for SNR = %g dB, the average Network Capacity with FFR(SWF) + IFR %d is %g \n', ...
        cell_num, SNRdB(m), reuse_factor, cap_net_avg(m));
    fprintf('\n');
end
plot(SNRdB, cap_net_avg);
end


