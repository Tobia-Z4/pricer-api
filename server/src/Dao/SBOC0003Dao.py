# SBOC0003Dao -*- coding: utf-8 -*-
from calendar import month
import os

# Import - Reference
import sys
from pathlib import Path
sys.path.append(str(Path(__file__).parent.parent.parent))

# Import - Source Code
from src.const import DELETE_FLG, USER_ID
from src.utils.PostgreSQL import PostgreSQL
from src.utils.DateUtils import DateUtils
import mybatis_mapper2sql

base_dir = os.path.abspath(os.path.dirname(__file__))
xml = os.path.join(base_dir, 'SBOC0003Dao.xml')
mapper, xml_raw_text = mybatis_mapper2sql.create_mapper(xml=xml)


class SBOC0003Dao:

    def __init__(self) -> None:
        self.mapper = mapper
        self.xml_raw_text = xml_raw_text


    def get_market_code(market_code):
        """
        Get market code from the Server

        Args: 
            market_code (str): 金融市場コード

        return: 
            market_code (str): 市場コード
        """
        statement = mybatis_mapper2sql.get_child_statement(
            mapper, child_id='getMarketCode', reindent=True).format(market_code=market_code)
        return PostgreSQL.select(statement)


    def insert_stock_data_from_jpx():
        """
        Insert Stock Data from JPX Data

        return:
            INSERT DATA: インサート 
        """
        statement = mybatis_mapper2sql.get_child_statement(
            mapper, child_id='InsertTStockDataFromWJpx', reindent=True)
        return PostgreSQL.select(statement)


    def get_market_code_by_stock_code(stock_code):
        """
        Get market code from the Server

        Args:
            stock_code (str): 銘柄コード

        Return:
            market_code (str): 市場コード
        """
        statement = mybatis_mapper2sql.get_child_statement(
            mapper, child_id='getMarketCodeByStockCode', reindent=True).format(stock_code=stock_code)
        return PostgreSQL.select(statement)


    def get_stock_code_api_by_stock_code(stock_code):
        """
        Get Stock code Api from the Server

        Args: 
            stock_code (str): 銘柄コード

        Return:
            stock_code_api:
        """
        statement = mybatis_mapper2sql.get_child_statement(
            mapper, child_id='getStockCodeApiByStockCode', reindent=True).format(stock_code=stock_code)
        return PostgreSQL.select(statement)

    def insert_stock_price_from_yahoo_finance():
        """
        Insert Stock Price To W_Yahoo

        Args: 
            stock_code (str): 銘柄コード

        Return:

        """
        return mybatis_mapper2sql.get_child_statement(mapper, child_id='insertStockPriceToWYahoo', reindent=True)


    def get_data_by_stock_code(stock_code):
        """
        Get Stock Data from the Server

        Args:
            stock_code (str): 銘柄コード

        Return: 
            data:
        """
        statement = mybatis_mapper2sql.get_child_statement(
            mapper, child_id='getDatafromWYahooByStockCode', reindent=True).format(stock_code=stock_code)
        return PostgreSQL.select(statement)


    def insert_data_from_yahoo_finance(data):
        """
        Insert Stock Price To W_Yahoo for callFunc

        Args: 
            stock_code (str): 銘柄コード

        Return:
        """
        insert_query = SBOC0003Dao.insert_stock_price_from_yahoo_finance()
        check_query = SBOC0003Dao.check_for_stock_data()
        PostgreSQL.insert_stock_price(data, check_query, insert_query)


    def check_for_stock_data():
        """
        Check Stock Data into the Server

        Args: 
            stock_code (str): 銘柄コード

        Return: 
            data:
        """
        statement = mybatis_mapper2sql.get_child_statement(
            mapper, child_id='checkDataIntoWYahoo', reindent=True)
        return statement


    def get_all_stock_list():
        """
        Check all Stock Data into the Server

        Args 
            stock_code (str): 銘柄コード

        return 
            data:
        """
        statement = mybatis_mapper2sql.get_child_statement(
            mapper, child_id='getAllStockList', reindent=True)
        return PostgreSQL.select_dist(statement)


    def get_stock_price_Yahoo_finance(stock_code):
        """
        Get Stock price from the Server

        Args:
            stock_code (str): 銘柄コード

        return: 
            data:
        """
        delete_flg = DELETE_FLG.FALSE
        statement = mybatis_mapper2sql.get_child_statement(
            mapper, child_id='getStockPriceByStockCode', reindent=True).format(stock_code=stock_code, delete_flg=delete_flg)
        return PostgreSQL.select(statement)


    def get_stock_code_api():
        """
        Get Stock Code Api

        Args 
            stock_code (str): 銘柄コード

        return 
            stock_code_api:
        """
        statement = mybatis_mapper2sql.get_child_statement(
            mapper, child_id='stock_code', reindent=True)
        return PostgreSQL.select_dist(statement)


    def insrt_market_price_for_daily(*data):
        """
        Insert Stock Price For Daily

        Args: 
            stock_code (str): 銘柄コード

        return: 
            stock_code_api:
        """
        query = mybatis_mapper2sql.get_child_statement(
            mapper, child_id='insrtMarketPriceForDaily', reindent=True)
        delete_flg = DELETE_FLG.FALSE
        statement = query.format(data[0], data[1], data[2], data[3], data[4],
                                 data[5], data[6], data[7], data[8], delete_flg, USER_ID.MASTER)
        return PostgreSQL.insert(statement)


    def get_stock_data_count():
        """
        Insert Stock Price For Daily

        Args: 
            stock_code (str): 銘柄コード

        return: 
            stock_code_api:
        """
        query = mybatis_mapper2sql.get_child_statement(
            mapper, child_id='getWStockDataByBaseDate', reindent=True)
        month = DateUtils.select_month_range(-1)
        statement = query.format(month)
        return PostgreSQL.select_count(statement)
    
    def insrt_WStockData(*arydata):
        """
        Insert data to W Stock Data

        Args: 
            data (list): Stock List
        """
        data = arydata[0]
        query = mybatis_mapper2sql.get_child_statement(mapper, child_id='insrtWStockData', reindent=True)
        statement = query.format(data[0], data[1], data[2], data[3], data[4], data[5], data[6], data[7], data[8], data[9], DELETE_FLG.FALSE, USER_ID.MASTER)
        return PostgreSQL.insert(statement)
