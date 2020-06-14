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
    , currentScoreInput : Maybe Int
    , scores : Scores
    }


type alias Scores =
    List PlayerScores


type alias PlayerScores =
    { name : String
    , scores : List Int
    }


init : Model
init =
    { currentPlayer = 0
    , currentScoreInput = Nothing
    , scores =
        [ { name = "Adam", scores = [ 2, 5, 9 ] }
        , { name = "Bianca", scores = [ 11, 1, 0 ] }
        , { name = "Charles", scores = [ 5, 4, 8 ] }
        , { name = "Deborah", scores = [ 9, 0, 3 ] }
        ]
    }



-- UPDATE


type Msg
    = Increment
    | Decrement
    | ScoreInputChanged String
    | Score


update : Msg -> Model -> Model
update msg model =
    case msg of
        Increment ->
            { model | currentPlayer = model.currentPlayer + 1 }

        Decrement ->
            { model | currentPlayer = model.currentPlayer - 1 }

        ScoreInputChanged newScoreInput ->
            { model | currentScoreInput = String.toInt newScoreInput }

        Score ->
            { model | currentPlayer = model.currentPlayer + 1, scores = newScores model.scores model.currentScoreInput }


newScores : Scores -> Maybe Int -> Scores
newScores table currentScore =
    case currentScore of
        Nothing ->
            table

        Just score ->
            table



-- VIEW


renderScoreTable : Model -> Html Msg
renderScoreTable model =
    div []
        [ text ("Current player: " ++ String.fromInt model.currentPlayer)
        , table [] (List.map renderPlayerScores model.scores)
        ]


renderPlayerScores : PlayerScores -> Html Msg
renderPlayerScores playerScores =
    tr [] (td [] [ text playerScores.name ] :: renderScores playerScores.scores)


renderScores : List Int -> List (Html Msg)
renderScores scores =
    List.map (\x -> td [] [ text (String.fromInt x) ]) scores


renderScoreInput : Html Msg
renderScoreInput =
    div []
        [ input [ type_ "number", value "0", onInput ScoreInputChanged ] []
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
