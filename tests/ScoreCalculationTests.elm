module ScoreCalculationTests exposing (..)

import Expect
import Fuzz exposing (Fuzzer, intRange)
import ScoreCalculation
import Test exposing (Test, describe, fuzz, test)


scoreCalculationSuite : Test
scoreCalculationSuite =
    describe "Score calculation"
        [ fuzz scorableValues "positive scores are added" <|
            \score ->
                Expect.equal (ScoreCalculation.calculateScores [] score) [ score ]
        , describe "on third miss"
            [ test "subtracts 15 if score is higher than 15" <|
                \_ ->
                    let
                        scores =
                            [ 0, 0, 10, 10 ]

                        expected =
                            -15 :: scores
                    in
                    Expect.equal (ScoreCalculation.calculateScores scores 0) expected
            , test "reduces to 0 if score is below 15" <|
                \_ ->
                    let
                        scores =
                            [ 0, 0, 1 ]

                        expected =
                            -1 :: scores
                    in
                    Expect.equal (ScoreCalculation.calculateScores scores 0) expected
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
                    Expect.equal (ScoreCalculation.calculateScores [ previousTotal ] score) [ penalty, previousTotal ]
            , fuzz canWinTotal "when scoring exactly 50 the score is added" <|
                \previousTotal ->
                    let
                        score =
                            50 - previousTotal
                    in
                    Expect.equal (ScoreCalculation.calculateScores [ previousTotal ] score) [ score, previousTotal ]
            ]
        ]


scorableValues : Fuzzer Int
scorableValues =
    intRange 0 12


canWinTotal : Fuzzer Int
canWinTotal =
    intRange 39 49
