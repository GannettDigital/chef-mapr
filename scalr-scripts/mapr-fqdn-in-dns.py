#!/usr/bin/env python
# Define access and secret key ID in scalr script parameters
import json
from ordereddict import OrderedDict
import os
import subprocess
import sys
import logging

log = logging.getLogger(__file__)
logging.basicConfig(
    level=logging.INFO
)

# This Requires that the global variables be set for AWS_DNS_KEY and AWS_DNS_SECRET
# These should be set at the scalr environment level and not visible to lower scopes.
AWS_ACCESS_KEY_ID = os.environ["AWS_DNS_KEY"]
AWS_SECRET_ACCESS_KEY = os.environ["AWS_DNS_SECRET"]
SERVER_ID = os.environ["SCALR_SERVER_ID"]
FARM_NAME = os.environ["SCALR_FARM_NAME"]
FARM_ROLE_ALIAS = os.environ["SCALR_FARM_ROLE_ALIAS"]
INTERNAL_IP = os.environ['SCALR_INTERNAL_IP']
ENVIRONMENT = os.environ["ENVIRONMENT"]
ZONE_MAP = {'sandbox': {'dns_domain': 'sandbox.gannettdigital.com', 'zone_id': 'Z1HLILP02XO4QY'},
            'development': {'dns_domain': 'development.gannettdigital.com', 'zone_id': 'Z1DV84STWJXBMX'},
            'staging': {'dns_domain': 'staging.gannettdigital.com', 'zone_id': 'Z2LOOJ2906QNK5'},
            'production': {'dns_domain': 'production.gannettdigital.com', 'zone_id': 'Z1V6I2DTQBSFIT'},
            'feature': {'dns_domain': 'feature.gannettdigital.com', 'zone_id': 'Z9V3RGODAKAQZ'},
            'training': {'dns_domain': 'training.gannettdigital.com', 'zone_id': 'ZR0CIKOY858LU'},
            'tools': {'dns_domain': 'tools.gannettdigital.com', 'zone_id': 'Z35PAWNEYS9S8M'}
}


def check_output(*popenargs, **kwargs):
    # Python 2.6 support
    if "stdout" in kwargs:
        raise ValueError("stdout argument not allowed, it will be overridden.")
    process = subprocess.Popen(stdout=subprocess.PIPE, *popenargs, **kwargs)
    output, unused_err = process.communicate()
    retcode = process.poll()
    if retcode:
        cmd = kwargs.get("args")
        if cmd is None:
            cmd = popenargs[0]
        print output
        raise subprocess.CalledProcessError(retcode, cmd)
    return output

def _domain_info():
    if ENVIRONMENT not in ZONE_MAP:
        raise Exception('{ENVIRONMENT} not configured in ZONE_MAP, update script with new configuration')

    dns_domain = ZONE_MAP[ENVIRONMENT]['dns_domain']
    zone_id = ZONE_MAP[ENVIRONMENT]['zone_id']

    domain = "{0}-{1}-scalr.{2}.".format(
        FARM_ROLE_ALIAS, FARM_NAME, dns_domain
    )
    ip = INTERNAL_IP

    changes = [
        OrderedDict([
            ("Action", "UPSERT"),
            ("ResourceRecordSet", OrderedDict([
                ("Name", domain),
                ("Type", "A"),
                ("TTL", 60),
                ("ResourceRecords", [{"Value": ip}])
            ]))
        ])
    ]

    batch_change = OrderedDict([
        ("Comment", "Create DNS entry {0}".format(FARM_NAME)),
        ("Changes", changes),
    ])

    return domain, batch_change, zone_id


def set_dns(batch_change, zone_id):
    batch_file = "/root/batch.json"
    with open(batch_file, "w") as f:
        f.write(json.dumps(batch_change, indent=4, sort_keys=False))

    print check_output(
        ["aws", "route53", "change-resource-record-sets", "--hosted-zone-id", zone_id,
         "--change-batch", "file://{0}".format(batch_file)],
        env={
            "AWS_SECRET_ACCESS_KEY": AWS_SECRET_ACCESS_KEY,
            "AWS_ACCESS_KEY_ID": AWS_ACCESS_KEY_ID
        }
    )
    
    
if __name__ == "__main__":
    domain, batch_change, zone_id = _domain_info()
    print check_output(
        ["easy_install", "awscli"]
    )

    # update the farmrole's global variables
    log.info(
        "Setting farm roles global variable DNS={domain}".format(**locals())
    )
    setDNSCommand = "szradm queryenv set-global-variable scope=farmrole param-name=DNS param-value={0}".format(domain)
    subprocess.call([setDNSCommand], shell=True)

    # execute the DNS change
    log.info(
        "Executing the Route 53 batch {batch_change} on zone {zone_id}".format(
            **locals()
        )
    )
    set_dns(batch_change, zone_id)
