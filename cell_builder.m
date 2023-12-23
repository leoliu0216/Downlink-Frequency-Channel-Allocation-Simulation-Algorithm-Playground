function cell_code = cell_builder(m)
% input number of cell m
% ouput cell structure & code for each cell

if sqrt(m)==fix(sqrt(m))
    n=sqrt(m);
    for col=1:n
        for row=1:n
            cell_code(row,col)=(col-1)*n+row;
        end
    end
else
    res=find_nearest_square(m);
    n=sqrt(res(1));
    for col=1:n
        for row=1:n
            cell_code(row,col)=(col-1)*n+row;
        end
    end
    if res(2)>0 % sign > 0; Add more cells
        final_col=n+1;
        for row=1:res(3)
            cell_code(row,final_col)=n^2+row;
        end
    else % sign < 0; Subtract some cells
        final_col=n;
        for row=n-res(3)+1:n
            cell_code(row,final_col)=0;
        end
    end
end

