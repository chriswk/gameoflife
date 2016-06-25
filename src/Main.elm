module Main exposing (..)

import Html.App as Html
import Html exposing (..)
import Html.Attributes exposing (..)
import GameOfLife.Types exposing (Model, Msg(..))
import GameOfLife.Patterns exposing (..)
import GameOfLife.Logic exposing (next, cellGenerator)
import GameOfLife.Renderer exposing (renderCells)
import Html.Events exposing (onClick)
import List exposing (length)
import Time exposing (every, second, millisecond)
import Random exposing (generate)




initialModel : Model
initialModel = { cells = flicker, generation = 0, playing = False }


init : (Model, Cmd Msg)
init = (initialModel, Cmd.none)


performStep : Model -> Model
performStep model =
  let
    newGeneration = next model.cells
    genSequence = model.generation + 1
  in
    { model | generation = genSequence, cells = newGeneration }

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    NoOp ->
      ( model, Cmd.none )
    Step ->
      ( performStep model, Cmd.none )
    Start ->
      ( { model | playing = True }, Cmd.none )
    Stop ->
      ( { model | playing = False }, Cmd.none )
    Tick time ->
      ( performStep model, Cmd.none )
    NewCell cell ->
      let
        newCells = cell :: model.cells
      in
        ( { model | cells = newCells }, Cmd.none )
    Add ->
      ( model, generate NewCell cellGenerator )

subscriptions : Model -> Sub Msg
subscriptions model =
    if model.playing == True then
      Time.every (200 * millisecond) Tick
    else
      Sub.none


view : Model -> Html Msg
view model =
  let
    gameState = renderCells model.cells
    generation = toString model.generation
    survivors = toString (length model.cells)
  in
   div [ class "container" ]
    [ button [ onClick Step ] [ text "Next Generation" ]
    , button [ onClick Start ] [ text "Start playing" ]
    , button [ onClick Stop ] [ text "Stop playing" ]
    , button [ onClick Add ] [ text "Add a cell" ]
    , text ("Generation: " ++ generation)
    , text ("Survivors: " ++ survivors)
    , (renderCells model.cells)
    ]

main : Program Never
main = Html.program
  { init = init
  , subscriptions = subscriptions
  , update = update
  , view = view
  }
