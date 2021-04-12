#!/usr/bin/env python3

# My computer used to overheat a lot.

import json
import subprocess

output = subprocess.check_output(["sensors", "-j"])
data = json.loads(output)

bad = []
fan = None
for chip in data:
    comps = data[chip]
    adapter = comps["Adapter"]
    for comp in comps:
        datum = comps[comp]
        if comp.startswith("temp"):
            temp = next(datum[k] for k in datum)
            if temp > 60.0:
                bad.append(f"{chip} ({adapter}) {comp}: {temp}")
        elif comp.startswith("fan"):
            fan = next((datum[k] for k in datum), None)

if len(bad) > 0:
    message = "\nn".join(bad)
    if fan is not None:
        message = f"{message}\nFan: {fan}"
    subprocess.check_output(["notify-send", "Computer overheated", message])
