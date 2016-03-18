min_score = min(dec_values);
max_score = max(dec_values);

inc = (max_score - min_score) / 10;

res = [];
x_itr = 1;

for x_inc = min_score:inc:max_score
    res(:,x_itr) = dec_values > x_inc;
    x_itr = x_itr + 1;
end