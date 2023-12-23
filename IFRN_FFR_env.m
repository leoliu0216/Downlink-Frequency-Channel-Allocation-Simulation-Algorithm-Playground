function IFRN_FFR_env()
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
    % Do 3000 times of simulation
    for n=1:3000
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
%             if U1(c)>N0
%                 fprintf('Cell Center: Cell %d has %d users but can only serve %g users\n',c,U1(c),N0);
%             end
%             if U2(c)>Nchannel(c)
%                 fprintf('Cell Edge: Cell %d has %d users but can only serve %g users\n',c,U2(c),Nchannel(c));
%             end
        end
        
        % Generate the channels between the BSs and users
        gain=1.5;
        for c=1:cell_num
            for c_=1:cell_num
                if U1(c_)>0
                    for u=1:min(N0,U1(c_))
                        h0(c,c_,u)=gain*(randn+1i*randn)/sqrt(2);
                    end
                end
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
                for u=1:min(N0,U1(c))
                    I0(c,u)=0;
                    % Interference
                    for c_=1:cell_num
                        if c_~=c
                            if U1(c_)>=u && N0>=u
                                I0(c,u)=I0(c,u)+rho_center(c,c_)*P2*abs(h0(c_,c,u))^2;
                            end
                        end
                    end
                    SINR_center(c,u)=P2*abs(h0(c,c,u))^2/(I0(c,u)+sigma2(m)^2);
                    capacity_center(c,u)=log2(1+SINR_center(c,u));
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
    
    fprintf('\n')
    fprintf('For a %d cell network, for SNR = %g dB, the average Network Capacity with FFR + IFR %d is %g \n', ...
        cell_num, SNRdB(m), reuse_factor, cap_net_avg(m));
    fprintf('\n');
end
plot(SNRdB, cap_net_avg);
end


