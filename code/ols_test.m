reps = 1000;  
beta = [10,-.5,.5];
n_array = [1000, 10000, 100000];

mat_time = zeros(3,2);
    
for i = 1:3
    n = n_array(i);
    row_id = 1:n;
    
    X = [normrnd(10, 4, [n 2]) ones(n,1)];            
    Y = X * beta' + normrnd(0,1,[n 1]);

    store_beta = zeros(reps, 3); 
    tic
    for r = 1:reps
       this_row = randsample(row_id, n, true);
       store_beta(r,:) = (OLS(Y(this_row), X(this_row,:)))'; 
    end
    mat_time(i,:) = [n toc];
end