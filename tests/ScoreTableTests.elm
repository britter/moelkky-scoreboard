module ScoreTableTests exposing (..)

import Array
import Expect
import ScoreTable
import Test exposing (Test, describe, test)
import Test.Html.Query as Query
import Test.Html.Selector exposing (class, tag, text)


scoreTableSuite : Test
scoreTableSuite =
    describe "ScoreTable"
        [ describe "update"
            [ test "should add scores for player by index" <|
                \_ ->
                    let
                        index =
                            0

                        score =
                            10
                    in
                    Expect.equal amandaScored (ScoreTable.updateScores newGame index score)
            , test "should leave model unchanged in case of unknown player scoring" <|
                \_ ->
                    Expect.equal newGame (ScoreTable.updateScores newGame 9 12)
            ]
        , test "should detect winning player" <|
            \_ ->
                Expect.equal (Just "Amanda") (ScoreTable.winningPlayer amandaWinning)
        , test "extracts player names" <|
            \_ ->
                Expect.equal [ "Amanda", "Bob", "Deborah" ] (ScoreTable.playerNames newGame)
        , describe "view"
            [ test "renders a row per player" <|
                \_ ->
                    ScoreTable.view amandaWinning
                        |> Query.fromHtml
                        |> Query.find [ class "player-names" ]
                        |> Query.children [ class "player-name" ]
                        |> Query.count (Expect.equal 3)
            , test "renders the player name" <|
                \_ ->
                    ScoreTable.view amandaWinning
                        |> Query.fromHtml
                        |> Query.findAll [ class "player-name" ]
                        |> Query.index 0
                        |> Query.has [ text "Amanda" ]
            , test "renders the score sum per player" <|
                \_ ->
                    ScoreTable.view amandaWinning
                        |> Query.fromHtml
                        |> Query.findAll [ class "score-total" ]
                        |> Query.index 0
                        |> Query.has [ text "50" ]
            , test "renders individual scores" <|
                \_ ->
                    ScoreTable.view amandaScored
                        |> Query.fromHtml
                        |> Query.findAll [ class "score" ]
                        |> Query.index 0
                        |> Query.has [ text "10" ]
            ]
        ]


newGame =
    Array.fromList
        [ { name = "Amanda", scores = [] }
        , { name = "Bob", scores = [] }
        , { name = "Deborah", scores = [] }
        ]


amandaScored =
    Array.fromList
        [ { name = "Amanda", scores = [ 10 ] }
        , { name = "Bob", scores = [] }
        , { name = "Deborah", scores = [] }
        ]


amandaWinning =
    Array.fromList
        [ { name = "Amanda", scores = [ 12, 12, 12, 12, 2 ] }
        , { name = "Bob", scores = [ 9, 12, 1, 4 ] }
        , { name = "Bob", scores = [ 5, 6, 10, 9 ] }
        ]
