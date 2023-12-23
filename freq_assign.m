function f = freq_assign(Nc, reuse_factor, cell_num, cell_struct, alloc_table)
% assign frequency group to the cells

channel_per_cell=fix(Nc/reuse_factor);
if channel_per_cell*reuse_factor==Nc 
    for n=1:reuse_factor
        group(n,:)=(1+(n-1)*channel_per_cell):(n*channel_per_cell);
    end
else
    for n=1:reuse_factor
        group(n,:)=(1+(n-1)*channel_per_cell):(n*channel_per_cell);
    end
    for m=1:Nc-reuse_factor*channel_per_cell
        group(reuse_factor,channel_per_cell+m)=group(reuse_factor,channel_per_cell+m-1)+1;
    end
end

for m=1:cell_num
    [x,y]=find(cell_struct==m);
    f(m,:)=group(alloc_table(x,y),:);
end

end

