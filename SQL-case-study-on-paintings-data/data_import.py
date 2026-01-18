# Importing necessary libraries
import pandas as pd
from sqlalchemy import create_engine

# URL to connect with MySQL database
conn_string = 'mysql+pymysql://userName:Password@host:port/databasename'

# Creating an SQLAlchemy engine using the specified connection string
db = create_engine(conn_string)

# Establishing a connection to the MySQL database
conn = db.connect()

# List of CSV files to be imported into the database tables
files = ['artist', 'canvas_size', 'image_link', 'museum_hours', 'museum', 'product_size', 'subject', 'work']

# Loop through each file, read its content using pandas, and import into corresponding MySQL tables
for file in files:
    # Reading CSV file into a pandas DataFrame
    df = pd.read_csv('C:/Users/91797/Desktop/SQL project/Dataset/{}.csv'.format(file))
    
    # Writing the DataFrame content to the corresponding MySQL table
    # 'if_exists' parameter set to 'replace' to overwrite the table if it exists
    # 'index' parameter set to False to avoid writing DataFrame index as a separate column
    df.to_sql(file, con=conn, if_exists='replace', index=False)
