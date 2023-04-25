# Server Start -*- coding: utf-8 -*-

# Import - packages
from starlette.exceptions import HTTPException as StarletteHTTPException
from starlette.middleware.cors import CORSMiddleware
from fastapi.responses import PlainTextResponse
from fastapi.exceptions import RequestValidationError
from fastapi import FastAPI
from pydantic import BaseModel
import json

# Import - Reference
import sys
from pathlib import Path
sys.path.append(str(Path(__file__).parent.parent.parent))

# Import - Source Code
from src.const.REST_METHODS import *
from src.modules.OpenAI import OpenAiApi
from src.modules.StockData import StockData
from src.modules.YahooFinanceApi import YahooFinanceApi
from src.const import PERIOD_TYPE, FREQUENCY_TYPE
from src.utils.decorators import api_decorator

class ResBody(BaseModel):
    """ Stock Model """
    Stock_Code: str
    Period_Type: str
    Period_Type_num: int
    Frequency_Type: str
    Frequency_Type_Num: int


class chatUser(BaseModel):
    """ Chat Model """
    mode: int
    messages: list = [{"role": "user", "content": "The Conversation content"}]


description = "株価・銘柄リストAPI取得"
app = FastAPI(title="Stock Pricer API",
              description=description,
              version="0.0.1",
              terms_of_service="http://example.com/terms/",
              contact={
                  "name": "Deadpoolio the Amazing",
                  "url": "http://x-force.example.com/contact/",
                  "email": "dp@x-force.example.com",
              },
              license_info={
                  "name": "Apache 2.0",
                  "url": "https://www.apache.org/licenses/LICENSE-2.0.html",
              },
              )


# CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"]
)


@app.exception_handler(StarletteHTTPException)
async def http_exception_handler(request, exc):
    return PlainTextResponse(str(exc.detail), status_code=exc.status_code)


@app.exception_handler(RequestValidationError)
async def validation_exception_handler(request, exc):
    return PlainTextResponse(str(exc), status_code=400)


@app.get("/")
@api_decorator(name="Check Server Status", time_log=True)
def check_status():
    """
    Check Server Status
    """
    return {"status": True}


@app.get("/stockdata")
@api_decorator(name="/stockdata", time_log=True)
def get_stock_data():
    """
    Get Stock List
    """
    data = StockData.get_jpx_data_for_api()
    rejson = data.to_json()
    return rejson


@app.get('/marketprice')
@api_decorator(name="/marketprice", time_log=True)
def get_market_price_from_yahoo_Finance(stock_code):
    """
    Get Market Price By Stock Code with Pandas

    Args:
      stock_code (str): 銘柄コード
      start_day (str): 開始日
      end_day (str): 終了日

    Return: 
      data (JSON)
    """
    period_type = PERIOD_TYPE.DAY
    period_type_num = 2
    frequency_type = FREQUENCY_TYPE.MINUTE
    frequency_type_num = 5
    data = YahooFinanceApi.get_stock_price(stock_code, period_type, period_type_num, frequency_type, frequency_type_num)
    return json.dumps(data, indent=2)


@app.post('/chatgpt')
@api_decorator(name="/chatgpt", time_log=True)
def post_chatgpt(ChatUser: chatUser):
    """
    Post chat to ChatGPT

    Args:
        message (str): メッセージ

    Return:
        data (JSON): メッセージデータ
    """
    mode = ChatUser.mode
    messages = ChatUser.messages
    resBody = OpenAiApi.chat(mode, messages)
    return resBody
