# Services - SBOC0003 -*- coding: utf-8 -*-
# INSERT stock price from Yahoo Finance API
from concurrent.futures import ThreadPoolExecutor, ProcessPoolExecutor
from datetime import datetime

# Import - Reference
import sys
from pathlib import Path
sys.path.append(str(Path(__file__).parent.parent.parent))

# Import - Source Code
from src.const import RETURN_CODE, LOG_LEVEL
from src.utils.MessageUtils import MessageUtils
from src.utils.LogFunc import LogFunc
from src.utils.ValueUtils import *
from src.utils.DateUtils import DateUtils
from src.modules.YahooFinanceApi import YahooFinanceApi
from src.Dao.SQLmapper import SQLmapper


result = RETURN_CODE.WARNING_CODE


class Sboc0003:
    """
        SBOC0003: 
            
            Output Market Price of JPX Daily into CSV
        
        """

    def main(info: None, max_workers: int = 1):
        """
        SBOC0001: 
           Main Process
        
        """

        def sub_main(stock_data):
            """
            SBOC0001: 
                Sub Process
            Args:
                data (list): Stock Data
            """
            # Get Stock pirce for Daily
            stock_code = stock_data.get('stock_code')
            stock_code_api = stock_data.get('stock_code_api')
            
            # Insert Stock Price Data
            MessageUtils.output_msg("ME0010", __name__, stock_code_api, "Start")

            YahooFinanceApi.output_market_price_csv(stock_code=stock_code, stock_code_api=stock_code_api)
            YahooFinanceApi.output_market_price_csv.cache_clear()

            MessageUtils.output_msg("ME0010", __name__, stock_code, LOG_LEVEL.MESSAGE_SUCCESS)


        # Get Stock Code of JPX
        stock_list = SQLmapper.get_target_data()

        # Count Stock List
        with ThreadPoolExecutor(max_workers=max_workers) as executor:
            # executor.submit(insrt_WStockData)
            executor.map(sub_main, stock_list)
            # ex) Args has it: executor.submit(sub_main, 1, 2)
