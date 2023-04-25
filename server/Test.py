import unittest
import uvicorn
import pandas as pd

# Import - Reference
import sys
from pathlib import Path
sys.path.append(str(Path(__file__).parent.parent.parent))

# Import - Source Code
from src.Dao.SQLmapper import SQLmapper
from src.const import PERIOD_TYPE, FREQUENCY_TYPE
from src.utils.DateUtils import DateUtils
from src.modules.StockData import StockData
from src.modules.YahooFinanceApi import YahooFinanceApi
from src.modules.OpenAI import OpenAiApi

class Test_Modules(unittest.TestCase):
    """
    Modules TEST
    """
    
    def _test_get(self):
        nasdaq_listing = 'ftp://ftp.nasdaqtrader.com/symboldirectory/nasdaqlisted.txt'
        nasdaq = pd.read_csv(nasdaq_listing, sep='|')
        nasdaq.to_csv('to_csv_out.csv')


    def test_output_market_price_csv(self):
        YahooFinanceApi.output_market_price(self)
        print("Success")


    def test_get_market_price_of_jpx_stock_data(self):
        # YahooFinanceApi.get_market_price_of_jpx_stock_data()
        YahooFinanceApi.output_market_price()
        print("Success")


    def test_get_market_price_with_pandas(self):
        # stock_code = 'TQQQ'1766
        stock_code = '1766.T'
        base_date = DateUtils.get_base_date()
        data = YahooFinanceApi.get_market_price_with_pandas(
            stock_code, base_date, base_date)
        if not data:
            print("Failure")
        for num in range(len(data)):
            print(data)
        print("Success")


    def test_yahoo_finance_api(self):
        stock_code = 'TQQQ'
        YahooFinanceApi.output_market_price_csv(
            stock_code, PERIOD_TYPE.DAY, 10, FREQUENCY_TYPE.MINUTE, 5)


    def test_get_JPX_market_data(self):
        return_code = StockData.save_CSV()
        print(return_code)


    def test_market_data(self):
        data = SQLmapper.get_market_code()
        print(len(data))


    def test_insert_stock_data(self):
        print("Success")


    def calc(self):
        principal = 200000
        welfare = 1.05
        year_sum = principal * welfare
        for num in range(29):
            year_sum = (year_sum + principal) * welfare
        result = year_sum * 2
        print(result)


    def test_date_utils(self):
        result = DateUtils.select_month_range(-1)
        print(result)
        print(DateUtils.get_month_range())


    def test_stock_data(self):
        StockData.insert_stock_data()


class Test_API(unittest.TestCase):
    """
    TEST for API
    """

    def _test_get(self):
        uvicorn.run("app:app", host="0.0.0.0", port=8000, reload=True)

    def _test_chat():
        """
        TEST for ChatGPT API on Module
        """
        message = [{"role": "user", "content": "野球のルールを教えて"}]
        res = OpenAiApi.chat(message)
        print(res)


if __name__ == '__main__':
    unittest.main()
