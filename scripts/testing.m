pred =   [0 1 0 0 0 0 1 1 0 1 0 1]
target = [0 1 1 1 1 0 0 1 0 0 0 1]

pred = double(pred)
target = double(target)

tp = sum(pred == 1 & target == 1)
fp = sum(pred == 1) - tp
fn = sum(target == 0 & ~pred == 0)