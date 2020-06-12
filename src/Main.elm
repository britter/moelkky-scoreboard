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
    List ScoreRow


type alias ScoreRow =
    List Int


init : Model
init =
    [ [ 0, 1, 2, 3, 4, 5, 6 ] ]



-- UPDATE


type Msg
    = Increment
    | Decrement


update : Msg -> Model -> Model
update msg model =
    case msg of
        Increment ->
            model ++ [ [ 1 ] ]

        Decrement ->
            []



-- VIEW


renderScoreTable : Model -> Html Msg
renderScoreTable model =
    table [] (List.map renderScoreRow model)


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
