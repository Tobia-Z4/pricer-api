# Utils - Log Functions -*- coding: utf-8 -*-
import logging

# Import - Reference
import sys
from pathlib import Path
sys.path.append(str(Path(__file__).parent.parent.parent))

# Import - Source Code
from src.utils.DateUtils import DateUtils
from src.utils.config import *

class LogFunc:

    def write_logfile_console(logLevel: (int) = logging.INFO, fucName=__name__, msg=""):
        """
        Out Put Log without a Log files

        Args:
            logLevel (int): ログレベル
            fucName (str): ファンクション名
            msg (str): メッセージ    
        """

        # Importでパス取得される
        today = DateUtils.get_today_for_log()
        log_path = SettingInfo.get_logfile_path().format(today)

        # Main process
        str_handler = logging.StreamHandler()
        file_handler = logging.FileHandler(log_path)
        format_str = '%(asctime)s - %(process)d - %(thread)d - %(name)s - %(levelname)s - %(message)s'

        logging.basicConfig(format=format_str, level=logLevel,
                            handlers=[str_handler, file_handler])
        logger = logging.getLogger(fucName)

        if logLevel == logging.DEBUG:
            logger.debug(msg)
        elif logLevel == logging.INFO:
            logger.info(msg)
        elif logLevel == logging.WARNING:
            logger.warning(msg)
        elif logLevel == logging.ERROR:
            logger.error(msg)
        elif logLevel == logging.CRITICAL:
            logger.critical(msg)


    def write_msg_logfile(logLevel: int = logging.INFO, fucName=__name__, msg=""):
        """
        Output Msg to a Log files

        Args:
            logLevel (int): Log Level
            fucName (str): Function Name
            msg (str): Message
        """
        if not SettingInfo.get_output_status():
            return

        # Importでパス取得される
        today = DateUtils.get_today_for_log()
        log_path = SettingInfo.get_logfile_path().format(today)

        # Main process
        str_handler = logging.StreamHandler()
        file_handler = logging.FileHandler(log_path)
        format_str = '%(asctime)s - %(process)d - %(thread)d - %(name)s - %(levelname)s - %(message)s'

        logging.basicConfig(format=format_str, level=logLevel,
                            handlers=[str_handler, file_handler])
        logger = logging.getLogger(fucName)

        if logLevel == logging.DEBUG:
            logger.debug(msg)
        elif logLevel == logging.INFO:
            logger.info(msg)
        elif logLevel == logging.WARNING:
            logger.warning(msg)
        elif logLevel == logging.ERROR:
            logger.error(msg)
        elif logLevel == logging.CRITICAL:
            logger.critical(msg)


    def write_sql_log(logLevel=logging.INFO, fucName=__name__, msg=""):
        """
        Out Put SQL Log

        Args:
            logLevel (Log_level): ログレベル
            fucName (str): ファンクション名
            msg (str): メッセージ    
        """
        # Importでパス取得される
        log_path = SettingInfo.get_logfile_path()
        # Main process
        str_handler = logging.StreamHandler()
        file_handler = logging.FileHandler(log_path)
        format_str = '%(asctime)s - %(process)d - %(thread)d - %(name)s - %(levelname)s - %(message)s'
        logging.basicConfig(format=format_str, level=logLevel,
                            handlers=[str_handler, file_handler])
        logger = logging.getLogger(fucName)

        if logLevel == logging.DEBUG:
            logger.debug(msg)
        elif logLevel == logging.INFO:
            logger.info(msg)
        elif logLevel == logging.WARNING:
            logger.warning(msg)
        elif logLevel == logging.ERROR:
            logger.error(msg)
        elif logLevel == logLevel.CRITICAL:
            logger.critical(msg)

    def console_log(logLevel=logging.INFO, fucName=__name__, msg=""):
        """
        Console Log

        Args:
            logLevel (Log_level): ログレベル
            fucName (str): ファンクション名
        """
        # パラメーターチェック
        if msg is None:
            LogFunc.console_log(logLevel.CRITICAL, 'Param is none')
            raise ValueError('msg is None')

        format_str = '%(asctime)s - %(process)d - %(thread)d - %(name)s - %(levelname)s - %(message)s'
        logging.basicConfig(format=format_str, level=logLevel)
        logger = logging.getLogger(fucName)

        if logLevel == logging.DEBUG:
            logger.debug(msg)
        elif logLevel == logging.INFO:
            logger.info(msg)
        elif logLevel == logging.WARNING:
            logger.warning(msg)
        elif logLevel == logging.ERROR:
            logger.error(msg)
        elif logLevel == logLevel.CRITICAL:
            logger.critical(msg)


