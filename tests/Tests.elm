module Tests exposing (..)

import Expect
import Main
import Test exposing (..)



-- Check out https://package.elm-lang.org/packages/elm-explorations/test/latest to learn more about testing in Elm!


all : Test
all =
    describe "Moelkky Scoreboard"
        [ describe "init"
            [ test "Init creates empty setup model" <|
                \_ ->
                    Expect.equal Main.init (Main.Setup { currentNameInput = Nothing, players = [] })
            ]
        ]
