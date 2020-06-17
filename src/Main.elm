module Main exposing (..)

import Browser
import Html exposing (Html, div, h1, text)
import ScoreTable
import Scoring
import Setup
import Summary



-- MAIN


main =
    Browser.sandbox { init = init, update = update, view = view }



-- MODEL


type Model
    = Setup Setup.Model
    | Scoring Scoring.Model
    | Summary Summary.Model


init : Model
init =
    Setup Setup.init



-- UPDATE


type Msg
    = GotSetupMessage Setup.Msg
    | GotScoringMessage Scoring.Msg
    | GotSummaryMessage Summary.Msg


update : Msg -> Model -> Model
update msg model =
    case ( msg, model ) of
        ( GotSetupMessage setupMsg, Setup setup ) ->
            case setupMsg of
                Setup.StartGame ->
                    Scoring (Scoring.init setup.players)

                _ ->
                    Setup (Setup.update setupMsg setup)

        ( GotScoringMessage scoreTableMsg, Scoring scoreTable ) ->
            let
                updatedScoreTable =
                    Scoring.update scoreTableMsg scoreTable
            in
            case ScoreTable.winningPlayer updatedScoreTable.scores of
                Just player ->
                    Summary (Summary.init player updatedScoreTable.scores)

                Nothing ->
                    Scoring updatedScoreTable

        ( GotSummaryMessage summaryMsg, Summary summary ) ->
            case summaryMsg of
                Summary.Rematch ->
                    Scoring (Scoring.init (ScoreTable.playerNames summary.scores))

                Summary.NewGame ->
                    init

        ( _, _ ) ->
            model



-- VIEW


view : Model -> Html Msg
view model =
    case model of
        Setup setup ->
            wrap (Html.map GotSetupMessage (Setup.view setup))

        Scoring scoring ->
            wrap (Html.map GotScoringMessage (Scoring.view scoring))

        Summary summary ->
            wrap (Html.map GotSummaryMessage (Summary.view summary))


wrap : Html Msg -> Html Msg
wrap content =
    div []
        [ h1 [] [ text "Mölkky Scoreboard" ]
        , content
        ]
