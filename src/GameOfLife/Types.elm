module GameOfLife.Types exposing (..)

import Time exposing (Time)
import Mouse exposing (Position)


type alias Cell =
    ( Int, Int )


type alias Cells =
    List Cell


type Msg
    = NoOp
    | Step
    | Start
    | Stop
    | Tick Time
    | Add
    | NewCell Cell
    | UsePattern Pattern
    | Click Position
    | Move Position


type Pattern
    = Flicker
    | Gosper


type alias Model =
    { cells : Cells
    , generation : Int
    , playing : Bool
    , mousePos : Position
    }
