function sorted_b = get_predicted_list(BB, n_countries)

bins = zeros(n_countries,1);

n_data = size(BB,1);

for x_data = 1:n_data
    x_bin = BB(x_data,2);
    if (BB(x_data,1) == -1)
        x_bin = BB(x_data,3);
    end
    bins(x_bin) = bins(x_bin) + 1;
end

[a1,sorted_b] = sort(bins','descend');

%[a2,b2] = sort(scores);


