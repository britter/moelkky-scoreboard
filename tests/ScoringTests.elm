module ScoringTests exposing (..)

import Array exposing (Array)
import Expect
import ScoreTable
import Scoring exposing (Msg(..))
import Test exposing (Test, describe, test)
import Test.Html.Event as Event
import Test.Html.Query as Query
import Test.Html.Selector exposing (class, tag)


scoringSuite : Test
scoringSuite =
    describe "Scoring"
        [ describe "update"
            [ test "updates the current score if valid" <|
                \_ ->
                    Expect.equal (Just 5) (Scoring.update (Scoring.ScoreInputChanged "5") newGame).currentScoreInput
            , test "sets current score to Nothing if invalid" <|
                \_ ->
                    Expect.equal Nothing (Scoring.update (Scoring.ScoreInputChanged "Foo") newGame).currentScoreInput
            , test "adds score for player" <|
                \_ ->
                    (Scoring.update Scoring.Score aboutToScore).scores
                        |> Array.get 0
                        |> Maybe.map getScores
                        |> Maybe.andThen List.head
                        |> Expect.equal (Just 5)
            ]
        , describe "view"
            [ test "renders score table" <|
                \_ ->
                    Scoring.view newGame
                        |> Query.fromHtml
                        |> Query.find [ tag "table" ]
                        |> Query.has [ class "score-table" ]
            , test "inserting a score produces the expected Msg" <|
                \_ ->
                    Scoring.view newGame
                        |> Query.fromHtml
                        |> Query.find [ tag "input", class "score-input" ]
                        |> Event.simulate (Event.input "5")
                        |> Event.expect (Scoring.ScoreInputChanged "5")
            , test "pressing the score button produces the expected Msg" <|
                \_ ->
                    Scoring.view newGame
                        |> Query.fromHtml
                        |> Query.find [ tag "button", class "score-btn" ]
                        |> Event.simulate Event.click
                        |> Event.expect Score
            ]
        ]


newGame =
    Scoring.init [ "Amanda", "Bob", "Deborah" ]


aboutToScore =
    { newGame | currentScoreInput = Just 5 }


getScores : ScoreTable.PlayerScores -> List Int
getScores scores =
    scores.scores
