#!/usr/bin/env python3
"""Setup cron with tasks discovered from the environment variables."""

# Steps:
# prepare
# extract
# transform
# load
# succeed
# failed
# finally

# Resources:
# - https://crontab.guru

# Define tasks with environment variables:
# TASK_<taskId>_CRONTAB
# TASK_<taskId>_PERIODICITY
# TASK_<taskId>_PREPARE
# TASK_<taskId>_EXTRACT
# TASK_<taskId>_TRANSFORM
# TASK_<taskId>_LOAD
# TASK_<taskId>_SUCCEED
# TASK_<taskId>_FAILED
# TASK_<taskId>_FINALLY

# Configure with environment variables
# CONF_TASKS_DIR
# CONF_WORK_DIR

import logging
import os
import pathlib
from typing import Dict

logging.basicConfig(level=logging.INFO)
logging.root.name = "setup-cron"

CONST_VARIABLE_PREFIX = "TASK_"
CONST_TASKS_DIR = pathlib.Path(os.environ["CONF_TASKS_DIR"] if "CONF_TASKS_DIR" in os.environ else "/tasks")
CONST_WORK_DIR = pathlib.Path(os.environ["CONF_WORK_DIR"] if "CONF_WORK_DIR" in os.environ else "/workdir")
CONF_ETC_DIR = pathlib.Path(os.environ["CONF_ETC_DIR"] if "CONF_ETC_DIR" in os.environ else "/etc")

CONST_TASKS_DIR.mkdir(parents=True, exist_ok=True)
CONST_WORK_DIR.mkdir(parents=True, exist_ok=True)

Task = Dict[str, str]
Tasks = Dict[str, Task]


def create_bash_function(n: str, t: Task):
    fn_name = f"execute_{n}"
    content = f"echo in {fn_name}"
    if n in t:
        content += f"\n{t[n]}"
    return f"function {fn_name} {{\n{content}\n}}\n"


tasks: Tasks = {}

# discovers the tasks from environment variables
varKey: str
varVal: str
for varKey, varVal in os.environ.items():
    if varKey.startswith(CONST_VARIABLE_PREFIX):
        logging.info(f"process {varKey} = {varVal}")
        parts = varKey.split('_')
        taskId = parts[1]
        step = parts[2]
        if taskId not in tasks:
            tasks[taskId] = {}
        tasks[taskId][step.lower()] = varVal

for taskId, task in tasks.items():
    logging.info(f"process {taskId}")

    wdPath = CONST_WORK_DIR.joinpath(taskId)
    srcPath = wdPath.joinpath("src")
    srcPath.mkdir(parents=True, exist_ok=True)
    dstPath = wdPath.joinpath("dst")
    dstPath.mkdir(parents=True, exist_ok=True)

    shPath = CONST_TASKS_DIR.joinpath(f"{taskId}.sh")
    text = "#!/usr/bin/env bash\n"
    text += "trap 'the script failed at line $LINENO' ERR\n"
    text += f"export SRC={srcPath.absolute()}\n"
    text += f"export DST={dstPath.absolute()}\n"
    text += f"rm -Rf {srcPath.absolute()} {dstPath.absolute()}\n"
    text += f"mkdir -p {srcPath.absolute()} {dstPath.absolute()}\n"
    text += create_bash_function('prepare', task)
    text += create_bash_function('extract', task)
    text += create_bash_function('transform', task)
    text += create_bash_function('load', task)
    text += create_bash_function('succeed', task)
    text += create_bash_function('failed', task)
    text += create_bash_function('finally', task)
    text += f"echo execute task {taskId} - $PASSPHRASE\n"
    text += "{\n"
    text += "execute_prepare \\\n"
    text += "&& execute_extract \\\n"
    text += "&& execute_transform \\\n"
    text += "&& execute_load \\\n"
    text += "&& execute_succeed\n"
    text += "} || {\n"
    text += "execute_failed\n"
    text += "}\n"
    text += "execute_finally\n"
    text += "exit 0\n"
    shPath.write_text(text)
    shPath.chmod(0o775)

    if 'periodicity' in task:
        lnkPath = CONF_ETC_DIR.joinpath(f"cron.{task['periodicity']}/{taskId}")
        lnkPath.parent.mkdir(parents=True, exist_ok=True)
        os.symlink(shPath.absolute(), lnkPath.absolute())

    if 'crontab' in task:
        cronPath = CONF_ETC_DIR.joinpath(f"cron.{taskId}/task")
        cronPath.parent.mkdir(parents=True, exist_ok=True)
        if cronPath.exists():
            cronPath.unlink()
        os.symlink(shPath.absolute(), cronPath.absolute())
        crontabPath = CONF_ETC_DIR.joinpath("crontab")
        with open(crontabPath.absolute(), "a") as file:
            file.write(
                f"{task['crontab']} root cd /workdir && run-parts --report {cronPath.parent.absolute()} >/dev/stdout 2>/dev/stderr\n"
            )
