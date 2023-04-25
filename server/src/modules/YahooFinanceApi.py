# Module - Yahoo Finance API -*- coding: utf-8 -*-
from yahoo_finance_api2 import share
from yahoo_finance_api2.exceptions import YahooFinanceError
from datetime import datetime
import pandas_datareader.data as pdr
import functools

# Import - Reference
import os, csv, sys
from pathlib import Path
sys.path.append(str(Path(__file__).parent.parent.parent))

# Import - Source Code
from src.utils.DateUtils import DateUtils
from src.utils.LogFunc import LogFunc
from src.utils.MessageUtils import MessageUtils
from src.utils.config import SettingInfo
from src.utils.ValueUtils import *
from src.const import PERIOD_TYPE, FREQUENCY_TYPE, LOG_LEVEL


# Set Defalut Value
class StockCode:
    """ Stock Code """

    def __init__(self, stock_code):
        self.stock_code = stock_code
        self.stock_code_api = stock_code
        self.period_type = PERIOD_TYPE.DAY
        self.frequency_type = FREQUENCY_TYPE.MINUTE


class MarketInfo(StockCode):
    """ Market Info """

    def __init__(self, stock_code):
        super().__init__(stock_code)
        self.system_type = "yahoo"
        self.current_time = DateUtils.get_current()
        self.output_path = SettingInfo.get_csv_dir()
        self.file_name = f'{self.stock_code}{self.current_time}.csv'


# Yahho Finance API
class YahooFinanceApi:
    """ Yahho Finance API """

    def __init__(self, stock_code, country_code):
        self.stock_code = stock_code
        self.stock_code_api = f'{stock_code}.T' if country_code == 'JPY' else stock_code
        self.period_type = PERIOD_TYPE.DAY
        self.frequency_type = FREQUENCY_TYPE.MINUTE

    @functools.lru_cache(maxsize=None)
    def get_stock_price(stock_code: str = "", period_type: str = PERIOD_TYPE.DAY, period_type_num: int = 1, frequency_type: str = FREQUENCY_TYPE.MINUTE, frequency_type_num: int = 5) -> dict:
        """
        Get Market Price By Stock Code

        Args: 
            stock_code (str): Stock Code
            period_type (str): Period Type
            period_type_num (int): Period Type Count
            frequency_type (str): Frequency Type
            frequency_type_num (int): Frequency Type Count

        Return:
            data (dict): Stock Price Data
        """
        data = None
        my_share = share.Share(stock_code)

        try:
            # Ex. period_type_num = 10, frequency_type_num = 5
            data = my_share.get_historical(
                period_type, period_type_num, frequency_type, frequency_type_num)

        except YahooFinanceError as e:
            err = e.message
            LogFunc.console_log(LOG_LEVEL.FATAL, __name__, err)

        else:
            if not data:
                MessageUtils.output_msg("ME0002", __name__, stock_code, 'no data')
                return data

            data["stock_code"] = stock_code
            data["stock_code_api"] = stock_code
            data["YahooFinanceApi"] = True
            MessageUtils.output_msg("ME0002", __name__, stock_code, LOG_LEVEL.MESSAGE_SUCCESS)

        return data

    @functools.lru_cache(maxsize=None)
    def get_market_price_with_pandas(stock_code, start_day, end_day):
        """
        Get Market Price By Stock Code with Pandas

        Args: 
          stock_code (str): Stock Code
          start_day (str): Start Day
          end_day (str): End Day

        Return:
          data (pandas): Stock Price Data
        """
        info = MarketInfo(stock_code)
        data = None
        try:
            data = pdr.DataReader(
                stock_code, info.system_type, start_day, end_day)

        except Exception as e:
            LogFunc.write_logfile_console(
                LOG_LEVEL.FATAL, 'get_market_price_with_pandas', e)

        else:
            MessageUtils.output_msg("ME0004", __name__, stock_code, LOG_LEVEL.MESSAGE_SUCCESS)
            data["stock_code"] = info.stock_code
            data["stock_code_api"] = info.stock_code_api
            data["YahooFinanceApi"] = True

        return data
    
    @functools.lru_cache(maxsize=None)
    def output_market_price_csv(stock_code: str = "", stock_code_api: str = "", period_type: str = PERIOD_TYPE.DAY, period_type_num: int = 1, frequency_type: str = FREQUENCY_TYPE.MINUTE, frequency_type_num: int = 5):
        """
        Output Market Price CSV By Stock Code
        
        Args: 
            stock_code (str): Stock Code
            period_type (str): Period Type
            period_type_num (int): Period Type Count
            frequency_type (str): Frequency Type
            frequency_type_num (int): Frequency Type Count
        """
        info = MarketInfo(stock_code)
        path = info.output_path
        data = YahooFinanceApi.get_stock_price(stock_code_api, period_type, period_type_num, frequency_type, frequency_type_num)
        if not data:
            MessageUtils.output_msg("ME0003", __name__, stock_code)
            return
        
        # Write CSV
        file_name = MarketInfo(stock_code).file_name
        csv_path = os.path.join(path, file_name)
        data_len = len(data.get("timestamp"))
        
        with open(csv_path, 'x', newline='', encoding='utf-8') as csvFile:
            csvwriter = csv.writer(csvFile, delimiter=',',quotechar='"', quoting=csv.QUOTE_NONNUMERIC)
            csvwriter.writerow(['Stock Code', 'Stock Code Api', 'Time Stamp', 'Open', 'Low', 'High', 'Close', 'Volume'])
            for row in range(data_len):
                data_list = []
                data_list.append(stock_code)
                data_list.append(stock_code_api)
                time_stamp = datetime.utcfromtimestamp(data.get("timestamp")[row]/1000)
                data_list.append(time_stamp)
                open_rate = check_numerical(data.get("open", 0)[row])
                data_list.append(open_rate)
                low = check_numerical(data.get("low", 0)[row])
                data_list.append(low)
                high = check_numerical(data.get("high", 0)[row])
                data_list.append(high)
                close = check_numerical(data.get("close", 0)[row])
                data_list.append(close)
                volume = check_numerical(data.get("volume", 0)[row])
                data_list.append(volume)
                csvwriter.writerow(data_list)

        # YahooFinanceApi.get_stock_price.cache_clear()

        MessageUtils.output_msg("ME0010", __name__, stock_code, LOG_LEVEL.MESSAGE_SUCCESS)

                


