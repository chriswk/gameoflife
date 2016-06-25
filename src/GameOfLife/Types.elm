module GameOfLife.Types exposing (..)

import Time exposing (Time)

type alias Cell = (Int, Int)
type alias Cells = List Cell

type Msg = NoOp | Step | Start | Stop | Tick Time | Add | NewCell Cell

type alias Model = {
  cells : Cells
  , generation : Int
  , playing : Bool
}
