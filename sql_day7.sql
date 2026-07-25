from loguru import logger
import mysql.connector

connection = mysql.connector.connect(host= 'localhost',
                                     user = "root",
                                     password = "007944",
                                     database = "mysqlvspython")
logger.info(connection)

cursor = connection.cursor()
cursor.execute("select * from labours_table")
result = cursor.fetchall()

# insert_query = "INSERT INTO labours_table (name, role, wages) VALUES (%s, %s, %s)"
# cursor.execute(insert_query, ('New Labour', 'labour', 600))

# update_query = """ UPDATE labours_table SET name = %s WHERE name = %s """

delete_duplicate_record = """delete from labours_table where id = 8 """
cursor.execute(delete_duplicate_record)

# cursor.execute(update_query, ('rahul', 'New Labour'))

connection.commit()

connection.commit()

connection.close()
cursor.close()
