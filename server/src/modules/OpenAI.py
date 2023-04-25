# Module - openAI API -*- coding: utf-8 -*-
import openai

# Import - Reference
import sys
from pathlib import Path
sys.path.append(str(Path(__file__).parent.parent.parent))

# Import - Source Code
from src.utils.config import SettingInfo
from src.utils.LogFunc import LogFunc
from src.const import LOG_LEVEL
from src.utils.decorators import module_decorator

# openAI API
openai.organization = SettingInfo.get_openai_organization()
openai.api_key = SettingInfo.get_openai_api_key()


class OpenAiApi:

    """ init """

    def __init__(self):
        self.organization = SettingInfo.get_openai_organization()
        self.api_key = SettingInfo.get_openai_api_key()

    async def get_model_list():
        """
        Get Model List in openAI 

        Args:

        Return:
            data (obj): Model List
        """
        data = None
        try:
            LogFunc.write_logfile_console(
                LOG_LEVEL.INFO, __name__, 'Select Data is no row count')
            data = openai.Model.list()

        except Exception as e:
            LogFunc.write_logfile_console(LOG_LEVEL.FATAL, __name__, e)

        else:
            LogFunc.write_logfile_console(
                LOG_LEVEL.INFO, __name__, 'Getting openAI Models Successfully completed!')
        return data

    @module_decorator(name="ChatGPT API", time_log=True)
    def chat(mode: int = 0, messages: list = [{"role": "user", "content": "Would like to start a conversation!"}]):
        """
        Chat of ChatGPT 

        Args:
            mode (int): Mode of ChatGPT 
            messages (list): Message List. ex) [{"role": "user", "content": "The Conversation content"}, {"role": "user", "content": "The Conversation content"}, ...] 

        Return:
            data (obj): Model List
        """
        data = None

        def _set_model(mode):
            """ 
            Set Model of ChatGPT 

            Args:
                mode (int): Select Model of ChatGPT

            """
            if mode == 1:
                return "gpt-4"
            else:
                return "gpt-3.5-turbo"
        model = _set_model(mode)
        data = openai.ChatCompletion.create(model=model, messages=messages)
        LogFunc.write_logfile_console(
            LOG_LEVEL.INFO, __name__, 'Getting openAI Models Successfully completed!')

        return data

        # print(res['choices'][0]['message']['content'])
