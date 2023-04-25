# Utils - Json Function -*- coding: utf-8 -*-
import os
import json

# Import - Reference
import sys
from pathlib import Path
sys.path.append(str(Path(__file__).parent.parent.parent))

# Import - Source Code
from src.utils.config import SettingInfo


class JsonFunc:

    # read Json File
    def read(file_path):
        fd = open(file_path, mode='r')
        data = json.load(fd)
        return data

    def get_service_json():
        file_path = os.path.abspath(SettingInfo.get_service_json_path())
        fd = open(file_path, mode='r')
        data = json.load(fd)
        return data
