# Services - SBOC0002 -*- coding: utf-8 -*-
from concurrent.futures import ThreadPoolExecutor
from datetime import datetime

# Import - Reference
import sys
from pathlib import Path
sys.path.append(str(Path(__file__).parent.parent.parent))

# Import - Source Code
from src.Dao.SBOC0002Dao import SBOC0002Dao
from src.modules.YahooFinanceApi import YahooFinanceApi
from src.utils.DateUtils import DateUtils
from src.utils.ValueUtils import *
from src.utils.MessageUtils import MessageUtils
from src.const import LOG_LEVEL


class Sboc0002:
    """
        SBOC0002: 
            Insert Market Price of JPX on Daily (PostgreSQL) 

        """

    def main(info: None, max_workers: int = 1):
        """
        SBOC0002: 
           Main Process

        """

        def sub_main(stock_data):
            """
            SBOC0001: 
                Sub Process
            Args:
                stock_data (list): Stock Data
            """

            # Get Stock pirce for Daily
            stock_code = stock_data.get('stock_code')
            stock_code_api = stock_data.get('stock_code_api')
            data = YahooFinanceApi.get_stock_price(stock_code=stock_code_api, period_type_num=5)

            # When Stock pirce Data is no data
            if not data:
                return
            
            # Insert Stock Price Data
            MessageUtils.output_msg("ME0005", __name__, stock_code, "Start")

            row = len(data["timestamp"])
            for num in range(row):
                time_stamp = datetime.utcfromtimestamp(
                    data["timestamp"][num]/1000)
                base_date = DateUtils.get_base_date()
                open = check_numerical(data["open"][num])
                low = check_numerical(data["low"][num])
                high = check_numerical(data["high"][num])
                close = check_numerical(data["close"][num])
                volume = check_numerical(data["volume"][num])
                SBOC0002Dao.insrt_market_price_for_daily(insert_date=base_date, stock_code=stock_code, stock_code_api=stock_code_api, 
                                                         time_stamp=time_stamp, open_rate=open, low_rate=low, high_rate=high, close_rate=close, volume=volume)

            MessageUtils.output_msg("ME0005", __name__, stock_code, LOG_LEVEL.MESSAGE_SUCCESS)

        # Get Stock Code of JPX
        stock_list = SBOC0002Dao.get_all_stock_list()

        # Count Stock List
        with ThreadPoolExecutor(max_workers=max_workers) as executor:
            # executor.submit(insrt_WStockData)
            executor.map(sub_main, stock_list)
            # ex) Args has it: executor.submit(sub_main, 1, 2)

