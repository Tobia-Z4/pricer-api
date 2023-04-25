# Utils - Date Utils -*- coding: utf-8 -*-
import calendar
from datetime import datetime, timedelta


class DateUtils:

    """
        Class Date Utils

        Return: 
            パラメータ
        """

    def __init__(self) -> None:
        self.now = DateUtils.get_now_time
        self.base_date = DateUtils.get_base_date
        self.month_range = DateUtils.get_month_range
        self.log_date = DateUtils.get_today_for_log

    def get_now_time():
        """
        Get Now Time

        Return: 
            Now Time: 現時刻 
        """
        date = datetime.now()
        return date

    def get_base_date():
        """
        Get Base Date

        Return: 
            Base Date: 現標準時刻
        """
        date = datetime.now()
        return date.strftime("%Y%m%d")

    def get_today_for_log():
        """
        Get Today Format For Log File

        Return:
            Date Log Format: 現時刻 (Y-M-D)
        """
        date = datetime.now()
        return date.strftime("%Y-%m-%d")

    def get_month_range():
        """
        Get Month Range

        Return:
            Month Range: 月末
        """
        date = datetime.now()
        return f"{date.year}{date.month}{calendar.monthrange(date.year, date.month)[1]}"

    def select_month_range(num):
        """
        Get Selected Month Range

        Arg: 
            num - ex) -1, 1: 

        Return:
            Selected Month Range
        """
        date = datetime.now()
        month = date.month
        year = date.year
        next_month = month + 1 + num if month < 12 else 1
        next_year = year + 1 if month == 12 else year
        first_day = datetime(next_year, next_month, 1)
        last_day = first_day - timedelta(days=1)
        return last_day.strftime('%Y%m%d')

    def get_current() -> str:
        """
        Get Current Time

        Return:
           Current Time (str)
        """
        return datetime.now().strftime('-%Y-%m-%d-%H-%M-%S')
    
