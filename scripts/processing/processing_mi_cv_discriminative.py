import os
import pandas as pd

parent = '../../summary/mi_cv/'

experiment_list = os.listdir(parent)

for experiment in experiment_list:
    exp_dir = os.path.join(parent, experiment)
    run_dirs = os.listdir(exp_dir)
    run_dirs.sort() #1, 10, 9, 8...
    
    sub_list = os.listdir(os.path.join(exp_dir, run_dirs[0]))
    sub_list.sort()

    run_sub_paths = [[os.path.join(exp_dir, run, sub) \
                      for sub in sub_list] for run in run_dirs]
    
    run_sub = [[pd.read_csv(sub) for sub in run] for run in run_sub_paths]
    
    runs_concat = [pd.concat(run).reset_index().drop(columns = 'index') for run in run_sub]
    
    subs = [[run[sub] for run in run_sub] for sub in range(0, 52)]
    subs_concat = [pd.concat(sub).reset_index().drop(columns = 'index') for sub in subs]
    
    subs_desc = [sub.append(sub.describe()).drop('count') \
                 for sub in subs_concat]
    
    subs_discrim = [[sub, idx] for idx, sub in enumerate(subs_desc) \
                     if sub.loc['mean', 'test_accuracy'] > 0.5]
    
    if not os.path.exists(os.path.join(exp_dir, 'subjects')):
        os.makedirs(os.path.join(exp_dir, 'subjects'))
    
    [sub[0].\
    to_csv(os.path.join(exp_dir, 'subjects', str(sub[1] + 1) + '.csv')) \
     for sub in subs_discrim]
    
    pd.concat([sub[0] for sub in subs_discrim]).\
    drop(index = ['max', 'min', '25%', '50%', '75%', 'mean', 'std']).\
    to_csv(os.path.join(exp_dir, experiment + '.csv'))