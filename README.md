
# Roblox Virtual Keyboard

A fun project that lets you type using a Roblox model of a keyboard.


### Installation
In Roblox Studio, you need to enable HTTP Requests option in Game Settings > Security.
In python, run `pip install keyboard flask` to install the dependancies of this project.

## Features

- All needed keys!
- Caps lock!
- Shift switch!
- Key labels (that change with shift)!
- Editable keyboard that you don't need to pay for!
What else do you need???

## From source
To build the roblox file from source, go to the (Rblx)[https://github.com/BlueHouseProducts/RVK/tree/main/Rblx] folder, and follow the readme instructions there.

## How it works
In Roblox, we send http requests to the python backend after you stop recording, that contains the key. The python file running `Flask`, a popular web framework, that detects the request and using `keyboard` we press the key.
