import numpy as np
import pandas as pd
import h5py
import matplotlib.pyplot as plt

f = h5py.File('11-48-21_hrv.mat','r')
data = f.get('Res/HRV/TimeVar')

df = pd.DataFrame()

for header in data:
    values = np.array(f.get('Res/HRV/TimeVar/' + header))[0]
    if len(values) == 41:
        df[header] = values

df.plot(y="mean_HR", kind='line')
plt.show()