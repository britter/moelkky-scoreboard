module Summary exposing (Model, Msg(..), init, view)

-- MODEL

import Html exposing (Html, button, div, h1, h2, h3, text)
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
    div [ class "summary", class "section" ]
        [ div [ class "row" ] [ ScoreTable.view model.scores ]
        , div [ class "row" ] [ winnerAnnouncement model.winner ]
        , div [ class "row" ] restartControls
        ]


winnerAnnouncement : String -> Html Msg
winnerAnnouncement winner =
    div [ class "col s12" ]
        [ h3 [ class "winner" ] [ text (winner ++ " wins!") ]
        ]


restartControls : List (Html Msg)
restartControls =
    [ div [ class "col s6" ]
        [ button [ class "rematch-btn", class "waves-effect waves-light btn", onClick Rematch ] [ text "Rematch" ]
        ]
    , div [ class "col s6" ]
        [ button [ class "new-game-btn", class "waves-effect waves-light btn red", onClick NewGame ] [ text "New Game" ]
        ]
    ]