# # ===============================




#   """
#     Get Market Price
#     """
#   def get_market_price_from_db(stock_code):
#     data = SQLmapper.get_stock_price_Yahoo_finance(stock_code)
#     if len(data) > 0 :
#       return data

#     for num in range(len(data)):
#       lists = {}
#       lists["stock_code"] = data[num][0]
#       lists["stock_code_api"] = data[num][1]
#       lists["time_stamp"] = data[num][2]
#       lists["open_rate"] = data[num][3]
#       lists["low_rate"] = data[num][4]
#       lists["high_rate"] = data[num][5]
#       lists["close_rate"] = data[num][6]
#       lists["volume"] = data[num][7]

#     return lists

#   """
#     get data with List Format
#     """
#   def get_data_with_list(stock_code, period_type, period_type_num, frequency_type, frequency_type_num):

#     lists = []
#     data = YahooFinanceApi.get_market_price(stock_code, period_type, period_type_num, frequency_type, frequency_type_num)
#     if data:
#       row = len(data["timestamp"])
#       for num in range(row):
#         time_stamp = datetime.utcfromtimestamp(data["timestamp"][num]/1000)
#         lists.append([data.get("stock_code"), data.get("stock_code_api"), time_stamp, data["open"][num], data["low"][num], data["high"][num], data["close"][num], data["volume"][num]])
#       return lists

#     return lists

#   """
#     Insert Market Price into Data Base (PostgreSQL)
#     """
#   def insert_market_price_postgresql(stock_code):
#     base_date = DateUtils.get_base_date()
#     data = YahooFinanceApi.get_market_price_with_pandas(stock_code, base_date, base_date)
#     print(data)
#     SQLmapper.insert_data_from_yahoo_finance(data)

#   """
#     Get Market Price of JPX stock data (PostgreSQL)
#     """
#   def get_market_price_of_jpx_stock_data():

#     stock_list = SQLmapper.get_all_stock_list()
#     row = len(stock_list)
#     for num in range(row):
#       stock_code = stock_list[num][5]
#       YahooFinanceApi.insert_market_price_postgresql(stock_code)

#   """
#     Get Market Price of JPX stock data (PostgreSQL)
#     """
#   def output_market_price():
#     stock_list = SQLmapper.get_all_stock_list()
#     row = len(stock_list)
#     for num in range(row):
#       stock_code = stock_list[num][5]
#       result = YahooFinanceApi.output_market_price_csv(stock_code, PERIOD_TYPE.DAY, 2, FREQUENCY_TYPE.MINUTE, 5)

# class MainProcess:

#   def output_market_price_csv():
#     stock_list = SQLmapper.get_all_stock_list()
#     row = len(stock_list)
#     for num in range(row):
#       stock_code = stock_list[num][5]
#       lists = YahooFinanceApi.get_data_with_list(stock_code)
#       if not lists:
#         message = MessageUtils.get_message("ME0003", stock_code)
#         LogFunc.write_logfile_console(LOG_LEVEL.INFO, 'output_market_price_csv', message)
#       return RETURN_CODE.WARNING_CODE
