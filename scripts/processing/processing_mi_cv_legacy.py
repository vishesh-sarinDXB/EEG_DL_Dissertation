import os
import pandas as pd

parent = '../../summary/mi_cv/'

experiment_list = os.listdir(parent)

for experiment in experiment_list:
    
    exp_dir = os.path.join(parent, experiment)
    sub_list = os.listdir(exp_dir)
    sub_list.sort() #1, 10, 9, 8...
    
    mean = pd.DataFrame(columns = ['train_accuracy', 'test_accuracy', 'Precision_class1',
                                   'Precision_class2', 'Recall_class1', 'Recall_class2', 'F1_class1',
                                   'F1_class2', 'Precision_class1_train', 'Precision_class2_train',
                                   'Recall_class1_train', 'Recall_class2_train', 'F1_class1_train',
                                   'F1_class2_train'])
    
    for subject in sub_list:
        
        sub_file = os.path.join(exp_dir, subject)
        sub = pd.read_csv(sub_file)
        sub = sub.append(sub.describe()).drop('count')
        sub.to_csv(sub_file)
        
        mean = mean.append(pd.DataFrame(sub.loc['mean']).transpose())#.reset_index().drop(columns = 'index')
        
    exp_dir = os.path.join(exp_dir, experiment)
    mean.reset_index().drop(columns = 'index').to_csv(exp_dir + '.csv', index = False)