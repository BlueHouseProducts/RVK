# RVK
# Made by BlueHouseProducts - Uro256
# https://github.com/BlueHouseProducts/RVK/
# License: https://github.com/BlueHouseProducts/RVK/blob/main/LICENSE

from time import sleep
from flask import Flask, jsonify, request
import keyboard

import re

app = Flask("RVK")

@app.route("/online")
def Online_Root():
  return "READY"

def send_mixed_input(s):
    tokens = re.split(r'(<[^>]+>)', s)

    for token in tokens:
        if token.startswith('<') and token.endswith('>'):
            key_name = token[1:-1].lower()
            try:
                keyboard.press_and_release(key_name)
            except:
                print(f"{key_name}")
        else:
            keyboard.write(token)

# Use for 1 key press at a time, v1, lua manages time
@app.post("/useKey")
def KeyUsage():
  req = request.get_json()

  if req["req"] != "PressKey":
    return '{"result": false}'
  
  key = req["key"]

  send_mixed_input(key)

  return '{"result": true}'

# Use for specific key presses in order, v2, python manages time
@app.post("/useOrdered")
def OrderedKeyUsage():
  if debug: print("Validating useOredered request...")
  req = request.get_json()
  if debug: print("Request:\n", req)

  if req["req"] != "PressKeysOrdered":
    if debug: print("Request `req` field not PressKeysOrdered, closing...")
    return '{"result": false}'
  
  if debug: print("[Validated.]")
  if debug: print("Starting key group...")

  keys = req["Keys"]
  debug = req.get("Debug", False)

  if debug: print(keys)

  current_index = 1 # Remember Lua indexes start at 1!!
  current_time = 0
  for key in keys:
    if current_index != key["Index"]:
      if debug: print("Keys are not ordered correctly")
      return jsonify(result=False, error="Keys are not ordered correctly")
    
    if debug: print("Starting key " + str(key["Index"]) + " at time " + str(current_time) + " with key " + key["Key"])
    send_mixed_input(key["Key"])
    
    wait_time = key["Time"] - current_time
    if debug: print("Waiting for " + str(wait_time) + " seconds")
    
    sleep(wait_time)
    current_time = key["Time"]
    current_index += 1

  if debug: print("Finished key group.")
  return jsonify(result=True)


app.run()
