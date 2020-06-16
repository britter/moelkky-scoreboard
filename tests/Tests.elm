module Tests exposing (..)

import Expect
import Fuzz exposing (Fuzzer, intRange)
import Main
import Test exposing (..)



-- Check out https://package.elm-lang.org/packages/elm-explorations/test/latest to learn more about testing in Elm!


all : Test
all =
    describe "Moelkky Scoreboard"
        [ describe "init"
            [ test "Init creates empty setup model" <|
                \_ ->
                    let
                        expected =
                            Main.Setup { currentNameInput = Nothing, players = [] }
                    in
                    Expect.equal Main.init expected
            ]
        , describe "calculate score"
            [ fuzz scorableValues "positive scores are added" <|
                \score ->
                    Expect.equal (Main.calculateScores [] score) [ score ]
            , describe "on third miss"
                [ test "subtracts 15 if score is higher than 15" <|
                    \_ ->
                        let
                            scores =
                                [ 0, 0, 10, 10 ]

                            expected =
                                -15 :: scores
                        in
                        Expect.equal (Main.calculateScores scores 0) expected
                , test "reduces to 0 if score is below 15" <|
                    \_ ->
                        let
                            scores =
                                [ 0, 0, 1 ]

                            expected =
                                -1 :: scores
                        in
                        Expect.equal (Main.calculateScores scores 0) expected
                ]
            , describe "on approaching 50 points"
                [ fuzz canWinTotal "when scoring more than 50 points are reduced to 25" <|
                    \previousTotal ->
                        let
                            score =
                                51 - previousTotal

                            penalty =
                                -(previousTotal - 25)
                        in
                        Expect.equal (Main.calculateScores [ previousTotal ] score) [ penalty, previousTotal ]
                , fuzz canWinTotal "when scoring exactly 50 the score is added" <|
                    \previousTotal ->
                        let
                            score =
                                50 - previousTotal
                        in
                        Expect.equal (Main.calculateScores [ previousTotal ] score) [ score, previousTotal ]
                ]
            ]
        ]


scorableValues : Fuzzer Int
scorableValues =
    intRange 0 12


canWinTotal : Fuzzer Int
canWinTotal =
    intRange 39 49
