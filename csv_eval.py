import pandas as pd
import matplotlib.pyplot as plt

df=pd.read_csv('reduced.csv', delimiter=',')

df.plot(x="Time", y="PNS index", kind='line')
plt.show()