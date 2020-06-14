module Main exposing (..)

-- Press buttons to increment and decrement a counter.
--
-- Read how it works:
--   https://guide.elm-lang.org/architecture/buttons.html
--

import Browser
import Html exposing (Html, button, div, input, table, td, text, tr)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)



-- MAIN


main =
    Browser.sandbox { init = init, update = update, view = view }



-- MODEL


type alias Model =
    { currentPlayer : Int
    , currentScore : Maybe Int
    , scores : ScoreTable
    }


type alias ScoreTable =
    List ScoreRow


type alias ScoreRow =
    List Int


init : Model
init =
    { currentPlayer = 0, currentScore = Nothing, scores = [] }



-- UPDATE


type Msg
    = Increment
    | Decrement
    | Scored String
    | Score


update : Msg -> Model -> Model
update msg model =
    case msg of
        Increment ->
            { model | currentPlayer = model.currentPlayer + 1 }

        Decrement ->
            { model | currentPlayer = model.currentPlayer - 1 }

        Scored score ->
            { model | currentScore = String.toInt score }

        Score ->
            { model | currentPlayer = model.currentPlayer + 1, scores = newScores model.scores model.currentScore }


newScores : ScoreTable -> Maybe Int -> ScoreTable
newScores table currentScore =
    case currentScore of
        Nothing ->
            table

        Just score ->
            table ++ [ [ score ] ]



-- VIEW


renderScoreTable : Model -> Html Msg
renderScoreTable model =
    div []
        [ text ("Current player: " ++ String.fromInt model.currentPlayer)
        , table [] (List.map renderScoreRow model.scores)
        ]


renderScoreRow : ScoreRow -> Html Msg
renderScoreRow row =
    tr [] (List.map renderScore row)


renderScore : Int -> Html Msg
renderScore score =
    td [] [ text (String.fromInt score) ]


renderScoreInput : Html Msg
renderScoreInput =
    div []
        [ input [ type_ "number", value "0", onInput Scored ] []
        , button [ onClick Score ] [ text "Add" ]
        ]


view : Model -> Html Msg
view model =
    div []
        [ button [ onClick Decrement ] [ text "-" ]
        , renderScoreTable model
        , renderScoreInput
        , button [ onClick Increment ] [ text "+" ]
        ]
