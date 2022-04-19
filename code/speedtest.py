import time
import pandas as pd
import h5py
import matplotlib.pyplot as plt

start = time.time()
f = h5py.File('../dat/11-48-21_hrv.mat')
df = pd.DataFrame(f.get('Res/HRV/TimeVar/mean_HR')).T

df.plot(y=0, kind='line')
end = time.time()
print(end - start)
plt.show()