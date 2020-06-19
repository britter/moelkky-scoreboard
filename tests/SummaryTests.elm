module SummaryTests exposing (..)

import ScoreTableTests
import Summary
import Test exposing (Test, describe, test)
import Test.Html.Event as Event
import Test.Html.Query as Query
import Test.Html.Selector exposing (class, tag, text)


summarySuite : Test
summarySuite =
    describe "Summary"
        [ test "renders score table" <|
            \_ ->
                Summary.view amandaWinning
                    |> Query.fromHtml
                    |> Query.find [ tag "table" ]
                    |> Query.has [ class "score-table" ]
        , test "renders winner" <|
            \_ ->
                Summary.view amandaWinning
                    |> Query.fromHtml
                    |> Query.find [ class "winner" ]
                    |> Query.has [ text "Amanda" ]
        , test "rematch produces expected event" <|
            \_ ->
                Summary.view amandaWinning
                    |> Query.fromHtml
                    |> Query.find [ class "rematch-btn" ]
                    |> Event.simulate Event.click
                    |> Event.expect Summary.Rematch
        , test "new game produces expected event" <|
            \_ ->
                Summary.view amandaWinning
                    |> Query.fromHtml
                    |> Query.find [ class "new-game-btn" ]
                    |> Event.simulate Event.click
                    |> Event.expect Summary.NewGame
        ]


amandaWinning =
    { winner = "Amanda", scores = ScoreTableTests.amandaWinning }
