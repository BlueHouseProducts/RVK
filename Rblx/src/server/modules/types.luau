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

type UseTypeSpeedDivision = {
  ["Enabled"]: true,
  ["DivisionSpeed"]: number
} | { ["Enabled"]: false }

export type Editable = {
  ["UseTypeSpeedDivision"]: UseTypeSpeedDivision
}

return types
