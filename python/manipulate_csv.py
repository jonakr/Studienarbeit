# this script manipulates the csv results of measurements with given samples

import csv

f = open('samples.csv')
output = open('output.csv', 'w')
reader = csv.reader(f, delimiter=',')

start = False

for idx, row in enumerate(reader):

    if any('Results Overview' in s for s in row):
        start = True

    #if any('Time-Domain Results' in s for s in row):
    #   start = True

    # if any('Frequency-Domain Results' in s for s in row):
    #     start = True

    # if any('Nonlinear Results ' in s for s in row):
    #     start = True

    if not row:
        start = False

    if start:
        new_row = []

        # remove weird tabs and spacing
        for string in row:
            new_string = " ".join(string.split())
            if new_string:
                new_row.append(new_string)

        csv.writer(output).writerow(new_row)

f.close()
output.close()