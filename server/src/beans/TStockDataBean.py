# T Stock Data Model -*- coding: utf-8 -*-

class TStockDataBean:

    def __init__(self) -> None:
        self.base_date = None
        self.stock_code = None
        self.stock_name = None
        self.market_code = None
        self.market_segment_code = None
        self.total_industry_code = None
        self.scale_code = None
        self.delete_flg = None
        self.create_date = None
        self.create_user_id = None
        self.update_date = None
        self.update_user_id = None
        self.data = None

    def get_stock_data(self):
        return self.data

    def set_stock_data(self, data):
        self.data = data
