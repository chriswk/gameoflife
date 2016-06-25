module GameOfLife.Renderer exposing (renderCells)

import Html exposing (Html)
import Svg exposing (svg, rect)
import Svg.Attributes exposing (..)
import GameOfLife.Types exposing (Cells, Cell, Msg)

renderCells : Cells -> Html Msg
renderCells cells =
  svg [ version "1.1", viewBox "0 0 800 1800" ]
    (List.map renderCell cells)

renderCell : Cell -> Html Msg
renderCell (cx, cy) =
  rect [ fill "#000"
      , x (toString (cx * 20))
      , y (toString (cy * 20))
      , width "19"
      , height "19"] []
