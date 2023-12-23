function alloc_table = single_freq_alloc(alloc_table,k,l,freq)
% set frequency iteratively
% input: initialised allocation table with at least one freq. component;
% k,l pattern;
% the specific frequency needed to be allocated

dimension=size(alloc_table);
while 1
    this_alloc_table=alloc_table;
    for m=1:dimension(1)
        for n=1:dimension(2)
            % find allocated frequency
            if alloc_table(m,n)==freq
                if mod(n,2)==1
                    cell_position(1,1)=m+l+floor(k/2);
                    cell_position(2,1)=m+k+floor(l/2);
                    cell_position(4,1)=m-l-floor(k/2)-mod(k,2);
                    cell_position(5,1)=m-k-floor(l/2)-mod(l,2);
                else
                    cell_position(1,1)=m+l+floor(k/2)+mod(k,2);
                    cell_position(2,1)=m+k+floor(l/2)+mod(l,2);
                    cell_position(4,1)=m-l-floor(k/2);
                    cell_position(5,1)=m-k-floor(l/2);
                end
                cell_position(1,2)=n+k;
                cell_position(2,2)=n-l;
                cell_position(4,2)=n-k;
                cell_position(5,2)=n+l;
                
                if mod(n,2)==1 && mod(k,2)==1
                    cell_position(3,1)=m+floor(k/2)-floor(l/2);
                    cell_position(6,1)=m-floor(k/2)-mod(k,2)+floor(l/2)+mod(l,2);
                elseif mod(n,2)==1 && mod(k,2)==0
                    cell_position(3,1)=m+floor(k/2)-floor(l/2)-mod(l,2);
                    cell_position(6,1)=m-floor(k/2)-mod(k,2)+floor(l/2);
                elseif mod(n,2)==0 && mod(k,2)==1
                    cell_position(3,1)=m+floor(k/2)+mod(k,2)-floor(l/2)-mod(l,2);
                    cell_position(6,1)=m-floor(k/2)+floor(l/2);
                elseif mod(n,2)==0 && mod(k,2)==0
                    cell_position(3,1)=m+floor(k/2)+mod(k,2)-floor(l/2);
                    cell_position(6,1)=m-floor(k/2)+floor(l/2)+mod(l,2);
                end
                cell_position(3,2)=n-k-l;
                cell_position(6,2)=n+k+l;
                
                for i=1:6
                    % cell boundary
                    if cell_position(i,1)>0 && cell_position(i,1)<dimension(1)+1 ...
                            && cell_position(i,2)>0 && cell_position(i,2)<dimension(2)+1
                        alloc_table(cell_position(i,1),cell_position(i,2))=freq;
                    end
                end
            end
        end
    end
    
    if alloc_table==this_alloc_table
        break;
    end
end

end

