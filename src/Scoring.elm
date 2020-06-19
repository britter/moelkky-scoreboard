module Scoring exposing (Model, Msg(..), init, update, view)

import Array exposing (Array)
import Html exposing (Html, button, div, input, text)
import Html.Attributes exposing (class, type_, value)
import Html.Events exposing (onClick, onInput)
import ScoreTable



-- MODEL


type alias Model =
    { gameRound : Int
    , currentScoreInput : Maybe Int
    , scores : ScoreTable.Model
    }


init : List String -> Model
init players =
    { gameRound = 0, currentScoreInput = Nothing, scores = ScoreTable.init players }



-- UPDATE


type Msg
    = ScoreInputChanged String
    | Score


update : Msg -> Model -> Model
update msg model =
    case msg of
        ScoreInputChanged newScoreInput ->
            { model | currentScoreInput = String.toInt newScoreInput }

        Score ->
            case model.currentScoreInput of
                Just score ->
                    let
                        updatedScores =
                            ScoreTable.updateScores model.scores (currentPlayer model) score
                    in
                    { model | gameRound = model.gameRound + 1, scores = updatedScores }

                Nothing ->
                    model


currentPlayer : Model -> Int
currentPlayer model =
    modBy (Array.length model.scores) model.gameRound



-- VIEW


view : Model -> Html Msg
view model =
    div [ class "scoring" ]
        [ ScoreTable.view model.scores
        , scoreInput
        ]


scoreInput : Html Msg
scoreInput =
    div []
        [ input [ class "score-input", type_ "number", value "0", Html.Attributes.min "0", Html.Attributes.max "12", onInput ScoreInputChanged ] []
        , button [ class "score-btn", onClick Score ] [ text "Add" ]
        ]
