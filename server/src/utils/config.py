# Utils - config -*- coding: utf-8 -*-
import os
import sys
import torch
import configparser

# Import - Reference
import sys
from pathlib import Path
sys.path.append(str(Path(__file__).parent.parent.parent))

# read a config file
config = configparser.ConfigParser()

# path = Setting
path = os.path.abspath('server/resources/config.ini')

print(f"Config Path: {path}")

config.read(path)


class SettingInfo:

    def get_db_connection_info():
        """
        DB server connection Info
        """
        info = {
            "user": config['DBINFO']['USER'],
            "password": config['DBINFO']['PASSWORD'],
            "host": config['DBINFO']['HOST'],
            "dbname": config['DBINFO']['DBNAME'],
            "port": config['DBINFO']['PORT']
        }
        return info

    # Log File Path
    def get_logfile_path():
        """ Get Log File Path """
        return config.get('FILE', 'LOG_FILE_PATH')

    # Message File Path
    def get_message_json_path():
        """ Get Message File Path """
        return config.get('FILE', 'MESSAGE_FILE_PATH')

    # CSV dir
    def get_csv_dir():
        """ Get CSV dir """
        return config['FILE']['CSV_DIR']

    # Download dir
    def get_download_dir():
        """ Get Download dir """
        return config['FILE']['DOWNLOAD_DIR']

    def get_service_json_path():
        """ Get Service Info Path """
        return config['FILE']['SERVICE_JSON']

    # Stocks and Bonds of JPX Market Data URL
    def get_jpx_stocks_bonds_url():
        """ Get Stocks and Bonds of JPX Market Data URL """
        return config['HTTTP']['JPX_STOCKS_BONDS']

    # ETF and ETN of JPX Market Data URL
    def get_jpx_etf_etn_investment_url():
        """ Get ETF and ETN of JPX Market Data URL """
        return config['HTTTP']['ETF_ETN_INVESTMENT']

    # Time Out
    def set_time_out():
        """ Set Time Out """
        return config['DBINFO']['TIME_OUT']

    def get_openai_organization():
        """ Get openAI Organization """
        return config.get('OPENAI', 'ORGANIZATION')

    def get_openai_api_key():
        """ Get openAI API-KEY """
        return config.get('OPENAI', 'API_KEY')
    
    def get_openai_gpt_model():
        """ Get openAI GPT Model """
        return config.getint('OPENAI', 'GPT_MODEL')
    
    def get_cpu_count():
        """ CPU Core Count """
        num_cpus = os.cpu_count()
        print(f"Count CPU Core: {num_cpus}")
        return num_cpus
    
    def get_gpu_count():
        """ GPU Core Count """
        if torch.cuda.is_available():
            num_gpus = torch.cuda.device_count()
            print(f"Count GPU Core: {num_gpus}")
            return num_gpus
        else:
            print(f"Count GPU Core: No GPU available.")
            return 0
        
    def get_output_status():
        """ Log Level """
        return config.getboolean('LOG', 'OUTPUT') 
