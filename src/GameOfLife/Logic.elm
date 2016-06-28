module GameOfLife.Logic exposing (next, cellGenerator, switchToPattern, addCellFromClick)

import List exposing (filter, length, member, head, tail)
import GameOfLife.Types exposing (Cell, Cells, Model, Pattern(..))
import GameOfLife.Patterns exposing (flicker, gosperGun, infinite)
import Random exposing (int, pair, Generator)
import Mouse exposing (Position)


addCellFromClick : Position -> Model -> Model
addCellFromClick position model =
    let
        cx =
            position.x // 63

        cy =
            (position.y - 90) // 63

        newCell =
            ( cx, cy )

        newCells =
            newCell :: model.cells
    in
        { model | cells = newCells }


switchToPattern : Pattern -> Model -> Model
switchToPattern pattern model =
    let
        newPattern =
            case pattern of
                Flicker ->
                    flicker

                Gosper ->
                    gosperGun

                Infinite ->
                    infinite
    in
        { model | cells = newPattern, playing = False, generation = 0 }


cellGenerator : Generator ( Int, Int )
cellGenerator =
    pair (int 0 30) (int 0 30)


next : Cells -> Cells
next livingCells =
    (survivors livingCells) ++ (unique (newBorns livingCells))


unique : Cells -> Cells
unique cells =
    case cells of
        h :: t ->
            if member h t then
                unique t
            else
                h :: unique t

        [] ->
            []


newBorns : Cells -> Cells
newBorns livingCells =
    List.concatMap (newBornsFor livingCells) livingCells


newBornsFor : Cells -> Cell -> Cells
newBornsFor livingCells cell =
    filter (isBorn livingCells) (deadNeighbours cell livingCells)


isBorn : Cells -> Cell -> Bool
isBorn livingCells cell =
    length (liveNeighbours cell livingCells) == 3


deadNeighbours : Cell -> Cells -> Cells
deadNeighbours cell livingCells =
    filter (isDead livingCells) (neighbours cell)


isAlive : Cells -> Cell -> Bool
isAlive livingCells cell =
    member cell livingCells


isDead : Cells -> Cell -> Bool
isDead livingCells cell =
    not (isAlive livingCells cell)


survivors : Cells -> Cells
survivors livingCells =
    filter (survive livingCells) livingCells


survive : Cells -> Cell -> Bool
survive livingCells cell =
    let
        liveNeighboursCount =
            length (liveNeighbours cell livingCells)

        ( cx, cy ) =
            cell

        isInsideX =
            cx < 1800 && cx > -1

        isInsideY =
            cy < 1200 && cy > -1

        notTouchingFence =
            isInsideX && isInsideY

        conditionsRight =
            liveNeighboursCount == 2 || liveNeighboursCount == 3
    in
        notTouchingFence && conditionsRight


liveNeighbours : Cell -> Cells -> Cells
liveNeighbours cell livingCells =
    filter (isAlive livingCells) (neighbours cell)


neighbours : Cell -> Cells
neighbours ( fst, snd ) =
    [ ( (fst - 1), (snd - 1) )
    , ( fst, (snd - 1) )
    , ( (fst + 1), (snd - 1) )
    , ( (fst - 1), snd )
    , ( (fst + 1), snd )
    , ( (fst - 1), (snd + 1) )
    , ( fst, (snd + 1) )
    , ( (fst + 1), (snd + 1) )
    ]
