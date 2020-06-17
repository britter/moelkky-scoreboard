module Summary exposing (Model, Msg(..), init, view)

-- MODEL

import Html exposing (Html, button, div, h1, text)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import ScoreTable


type alias Model =
    { winner : String, scores : ScoreTable.Model }


init : String -> ScoreTable.Model -> Model
init winner scores =
    { winner = winner, scores = scores }



-- UPDATE


type Msg
    = Rematch
    | NewGame



-- VIEW


view : Model -> Html Msg
view model =
    div [ class "summary" ]
        [ ScoreTable.view model.scores
        , h1 [ class "winner" ] [ text ("Player " ++ model.winner ++ " wins the game!") ]
        , button [ class "rematch-btn", onClick Rematch ] [ text "Rematch" ]
        , button [ class "new-game-btn", onClick NewGame ] [ text "New Game" ]
        ]
