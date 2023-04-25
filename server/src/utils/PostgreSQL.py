# Utils - Postgre SQL -*- coding: utf-8 -*-
from sqlalchemy import *
from sqlalchemy import create_engine
from typing import no_type_check_decorator
from psycopg2.extras import DictCursor
from datetime import datetime
from functools import wraps
import traceback
import psycopg2
import psycopg2.errors
import psycopg2.extensions

# Import - Reference
import sys
from pathlib import Path
sys.path.append(str(Path(__file__).parent.parent.parent))

# Import - Source Code
from src.const import DELETE_FLG
from src.const import RETURN_CODE, LOG_LEVEL, USER_ID
from src.utils.LogFunc import LogFunc
from src.utils.config import *
from src.utils.DateUtils import DateUtils
from src.utils.MessageUtils import MessageUtils


class ServerInfo:

    """
      Set Defalut Value
      """

    def __init__(self):
        self.conn_info = SettingInfo.get_db_connection_info()
        self.time_out = SettingInfo.set_time_out()

    
    def connect():
        """
        DB Connection Method
        """
        connInfo = SettingInfo.get_db_connection_info()

        try:
            conn = psycopg2.connect(**connInfo)
            conn.autocommit = True
            cur = conn.cursor()
            cur.execute("SELECT 1")

        except:
            LogFunc.write_logfile_console(LOG_LEVEL.FATAL, __name__, f'Unable to connect to a DB Server ({connInfo})!')
            raise

        else:
            return conn


def _connect(name: str=None, output_log: bool=False):
    """
    DB Connection Method

    Args:
        name (str, optional): _description_. Defaults to "internal function".
    """
    def _wrapper(func):
        @wraps(func)
        def _inner(*args, **kwargs):

            server_info = ServerInfo()

            try:
                if output_log: 
                    LogFunc.write_logfile_console(LOG_LEVEL.INFO, f"{name}({func.__name__}) - START")
                
                # Set BASE DATE
                base_date = DateUtils.get_today_for_log()
                bf_time = datetime.now()

                # Main Func
                conn = psycopg2.connect(**server_info.conn_info)
                if (conn.closed > 0):
                    conn = ServerInfo.connect()
                conn.autocommit = False

                # Set TIME OUT
                curs = conn.cursor()
                curs.execute(f'SET statement_timeout TO {server_info.time_out}')
                if output_log: 
                    LogFunc.write_logfile_console(LOG_LEVEL.INFO, f'Query: {args}')

                ret = func(*args, **kwargs, conn=conn)
                af_time = datetime.now()
                conn.commit()
                conn.autocommit = True
                
                # END Message
                if output_log: 
                    MessageUtils.output_message_kwargs(message_id="ME0008", func_name=__name__, name=name, base_date=base_date, bf_time=bf_time, af_time=af_time, total=str(af_time-bf_time))

                return ret

            except Exception as e:
                conn.rollback()
                LogFunc.write_logfile_console(LOG_LEVEL.FATAL, __name__, f'PostgreSQL: Unable to connect! \nDetail: Error: {args}')
                LogFunc.write_logfile_console(LOG_LEVEL.CRITICAL, f"{name} ({func.__name__}) is {e} traceback is {traceback.format_exc()}")
                raise

            finally:
                LogFunc.write_logfile_console(LOG_LEVEL.INFO, f"{name}({func.__name__}) - END")
                curs.close()
                conn.close()

        return _inner
    return _wrapper


