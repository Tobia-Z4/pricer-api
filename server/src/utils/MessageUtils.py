# Utils - Message Utils -*- coding: utf-8 -*-
import os
import sys

# Import - Reference
import sys
from pathlib import Path
sys.path.append(str(Path(__file__).parent.parent.parent))

# Import - Source Code
from src.const import LOG_LEVEL
from src.utils.config import SettingInfo
from src.utils.JsonFunc import JsonFunc
from src.utils.LogFunc import LogFunc

file_path = os.path.abspath(SettingInfo.get_message_json_path())
data = JsonFunc.read(file_path)


class MessageUtils:

    def get_message(message_id, *args):
        """
        Get Message From Json
        Args:
            message_id (str): メッセージID
            args (Object): 
        Return:
            Message (str): メッセージ
        """
        text_message = data.get(message_id)
        message = text_message.format(*args)
        return message
    

    def output_message_kwargs(message_id: str, func_name: str, **kwargs) -> str:
        """
        Get Message From Json for kwargs
        Args:
            message_id (str): メッセージID
            args (Object): 
        Return:
            Message (str): メッセージ
        """
        msg = data.get(message_id)
        infoMsg = msg.format(**kwargs)
        LogFunc.write_msg_logfile(fucName=func_name, msg=infoMsg)
    

    def output_msg(message_id: str, func_name: str, *args):
        """
        Get Message From Json
        Args:
            message_id (str): Message ID
            func_name (str): Functoin Name
            args (Object): Args
        :Return:
        """
        text_msg = data.get(message_id)
        msg = text_msg.format(*args)
        LogFunc.write_msg_logfile(fucName=func_name, msg=msg)


    def output_exception(logLevel: (int) = LOG_LEVEL.ERROR, message_id: str = '', func_name: str = __name__, *args):
        """
        Get Message From Json
        Args:
            message_id (str): Message ID
            func_name (str): Functoin Name
            args (Object): Args
        :Return:
        """
        text_msg = data.get(message_id)
        msg = text_msg.format(*args)
        LogFunc.write_logfile_console(logLevel, fucName=func_name, msg=msg)
