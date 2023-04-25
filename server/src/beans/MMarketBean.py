# M Market Model -*- coding: utf-8 -*-

class MMarketBean:

    def __init__(self) -> None:
        self.market_code = None
        self.market_name = None
        self.market_segment_code = None
        self.market_segment = None
        self.market_stock_code = None
        self.market_stock_code_api = None
        self.delete_flg = None
        self.create_date = None
        self.create_user_id = None
        self.update_date = None
        self.update_user_id = None
        self.data = None

    def get_market_data(self):
        return self.data

    def set_market_data(self, data):
        self.data = data
