function rho = rho_generator(f,r,cell_num,cell_struct)

alpha=1; % for urban cellular network
rho=zeros(cell_num,cell_num);
for m=1:cell_num
    for n=1:cell_num
        if m==n
            rho(m,n)=1;
        elseif f(m,:)==f(n,:)
            [x1,y1]=find(cell_struct==m); % find the position of cell m
            [x2,y2]=find(cell_struct==n); % find the position of cell n
            distance=sqrt((x1-x2)^2+(y1-y2)^2);
            rho(m,n)=r*distance^(-alpha);
        end
    end
end


end

