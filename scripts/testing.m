target =   [1 1 0]
pred = [1 0.9 0.2]

% pred = pred -1



loss = -((target .* log(pred)) + ((1 - target) .* log(1 - pred)))

loss(isnan(loss)) = 0


neg_test = [-1 2 3 -5]

neg_test(neg_test < 0) = 0