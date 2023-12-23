function root = n_divider(n)
% input a number of re-use factor
% find whether the value is appropriate or not
% if appropriate , divide it into k & l

root_num=1;
for k=0:sqrt(n)
    for l=0:sqrt(n)
        if k^2+l^2+k*l==n
            root(root_num, 1)=k;
            root(root_num, 2)=l;
            root_num=root_num+1;
        end
    end
end

if root_num==1
    fprintf('Cannot find the value of K & L.\n Check your input value of N.\n');
end

end

