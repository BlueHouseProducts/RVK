from flask import Flask, request
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

@app.post("/useKey")
def KeyUsage():
  req = request.get_json()

  if req["req"] != "PressKey":
    return '{"result": false}'
  
  key = req["key"]

  send_mixed_input(key)

  return '{"result": true}'

app.run()
