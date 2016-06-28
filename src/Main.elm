module Main exposing (..)

import Html.App as Html
import Html exposing (..)
import Html.Attributes exposing (..)
import GameOfLife.Types exposing (Model, Msg(..), Pattern(..))
import GameOfLife.Patterns exposing (..)
import GameOfLife.Logic exposing (next, cellGenerator, switchToPattern, addCellFromClick)
import GameOfLife.Renderer exposing (renderCells)
import Html.Events exposing (onClick)
import List exposing (length)
import Time exposing (every, second, millisecond)
import Random exposing (generate)
import Mouse exposing (clicks, Position, moves)


updatePosition : Position -> Model -> Model
updatePosition pos model =
    { model | mousePos = pos }


initialModel : Model
initialModel =
    { cells = flicker, generation = 0, playing = False, mousePos = Position 0 0, generationDuration = 200 }


init : ( Model, Cmd Msg )
init =
    ( initialModel, Cmd.none )


performStep : Model -> Model
performStep model =
    let
        newGeneration =
            next model.cells

        genSequence =
            model.generation + 1
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
                newCells =
                    cell :: model.cells
            in
                ( { model | cells = newCells }, Cmd.none )

        Add ->
            ( model, generate NewCell cellGenerator )

        UsePattern pattern ->
            let
                newModel =
                    switchToPattern pattern model
            in
                ( newModel, Cmd.none )

        Click position ->
            let
                newModel =
                    addCellFromClick position model
            in
                ( newModel, Cmd.none )

        Move pos ->
            let
                newModel =
                    updatePosition pos model
            in
                ( newModel, Cmd.none )

        IncreaseDuration amount ->
            let
                newDuration =
                    model.generationDuration + amount
            in
                ( { model | generationDuration = newDuration }, Cmd.none )

        DecreaseDuration amount ->
            let
                newDuration =
                    model.generationDuration - amount
            in
                ( { model | generationDuration = newDuration }, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    if model.playing == True then
        Time.every (model.generationDuration * millisecond) Tick
    else
        Sub.batch
            [ Mouse.clicks Click
            , Mouse.moves Move
            ]


view : Model -> Html Msg
view model =
    let
        gameState =
            renderCells model.cells

        generation =
            toString model.generation

        survivors =
            toString (length model.cells)

        pos =
            toString model.mousePos

        duration =
            (toString model.generationDuration) ++ " ms"
    in
        div [ class "container" ]
            [ button [ onClick Step ] [ text "Next Generation" ]
            , button [ onClick Start ] [ text "Start playing" ]
            , button [ onClick Stop ] [ text "Stop playing" ]
            , button [ onClick Add ] [ text "Add a cell" ]
            , button [ onClick (UsePattern Gosper) ] [ text "Switch to GosperGun" ]
            , button [ onClick (UsePattern Flicker) ] [ text "Switch to a flicker pattern" ]
            , button [ onClick (UsePattern Infinite) ] [ text "Switch to an infinite pattern" ]
            , button [ onClick (IncreaseDuration 50) ] [ text "Increase generation duration with 50 ms" ]
            , button [ onClick (DecreaseDuration 30) ] [ text "Decrease generation duration with 30 ms" ]
            , div [] [ text ("Generation duration: " ++ duration) ]
            , div [] [ text ("Generation: " ++ generation) ]
            , div [] [ text ("Survivors: " ++ survivors) ]
            , div [] [ text ("Position: " ++ pos) ]
            , (renderCells model.cells)
            ]


main : Program Never
main =
    Html.program
        { init = init
        , subscriptions = subscriptions
        , update = update
        , view = view
        }
