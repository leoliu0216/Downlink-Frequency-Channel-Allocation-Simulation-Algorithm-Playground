function res = find_nearest_square(m)
% input cell number m;
% output a list: 
% [nearest square number, ...
% sign(add or subtract cells), ...
% remainder value(how may cells need to be changed)];
% only use this when m is not a perfect square;

if sqrt(m)==fix(sqrt(m))
    fprintf('m is already a perfect square number\n');
   return; 
end

lower_remainder=m-fix(sqrt(m))^2;
upper_remainder=abs(m-fix(sqrt(m)+1)^2);

if lower_remainder < upper_remainder
    square=fix(sqrt(m))^2;
    sign=1;
    remainder=lower_remainder;
else
    square=fix(sqrt(m)+1)^2;
    sign=-1;
    remainder=upper_remainder;
end
res=[square, sign, remainder];

end

