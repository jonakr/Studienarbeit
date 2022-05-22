import numpy as np
import pandas as pd
import statsmodels.api as sm
from timeit import timeit
import matplotlib.pyplot as plt

reps, beta, n_array = 1000, [10, -0.5, 0.5], [1000, 10000, 100000]

def python_boot():
    for r in np.arange(reps):
        this_sample = np.random.choice(row_id, size=n, replace=True)
        X_r = X[this_sample,:]
        Y_r = Y[this_sample]
        store_beta[r,:] = sm.regression.linear_model.OLS(Y_r, X_r).fit(disp=0).params 

python_time = np.zeros((len(n_array),2))
count=0

for n in n_array:
    row_id = range(0, n)
    X1 = np.random.normal(10, 4, (n, 1))
    X2 = np.random.normal(10, 4, (n, 1))
    X = np.append(X1, X2, 1)
    X = np.append(X, np.tile(1, (n, 1)), 1)
    error = np.random.randn(n, 1)
    Y = np.dot(X, beta).reshape((n, 1)) + error
    
    store_beta = np.zeros((reps,X.shape[1]))
    TimeIt = timeit("python_boot()", setup="from __main__ import python_boot", number=1)
    python_time[count,:] = [n,TimeIt]
    count = count + 1

mat_time = [[1000, 0.3571], [10000, 0.6031], [100000, 3.7375]]

matlab_data=pd.DataFrame(mat_time,columns=['n','Matlab Time'])
python_data=pd.DataFrame(python_time,columns=['n','Python Time'])
plot_data = pd.concat([matlab_data,python_data['Python Time']], axis=1)
ax = plt.gca()
plot_data.plot(kind='line',x='n',y='Matlab Time',ax=ax)
plot_data.plot(kind='line',x='n',y='Python Time',ax=ax)
plt.show()