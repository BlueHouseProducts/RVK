
# Roblox Virtual Keyboard

A fun project that lets you type using a Roblox model of a keyboard.


## Features

- All needed keys!
- Caps lock!
- Shift switch!
- Key labels (that change with shift)!
- Editable keyboard that you don't need to pay for!
What else do you need???


## Installation
The python script and roblox place file are available in the release section, or you can build the roblox file using [Rojo](https://rojo.space/) yourself!

#### Setup
In Roblox Studio, you need to enable HTTP Requests in Game Settings > Security.

In python, run `pip install keyboard flask` to install the dependancies of this project.
## How it works
In Roblox, we send http requests to the python backend after you stop recording, that contains the key. The python file running `Flask`, a popular web framework, that detects the request and using `keyboard` we press the key.
