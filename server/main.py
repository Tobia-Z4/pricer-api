# Batch Start - Main -*- coding: utf-8 -*-
import os
import sys
import argparse

# Import - Reference
import sys
from pathlib import Path
sys.path.append(str(Path(__file__).parent.parent.parent))

# Import - Source Code
from src.utils.LogFunc import LogFunc
from src.const import LOG_LEVEL, RETURN_CODE
from src.Controller import *


def main(argv=sys.argv):
    """
    Main Process

    Args:
        argv (args): Argv

    Return:
        RETURN CODE
    """

    def _check_args(args):
        """
        Check args

        Args:
            args (list): Args
        """
        if len(args) < 2:
            LogFunc.write_logfile_console(LOG_LEVEL.INFO, __name__, "In this App, args need to set over two args")
            sys.exit(RETURN_CODE.FATAL_CODE)

    def _check_argv_service():
        """ Check argv of Service """
        try:
            # Args ArgumentParser
            parser = argparse.ArgumentParser()
            parser.add_argument('--service', help='Service Name')
            parser.add_argument('--parallel_processing', help='Parallel Processing')
            pargs = parser.parse_args()

            if pargs.service:
                LogFunc.write_logfile_console(LOG_LEVEL.INFO, __name__, f'service name: {pargs.service}')
            else:
                LogFunc.write_logfile_console(LOG_LEVEL.INFO, __name__, "In this App, args need to set over two args")
                sys.exit(RETURN_CODE.FATAL_CODE)

        except Exception as e:
            LogFunc.write_logfile_console(LOG_LEVEL.INFO, __name__, "In this App, args need to set over two args")
            sys.exit(RETURN_CODE.FATAL_CODE)

        else:
            return pargs
    
    _check_args(argv)
    pargs = _check_argv_service()

    try:
        Controller.start_subprocess(pargs.service)

    except Exception as e:
        # tb = sys.exc_info()[2]
        # e.with_traceback(tb)
        LogFunc.write_logfile_console(LOG_LEVEL.ERROR, __name__, f"message:{str(e)}")
        sys.exit(RETURN_CODE.FATAL_CODE)

    else:
        sys.exit(RETURN_CODE.SUCCESS_CODE)


# Frist Process
if sys.path[0] != os.path.dirname(os.path.realpath(__file__)):
    sys.path.insert(0, os.path.dirname(os.path.realpath(__file__)))

if __name__ == '__main__':
    main()
