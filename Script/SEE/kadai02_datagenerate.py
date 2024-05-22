import pandas as pd
import numpy as np

# 5x5の乱数を持つndarrayを生成
array = np.round(np.random.rand(5, 5), decimals=3)
# 欠損値を混入
array[0, 1] = np.NaN
array[3, 3] = np.NaN
array[4, 1] = np.NaN

# DataFrameを作成する際に、上のarrayをデータとして渡す
df = pd.DataFrame(data=array)
df.set_axis(["Data0", "Data1", "Data2", "Data3", "Data4"], axis=1, inplace=True)

print(df)

df.to_csv("kadai02_data.csv")
