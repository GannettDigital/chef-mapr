#!/usr/bin/env python
import subprocess
import sys
import re
import time
import logging

log = logging.getLogger(__file__)
logging.basicConfig(
    level=logging.INFO
)

regex = re.compile(sys.argv[1])
cmd = sys.argv[2:]


while True:
    log.info("Executing {cmd}".format(cmd=cmd))
    proc = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    (output, error) = proc.communicate()
    if regex.search(output):
        log.info("Pattern found in output")
        sys.exit(0)
    else:
        log.info("Pattern not found, sleeping for 1s and trying again")
        time.sleep(1)

