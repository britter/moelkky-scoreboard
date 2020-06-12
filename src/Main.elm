module Main exposing (..)

-- Press buttons to increment and decrement a counter.
--
-- Read how it works:
--   https://guide.elm-lang.org/architecture/buttons.html
--

import Browser
import Html exposing (Html, button, div, table, td, text, tr)
import Html.Events exposing (onClick)



-- MAIN


main =
    Browser.sandbox { init = init, update = update, view = view }



-- MODEL


type alias Model =
    { currentPlayer : Int
    , scores : ScoreTable
    }


type alias ScoreTable =
    List ScoreRow


type alias ScoreRow =
    List Int


init : Model
init =
    { currentPlayer = 0, scores = [] }



-- UPDATE


type Msg
    = Increment
    | Decrement


update : Msg -> Model -> Model
update msg model =
    case msg of
        Increment ->
            { model | currentPlayer = model.currentPlayer + 1 }

        Decrement ->
            { model | currentPlayer = model.currentPlayer - 1 }



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


view : Model -> Html Msg
view model =
    div []
        [ button [ onClick Decrement ] [ text "-" ]
        , renderScoreTable model
        , button [ onClick Increment ] [ text "+" ]
        ]
