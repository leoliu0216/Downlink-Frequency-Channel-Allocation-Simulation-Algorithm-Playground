function alloc_table = IFRN_alloc(M, N)
% input cell number M, reuse factor N,
% output frequency allocation table;

cell_struct=cell_builder(M);
dimension=size(cell_struct);
alloc_table=zeros(dimension(1), dimension(2));

% define k,l
kl_res=n_divider(N);
k=kl_res(1);
l=kl_res(2);

% initialise allocation table
alloc_table(1,1)=1;
alloc_table=single_freq_alloc(alloc_table,k,l,1);

% allocate frequency iteratively
for freq=2:N
    for cell=1:M
        [x,y]=find(cell_struct==cell);
        pre_alloc_table=alloc_table;
        pre_alloc_table(:)=0;
        pre_alloc_table(x,y)=freq;
        this_alloc_table=single_freq_alloc(pre_alloc_table,k,l,freq);
        [x1,y1]=find(this_alloc_table==freq);
        
        for m=1:length(x1)
            if alloc_table(x1(m),y1(m))~=0
                flag=0;
                break;
            end
            if m==length(x1)
                flag=1;
            end
        end
        
        if flag
           alloc_table=alloc_table+this_alloc_table;
           break;
        else
            continue;
        end
    end
    
end


end

