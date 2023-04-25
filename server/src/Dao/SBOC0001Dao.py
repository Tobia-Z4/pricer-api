# SQLmapper -*- coding: utf-8 -*-
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
xml = os.path.join(base_dir, 'SBOC0001Dao.xml')
mapper, xml_raw_text = mybatis_mapper2sql.create_mapper(xml=xml)


class SBOC0001Dao:

    def __init__(self) -> None:
        self.mapper = mapper
        self.xml_raw_text = xml_raw_text


    def insert_stock_data_from_jpx():
        """
        Insert Stock Data from JPX Data

        return:
            INSERT DATA: インサート 
        """
        statement = mybatis_mapper2sql.get_child_statement(
            mapper, child_id='InsertTStockDataFromWJpx', reindent=True)
        PostgreSQL.insert(statement)

    def insrt_WStockData(*arydata):
        """
        Insert data to W Stock Data

        Args: 
            data (list): Stock List
        """
        data = arydata[0]
        query = mybatis_mapper2sql.get_child_statement(mapper, child_id='insrtWStockData', reindent=True)
        statement = query.format(data[0], data[1], data[2], data[3], data[4], data[5], data[6], data[7], data[8], data[9], DELETE_FLG.FALSE, USER_ID.MASTER)
        PostgreSQL.insert(statement)

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
    
    def get_new_market_segment():
        """
        
        """
        query = mybatis_mapper2sql.get_child_statement(
            mapper, child_id='getNewMarketSegment', reindent=True)
        return PostgreSQL.select(query)
    
    def insrt_Mmarket(market_code: str, market_name: str, market_segment: str, market_stock_code: str, market_stock_code_api: str):
        """
        Insert a new data to M_market

        Args: 
            market_code (str): Market Code
            market_name (str): Market Name
            market_segment (str): Market Segment
            market_stock_code (str): Market Stock Code
            market_stock_code_api (str): Market Stock Code for API
        """
        query = mybatis_mapper2sql.get_child_statement(mapper, child_id='insertMmarket', reindent=True)
        statement = query.format(market_code=market_code, market_name=market_name, market_segment=market_segment, market_stock_code=market_stock_code, market_stock_code_api=market_stock_code_api, delete_flg=DELETE_FLG.FALSE, user_id=USER_ID.MASTER)
        PostgreSQL.insert(statement)
        