--!strict
-- uro ;)

-- Types
-- Contains types used throughout the project.

local types = {}

export type KeyList = {
  BasePart
}

export type Recording = {
  Record
}

export type Record = {
  ["Key"]: string,
  ["Time"]: number
}

type UseTypeSpeedDivision = {
  ["Enabled"]: true,
  ["DivisionSpeed"]: number
} | { ["Enabled"]: false }


export type Editable = {
  ["UseTypeSpeedDivision"]: UseTypeSpeedDivision,
  ["Debug"]: boolean?,
  ["Delay"]: number?,

  ["HTTPSendType"]: "SendPerKey" | "SendOrdered"  -- SendOrdered sends all keys to python which uses time to order them, SendPerKey sends each key to python at time to press
}                                                 -- SendOrdered is more reliable, but SendPerKey is faster. We recommend SendOrdered.

export type HTTPSendData = {
  ["req"]: "PressKey",
  ["key"]: string
}

export type ValidHTTPReceiveData = {
  ["result"]: boolean
} -- unused type, stringified on receive

return types
