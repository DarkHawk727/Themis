import csv
import sys
import os

path, dirs, lfiles = next(os.walk("./data/left"))
left_count = len(lfiles)
path, dirs, rfiles = next(os.walk("./data/right"))
right_count = len(rfiles)

def writeLines(s, path):
    file1 = open(path, "w")
    file1.writelines(s) 
    file1.close()

with open('data/articles2.csv', 'r') as file:
    csv.field_size_limit(sys.maxsize)
    reader = csv.reader(file)
    for row in reader:
        if 'New York Times' in row[3] or 'CNN' in row[3] or 'Atlantic' in row[3] or 'Buzzfeed News' in row[3]:
            # print("LEFT")
            writeLines(row[2], "data/left/" + str(left_count) + ".txt")
            left_count += 1
        elif 'Breitbart' in row[3] or 'Fox News' in row[3] or 'National Review' in row[3] or 'New York Post':
            # print("RIGHT")
            writeLines(row[2], "data/right/" + str(right_count) + ".txt")
            right_count += 1

