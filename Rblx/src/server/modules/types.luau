--!strict
-- uro ;)

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

return types
