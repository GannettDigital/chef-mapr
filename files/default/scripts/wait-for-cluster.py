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

count = int(sys.argv[1])
cmd = ["maprcli", "node", "list", "-columns", "hostname"]

while True:
    log.info("Executing {cmd}".format(cmd=cmd))
    proc = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    (output, error) = proc.communicate()
    up_count = len(output.splitlines()[1:])
    if up_count >= count:
        log.info("Cluster up")
        sys.exit(0)
    else:
        log.info("Only {up_count} of {count} nodes up, sleeping for 1s")
        time.sleep(1)
        
        
