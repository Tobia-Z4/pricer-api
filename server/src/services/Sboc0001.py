# Services - SBOC0001 -*- coding: utf-8 -*-
from concurrent.futures import ThreadPoolExecutor, ProcessPoolExecutor
from datetime import datetime

# Import - Reference
import sys
from pathlib import Path
sys.path.append(str(Path(__file__).parent.parent.parent))

# Import - Source Code
from src.const import MARKET_JPX
from src.utils.ValueUtils import *
from src.utils.config import SettingInfo
from src.modules.StockData import StockData
from src.Dao.SBOC0001Dao import SBOC0001Dao


class Sboc0001:
    """ SBOC0001: Update Stock List from JPX """

    def main(info: None, max_workers: int = 1):
        """
        SBOC0001: 
           Main Process
        
        """

        def insrt_WStockData(setData):
            """
            Sub Process
            """
            SBOC0001Dao.insrt_WStockData(setData)


        def update_market_tbl_jpx():
            """
            INSERT/UPDATE: TBL M_Market
            """
            segment_list = SBOC0001Dao.get_new_market_segment()
            for len in segment_list:
                market_name = MARKET_JPX.MARKET_NAME
                market_segment = len.get("market_segment")
                market_stock_code = MARKET_JPX.MARKET_STOCK_CODE
                market_stock_code_api = MARKET_JPX.MARKET_STOCK_CODE_API
                SBOC0001Dao.insrt_Mmarket(market_code=MARKET_JPX.MARKET_CODE, market_name=market_name, market_segment=market_segment, market_stock_code=market_stock_code, market_stock_code_api=market_stock_code_api)
        

        # INSERT New Market Segment from JPX
        update_market_tbl_jpx()

        # data Count for w_stock_data_jpx
        count = SBOC0001Dao.get_stock_data_count()
        if count > 0:
            return
        
        # Get Stock Code of JPX
        sd = StockData()
        stock_list = sd.data_format
        
        # Count Stock List
        with ThreadPoolExecutor(max_workers=max_workers) as executor:
            # executor.submit(insrt_WStockData)
            executor.map(insrt_WStockData, stock_list)
            # ex) Args has it: executor.submit(sub_main, 1, 2)

        # INSERT Stock data from JPX 
        SBOC0001Dao.insert_stock_data_from_jpx()

