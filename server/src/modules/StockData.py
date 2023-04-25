# Module - Stock Data -*- coding: utf-8 -*-
import datetime
import pandas as pd
from urllib.request import *

# Import - Reference
import sys
from pathlib import Path
sys.path.append(str(Path(__file__).parent.parent.parent))

# Import - Source Code
from src.Dao.SQLmapper import SQLmapper
from src.utils.MessageUtils import MessageUtils
from src.utils.LogFunc import LogFunc
from src.utils.config import *
from src.const import RETURN_CODE, LOG_LEVEL
from src.utils.decorators import module_decorator


base_url = 'https://www.jpx.co.jp'
rsult = RETURN_CODE.FATAL_CODE


class StockData:

    def __init__(self) -> None:
        """
        Initial setting
        """
        self.current_time = datetime.datetime.now().strftime('-%Y-%m-%d-%H-%M-%S')
        self.url = SettingInfo.get_jpx_stocks_bonds_url()
        self.data = StockData.get_jpx_data()
        self.data_format = StockData.get_data_format(self.data)
        self.file_path = f'{SettingInfo.get_download_dir()}東証上場銘柄一覧{self.current_time}.xls'
        self.csv_path = f'{SettingInfo.get_csv_dir()}Stock_List{self.current_time}.csv'
        self.csv_header = ['base_date', 'Stock_Code', 'Stock_Name', 'Market_Segment', '33_Industry_Code',
                           '33_Industry_Segment', '17_Industry_Code', '17_Industry_Segment', 'Scale_Code', 'Scale_Segment']

    def get_data_format(data):
        """
        Data Format
        """
        df_new = data.rename(columns={'日付': 'base_date', 'コード': 'Stock_Code', '銘柄名': 'Stock_Name', '市場・商品区分': 'Market_Segment', 
                                      '33業種コード': '33_Industry_Code', '33業種区分': '33_Industry_Segment', 
                                      '17業種コード': '17_Industry_Code', '17業種区分': '17_Industry_Segment', 
                                      '規模コード': 'Scale_Code', '規模区分': 'Scale_Segment'})
        return df_new
    
    @staticmethod
    def get_jpx_data():
        """
        Get JPX Data
        """
        try:
            url = SettingInfo.get_jpx_stocks_bonds_url()
            data = pd.read_excel(url, sheet_name='Sheet1', header=0)

        except Exception as e:
            tb = sys.exc_info()[2]
            MessageUtils.output_exception("ME0006", __name__, e.with_traceback(tb))
            LogFunc.write_logfile_console(logLevel=LOG_LEVEL.ERROR, fucName=type(e).__name__, msg=f"{e.msg}")

        else:
            return data

    def get_jpx_data_for_api():
        """
         Get JPX Data 
        """
        stock_info = StockData()
        result = stock_info.data_format
        return result


    def save_CSV():
        """
        Save JPX Data on CSV
        """
        stock_info = StockData()
        header = stock_info.csv_header
        file_path = stock_info.csv_path
        data = stock_info.data_format
        data[header].to_csv(file_path, index=False, encoding='utf-8')


    def download_stock_data():
        """
        Download Stock Data of JPX on Excel
        """
        info = StockData()
        info.data.to_excel(info.file_path, sheet_name='銘柄一覧')
        MessageUtils.output_msg('ME0007', __name__, '銘柄一覧')


    # """
    #   Insert Stock Data of JPX into Data base
    #   """
    # def insert_stock_data():
    #   data_count = SQLmapper.get_stock_data_count()
    #   if data_count > 1:
    #     return RETURN_CODE.WARNING_CODE
    #   info = StockData()
    #   count = len(info.data_format['base_date'])
    #   for num in count:
    #     SQLmapper.insert_stock_data_from_jpx()



