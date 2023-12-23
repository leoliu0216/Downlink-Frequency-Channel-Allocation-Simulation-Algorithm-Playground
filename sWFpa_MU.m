function p=sWFpa_MU(H,sigma,P,U,rho)

[N_cell,~,~,Nf]=size(H);
Niter_max=50;
d_threshold=1e-3;
Nrun=1;

for f=1:Nf
    for nc=1:N_cell
        for u=1:U(nc)
            p(f,nc,u)=rand*P/Nf;
        end
    end
end

p_old=p;

while 1
    for nc=1:N_cell
        for u=1:U(nc)
            for f=1:Nf
                I(f)=sigma^2;
                for nc_=1:N_cell
                    for u_=1:U(nc_)
                        if nc_~=nc||u_~=u
                            I(f)= I(f)+rho(nc,nc_)*p(f,nc_,u_)*abs(H(nc_,nc,u,f))^2;
                        end
                    end
                    c(f)=I(f)/abs(H(nc,nc,u,f))^2;
                end
            end
            ptmp=wfpa_c(c,P);
            p(:,u)=ptmp';
            clear ptmp;
        end
    end
    Nrun=Nrun+1;
    p_new=p;
    
    if sum(sum(abs(p_new-p_old).^2)) < d_threshold | Nrun > Niter_max
        return;
    end
end

