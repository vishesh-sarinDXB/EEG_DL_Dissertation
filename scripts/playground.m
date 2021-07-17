% cD = cell(1, 3);
% cD(:) = {'double'};
% 
% T = table('Size', [52 14], 'VariableTypes', cD);
% 
% nums = {1, 2, 3};
% 
% T(1, :) = nums

if ~exist('../summary/processed/', 'dir')
    mkdir ../summary/processed/
end 