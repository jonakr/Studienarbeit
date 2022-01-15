# this script converts the csv results of measurements with given samples into dataframes

import csv
import pandas as pd

def reduce_data(path, filename):
    f = open(path + filename)
    output = open(path + '/reduced.csv', 'w')
    reader = csv.reader(f, delimiter=',')

    row_found = False

    for _, row in enumerate(reader):

        if any('Results Overview' in s for s in row):
            row_found = True
        if any('Time-Domain Results' in s for s in row):
            row_found = True
        #if any('Frequency-Domain Results' in s for s in row):
        #    row_found = True
        if any('Nonlinear Results ' in s for s in row):
            row_found = True

        if not row:
            row_found = False

        if row_found:
            new_row = []
            # remove weird tabs and spacing
            for string in row:
                new_string = " ".join(string.split())
                if new_string:
                    new_row.append(new_string)

            csv.writer(output).writerow(new_row)

    f.close()

    df = pd.read_csv(path + 'reduced.csv')
    print(df)
    output.close()

reduce_data('data_with_samples/', 'samples.csv')