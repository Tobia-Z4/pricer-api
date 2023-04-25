# Controller -*- coding: utf-8 -*-
import uvicorn

# Import - Reference
import sys
from pathlib import Path
sys.path.append(str(Path(__file__).parent.parent.parent))

# Import - Source Code
from src.utils.config import SettingInfo
from src.utils.JsonFunc import JsonFunc
from src.utils.LogFunc import LogFunc
from src.utils.decorators import _decorator
from src.const import RETURN_CODE
# Import - Service
from src.services.Sboc0001 import Sboc0001
from src.services.Sboc0002 import Sboc0002
from src.services.Sboc0003 import Sboc0003


class args:
    def __init__(self, args) -> None:
        self.args = args


class Controller(args):

    def __init__(self, args) -> None:
        super().__init__(args)
        self.service = args
        self.service_data = JsonFunc.get_service_json()
        self.cpu_workers = SettingInfo.get_cpu_count()
        self.gpu_workers = SettingInfo.get_gpu_count()


    @_decorator(name="Start Controller", time_log=True)
    def start_subprocess(args):
        """
        Controller Main process
        
        """
        info = Controller(args)
        target = info.service
        workers = info.gpu_workers if info.gpu_workers > 0 else info.cpu_workers

        if target == info.service_data["SBOC0000"]["SERVICE"]:
            uvicorn.run("server.src.app:app", host="0.0.0.0", port=8000, reload=True)
        if target == info.service_data["SBOC0001"]["SERVICE"]:
            LogFunc.write_logfile_console(fucName=info.service_data["SBOC0001"]["SERVICE"])
            Sboc0001.main(info=info, max_workers=workers)
        elif target == info.service_data["SBOC0002"]["SERVICE"]:
            Sboc0002.main(info=info, max_workers=workers)
        elif target == info.service_data["SBOC0003"]["SERVICE"]:
            Sboc0003.main(info=info, max_workers=workers)
        else:
            LogFunc.write_logfile_console(fucName="No Start Module", msg="Please check parameter of Args!")


        return RETURN_CODE.SUCCESS_CODE
