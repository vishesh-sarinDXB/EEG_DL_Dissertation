import os
import pandas as pd

parent = '../../summary/mi_real/'

experiment_list = os.listdir(parent)

for experiment in experiment_list:
    
    exp_dir = os.path.join(parent, experiment)
    run_list_files = os.listdir(exp_dir)
    run_list_files.sort() #1, 10, 9, 8...
    
    run_list = [pd.read_csv(os.path.join(exp_dir, run_list_file)) \
                for run_list_file in run_list_files]
    
    [run.append(run.describe()).drop('count').\
     to_csv(os.path.join(exp_dir, str(idx + 1) + '.csv')) \
     for idx, run in enumerate(run_list)]
    
    sub_list = [[run.loc[i] for run in run_list]for i in range(0, 52)]
    sub_list = [pd.concat(sub, axis = 1).transpose().\
                reset_index().drop(columns = 'index') \
                for sub in sub_list]

    subs_desc = [sub.append(sub.describe()).drop('count') \
                 for sub in sub_list]
    
    subs_discrim = [[sub, idx] for idx, sub in enumerate(subs_desc) \
                     if sub.loc['mean', 'test_accuracy'] > 0.5]
    
    if not os.path.exists(os.path.join(exp_dir, 'subjects')):
        os.makedirs(os.path.join(exp_dir, 'subjects'))

    if not os.path.exists(os.path.join(exp_dir, 'subjects_discriminative')):
        os.makedirs(os.path.join(exp_dir, 'subjects_discriminative'))
        
    [sub.append(sub.describe()).drop('count').\
     to_csv(os.path.join(exp_dir, 'subjects', str(idx + 1) + '.csv')) \
     for idx, sub in enumerate(sub_list)]

    [sub[0].\
     to_csv(os.path.join(exp_dir, 'subjects_discriminative', str(sub[1] + 1) + '.csv')) \
     for sub in subs_discrim]
    
    pd.concat(run_list).reset_index().drop(columns = 'index').\
    to_csv(os.path.join(exp_dir, experiment + '.csv'))

    pd.concat([sub[0] for sub in subs_discrim]).\
    drop(index = ['max', 'min', '25%', '50%', '75%', 'mean', 'std']).\
    to_csv(os.path.join(exp_dir, experiment + '_discriminative.csv'))