#!/usr/bin/env python
import sys
import json
import os
import glob
import subprocess
import logging

log = logging.getLogger(__file__)
logging.basicConfig(
    level=logging.INFO
)


def guard_errors(args):
    proc = subprocess.Popen(args, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    (output, errors) = proc.communicate()
    if proc.returncode:
        log.error("Error running {args}: \n{output}".format(
            args=args,
            output=output
        ))
        sys.exit(1)
    else:
        return output



# Validate server for disksetup
if not os.path.exists("/opt/mapr/roles/fileserver"):
    log.warn("Disk discovery ran on non-fileserver node, no reason to continue")
    sys.exit(0)

if os.path.exists("/opt/mapr/conf/disktab"):
    log.warn("disksetup already ran, no reason to continue")
    sys.exit(0)

disks = set()
output = guard_errors(
    ["lsblk", "-o", "NAME,TYPE,MOUNTPOINT","-l", "-n"]
)
lines = output.splitlines()


for line in lines:
    columns = line.split()
    if len(columns) < 3 and columns[1] == 'disk':
        device = "/dev/%s" %(columns[0])
        check = guard_errors(
            ["lsblk", device]
        )
        if "part" not in check:
            disks.add(device)


# Fail hard if no disks could be discovered.
if not disks:
    log.error("Could not discover any disks to configure")
    sys.exit(1)

    
log.info("Configuring with disks: {disks}".format(disks=disks))
with open("/tmp/disks.tmp", "w") as fh:
    for disk in disks:
        fh.write("{disk}\n".format(disk=disk))

subprocess.check_call(["/opt/mapr/server/disksetup", "-F", "-W", "3", "/tmp/disks.tmp"])
