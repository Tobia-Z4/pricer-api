# Utils - decorators -*- coding: utf-8 -*-
from fastapi import HTTPException
from functools import wraps
from datetime import datetime
import traceback
import inspect
import logging

# Import - Reference
import sys
from pathlib import Path
sys.path.append(str(Path(__file__).parent.parent.parent))

# Import - Source Code
from .DateUtils import DateUtils
from .config import *
from .MessageUtils import MessageUtils
from .LogFunc import LogFunc
from src.const import RETURN_CODE


def module_decorator(name=None, time_log=False):
    """
    Output the function and contents of the log when an exception occurs

    Args:
        name (str, optional): _description_. Defaults to "internal function".
    """
    if name is None:
        name = "Internal Function"

    def module_wrapper(func):
        @wraps(func)
        def inner_logger(*args, **kwargs):
            try:
                parents = [d.function for d in inspect.stack()[1:-1]]
                parents.append(func.__name__)
                parents = "/".join(parents)

                # Set BASE DATE
                base_date = DateUtils.get_today_for_log()
                LogFunc.write_logfile_console(
                    logging.INFO, f"{name}({parents}) START ")

                bf_time = datetime.now()
                ret = func(*args, **kwargs)
                if time_log:
                    af_time = datetime.now()
                    MessageUtils.output_message_kwargs(message_id="ME0008", func_name=__name__, name=name, base_date=base_date, bf_time=bf_time, af_time=af_time, total=str(af_time-bf_time))

                LogFunc.write_logfile_console(
                    logging.INFO, f"{name}({parents}) END ")

                return ret

            except Exception as e:
                LogFunc.write_logfile_console(
                    logging.CRITICAL, f"{name} ({parents}) is {e} traceback is {traceback.format_exc()}")
                raise

        return inner_logger
    return module_wrapper


def _decorator(name=None, time_log=False):
    """
    Output the service of the log when an exception occurs

    Args:
        name (str, optional): _description_. Defaults to "internal function".
    """
    if name is None:
        name = "Controller"

    def _wrapper(func):
        @wraps(func)
        def inner_logger(*args, **kwargs):
            try:
                parents = [d.function for d in inspect.stack()[1:-1]]
                parents.append(func.__name__)
                parents = "/".join(parents)

                # Set BASE DATE
                base_date = DateUtils.get_today_for_log()
                LogFunc.write_logfile_console(msg = f"{name}({parents}) START ")

                bf_time = datetime.now()
                ret = func(*args, **kwargs)
                if time_log:
                    af_time = datetime.now()
                    MessageUtils.output_message_kwargs(message_id="ME0009", func_name=__name__, name=name, base_date=base_date, 
                                                       bf_time=bf_time, af_time=af_time, total=str(af_time-bf_time))

                LogFunc.write_logfile_console(msg = f"{name}({parents}) END ")

                return RETURN_CODE.SUCCESS_CODE

            except Exception as e:
                LogFunc.write_logfile_console(logging.CRITICAL, f"{name} ({parents}) is {e} traceback is {traceback.format_exc()}")
                return RETURN_CODE.FATAL_CODE

        return inner_logger
    return _wrapper


def api_decorator(name=None, time_log=False):
    """
    Output the function and contents of the log when an exception occurs

    Args:
        name (str, optional): _description_. Defaults to "internal function".
    """
    if name is None:
        name = "API Decorator"

    def api_wrapper(func):
        @wraps(func)
        def inner_logger(*args, **kwargs):
            try:
                parents = [d.function for d in inspect.stack()[1:-1]]
                parents.append(func.__name__)
                parents = "/".join(parents)

                # Set BASE DATE
                base_date = DateUtils.get_today_for_log()
                LogFunc.write_logfile_console(
                    logging.INFO, f"{name}({parents}) START ")

                bf_time = datetime.now()
                ret = func(*args, **kwargs)
                if time_log:
                    af_time = datetime.now()
                    MessageUtils.output_message_kwargs(message_id="ME0008", func_name=__name__, name=name, base_date=base_date, 
                                                       bf_time=bf_time, af_time=af_time, total=str(af_time-bf_time))

                return ret

            except Exception as e:
                LogFunc.write_logfile_console(
                    logging.CRITICAL, f"{name} ({parents}) is {e} traceback is {traceback.format_exc()}")
                raise HTTPException(
                    status_code=404, detail=f"Error: Pricer API failed ({e})")
            
            finally:
                LogFunc.write_logfile_console(logging.INFO, f"{name}({parents}) END ")

        return inner_logger
    return api_wrapper