class PostgreSQL:
    """ Class: PostgreSQL """

    @_connect("Query: SELECT")
    def select(query, conn=ServerInfo.connect()):
        """
        SELECT Dist Query

        Args: 
            query (str): Query
            conn (Session): Connect Session
        """

        data = None
        LogFunc.write_logfile_console(LOG_LEVEL.INFO, __name__, 'Get Data from DB Server')

        cur = conn.cursor(cursor_factory=DictCursor)
        cur.execute(query)
        
        if (cur.rowcount < 1):
            LogFunc.write_logfile_console(LOG_LEVEL.INFO, __name__, f'Select Data is no row count!\n SELECT Query: {query}')
        
        data = cur.fetchall()
        
        return data


    @_connect("Query: SELECT COUNT")
    def select_count(query, conn=ServerInfo.connect()):
        """ 
        SELECT COUNT method
        
        Args: 
            query (str): Query
            conn (Session): Connect Session
        
        Return: 
            Row Count: SELECT Row()
        """

        data = None
        LogFunc.write_logfile_console(LOG_LEVEL.INFO, __name__, 'Get Data from DB Server')

        cur = conn.cursor()
        cur.execute(query)
        data = cur.rowcount

        return data
    

    @_connect("Query: INSERT")
    def insert(query, conn=ServerInfo.connect()):
        """
        INSERT Query

        Args: 
            query (str): Query
            conn (Session): Connect Session
        """
        LogFunc.write_logfile_console(LOG_LEVEL.INFO, __name__, 'Insert Data to DB Server')
        cur = conn.cursor()
        cur.execute(query)


    @_connect("Query: INSERT Stock Pricer")
    def insert_stock_price(data, check_query, insert_query, conn=ServerInfo.connect()):
        """
        INSERT Stock Price into PostgreSQL

        Args: 
            data (str): Data
            check_query (str): Check Data into DB Server
            insert_query (str): INSERT for query
            conn (Session): Connect Session
        """
        LogFunc.write_logfile_console(LOG_LEVEL.INFO, __name__, 'Insert Data to DB Server')
        
        stock_code = data.get("stock_code")
        stock_code_api = data.get("stock_code_api")
        row = len(data["timestamp"])
        insert_count = 0
        cur = conn.cursor()
        
        # Insert Query
        for num in range(row):
            time_stamp = datetime.utcfromtimestamp(data["timestamp"][num]/1000)
            check_count = check_query.format(stock_code=stock_code, time_stamp=time_stamp)
            cur.execute(check_count)
            if (cur.rowcount > 0):
                continue

            def create_insert_query(query, stock_code, stock_code_api, time_stamp, open_rate, low_rate, high_rate, close_rate, volume):
                """
                Create Insert Query For Yahoo Finance

                Args: 
                    query (str): Data
                    stock_code (str): Stock Code
                    stock_code_api (str): Stock Code for API
                    time_stamp (str): TIME STAMP
                    open_rate (int): Open Rate
                    low_rate (int): Low Rate
                    high_rate (int): High Rate
                    close_rate (int): Close Rate
                    volume (int): volume
                """
                insert_date = DateUtils.get_base_date()
                open = 0 if not open_rate else open_rate
                low = 0 if not low_rate else low_rate
                high = 0 if not high_rate else high_rate
                close = 0 if not close_rate else close_rate
                vol = 0 if not volume else volume
                delete_flg = DELETE_FLG.FALSE
                user_id = USER_ID.MASTER
                statement = query.format(insert_date, stock_code, stock_code_api, time_stamp, open, low, high, close, vol, delete_flg, user_id)
                return statement

            query = create_insert_query(insert_query, stock_code, stock_code_api, time_stamp,
                                                       data["open"][num], data["low"][num], data["high"][num], data["close"][num], data["volume"][num])
            cur.execute(query)
            insert_count = insert_count + 1
        
        LogFunc.write_logfile_console(LOG_LEVEL.INFO, __name__, f'count of that Insert data count into a Table is {insert_count}')




# def save_sql_from_pd(session: Session,
#                      df: pd.DataFrame,
#                      table_class,
#                      chunksize: int = 4096,
#                      method="multi",
#                      null_ok = False):

#     # 与えられたデータフレームがNone or 0件の場合は何もせずに終わる。
#     if df is None or len(df) == 0:
#         return

#     table_name = table_class.__tablename__
#     attributes = {}
#     for attribute_name, attribute in inspect.getmembers(
#             table_class, lambda a: not (inspect.isroutine(a))):
#         if isinstance(attribute, InstrumentedAttribute):
#             attributes[attribute_name] = attribute

#     attribute_names = set(list(attributes.keys()))
#     df_columns = set(df.columns.values.tolist())
#     if len(df_columns - attribute_names) != 0:
#         output_log(LogLevel.CRITICAL, "ファイルのカラムが定義と異なる場合")
#         raise ValueError(df_columns - attribute_names)

#     attributes = {c: attributes[c].type for c in df_columns}

#     if method == "csv":
#         # TODO : Make temp files.
#         df.to_csv("tmp.csv", index=False)
#         df_columns = df.columns.values.tolist()
#         sql = f"LOAD DATA LOCAL INFILE 'tmp.csv' REPLACE INTO TABLE {table_name} FIELDS TERMINATED BY ',' "
#         sql += "(" + ",".join([f"@{i + 1}"
#                                for i in range(len(df_columns))]) + ") "
#         sql += "SET " + ", ".join(
#             [f"{c}=@{i + 1}" for i, c in enumerate(df_columns)])
#         print(sql)
#         session.execute(sql)
#         return

#     if method == "duplicate":
#         method = _insert_on_duplicate
#     if null_ok == True:
#         query = df.to_sql
#     else:
#         query = df.astype(str).to_sql
#     TimeOutWithRetry(query, QUERY_TIMEOUT, TIMEOUT_RETRY_N)(table_name,
#                           con=session.connection(),
#                           index=False,
#                           chunksize=chunksize,
#                           if_exists="append",
#                           method=method)