module Main exposing (..)

-- Press buttons to increment and decrement a counter.
--
-- Read how it works:
--   https://guide.elm-lang.org/architecture/buttons.html
--

import Browser
import Html exposing (Html, button, div, li, text, ul)
import Html.Events exposing (onClick)



-- MAIN


main =
    Browser.sandbox { init = init, update = update, view = view }



-- MODEL


type alias Model =
    List Int


init : Model
init =
    [ 0 ]



-- UPDATE


type Msg
    = Increment
    | Decrement


update : Msg -> Model -> Model
update msg model =
    case msg of
        Increment ->
            model ++ [ 1 ]

        Decrement ->
            []



-- VIEW


renderList : Model -> Html Msg
renderList model =
    ul [] (List.map renderListItem model)


renderListItem : Int -> Html Msg
renderListItem x =
    li [] [ text (String.fromInt x) ]


view : Model -> Html Msg
view model =
    div []
        [ button [ onClick Decrement ] [ text "-" ]
        , renderList model
        , button [ onClick Increment ] [ text "+" ]
        ]
