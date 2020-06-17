module MainTests exposing (..)

import Array
import Expect
import Main
import ScoreTable
import Scoring
import Setup
import Summary
import Test exposing (..)
import Test.Html.Query as Query
import Test.Html.Selector exposing (class)


mainSuite : Test
mainSuite =
    describe "Moelkky Scoreboard"
        [ describe "init"
            [ test "creates empty setup model" <|
                \_ ->
                    let
                        expected =
                            Main.Setup { currentNameInput = Nothing, players = [] }
                    in
                    Expect.equal Main.init expected
            ]
        , describe "update"
            [ test "starts game with given players" <|
                \_ ->
                    Main.update (Main.GotSetupMessage Setup.StartGame) setup
                        |> getPlayers
                        |> Expect.equal players
            , test "detects game end" <|
                \_ ->
                    Main.update (Main.GotScoringMessage Scoring.Score) amandaAboutToWin
                        |> getWinner
                        |> Expect.equal (Just "Amanda")
            , test "starts a rematch" <|
                \_ ->
                    Main.update (Main.GotSummaryMessage Summary.Rematch) amandaWon
                        |> getPlayers
                        |> Expect.equal players
            , test "starts a new game" <|
                \_ ->
                    Main.update (Main.GotSummaryMessage Summary.NewGame) amandaWon
                        |> getPlayers
                        |> Expect.equal []
            ]
        , describe "view"
            [ test "renders setup" <|
                \_ ->
                    Main.view setup
                        |> Query.fromHtml
                        |> Query.findAll [ class "setup" ]
                        |> Query.count (Expect.equal 1)
            , test "renders scoring" <|
                \_ ->
                    Main.view amandaAboutToWin
                        |> Query.fromHtml
                        |> Query.findAll [ class "scoring" ]
                        |> Query.count (Expect.equal 1)
            , test "renders summary" <|
                \_ ->
                    Main.view amandaWon
                        |> Query.fromHtml
                        |> Query.findAll [ class "summary" ]
                        |> Query.count (Expect.equal 1)
            ]
        ]


players =
    [ "Amanda", "Bob", "Deborah" ]


setup =
    Main.Setup { currentNameInput = Nothing, players = players }


getPlayers : Main.Model -> List String
getPlayers model =
    case model of
        Main.Scoring scoreModel ->
            scoreModel.scores
                |> ScoreTable.playerNames

        _ ->
            []


amandaAboutToWin : Main.Model
amandaAboutToWin =
    Main.Scoring
        { gameRound = 0
        , currentScoreInput = Just 2
        , scores = scores
        }


scores =
    Array.fromList
        [ { name = "Amanda", scores = [ 12, 12, 12, 12 ] }
        , { name = "Bob", scores = [ 1, 2, 3, 4 ] }
        , { name = "Deborah", scores = [ 4, 3, 2, 1 ] }
        ]


amandaWon : Main.Model
amandaWon =
    Main.Summary { winner = "Amanda", scores = scores }


getWinner : Main.Model -> Maybe String
getWinner model =
    case model of
        Main.Summary summary ->
            ScoreTable.winningPlayer summary.scores

        _ ->
            Nothing
