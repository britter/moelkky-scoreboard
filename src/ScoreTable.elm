module ScoreTable exposing (Model, PlayerScores, init, playerNames, updateScores, view, winningPlayer)

import Array exposing (Array)
import Html exposing (Html, table, td, text, tr)
import Html.Attributes exposing (class)
import ScoreCalculation



-- MODEL


type alias Model =
    Array PlayerScores


type alias PlayerScores =
    { name : String
    , scores : List Int
    }


init : List String -> Model
init players =
    Array.fromList (List.map (\player -> { name = player, scores = [] }) players)



-- UPDATE


updateScores : Model -> Int -> Int -> Model
updateScores scores player newScore =
    let
        currentPlayerScores =
            Array.get player scores
    in
    case currentPlayerScores of
        Just someScores ->
            Array.set player { someScores | scores = ScoreCalculation.calculateScores someScores.scores newScore } scores

        Nothing ->
            scores


winningPlayer : Model -> Maybe String
winningPlayer scores =
    scores
        |> Array.filter (\x -> List.sum x.scores == 50)
        |> playerNames
        |> List.head


playerNames : Model -> List String
playerNames scores =
    scores
        |> Array.toList
        |> List.map (\x -> x.name)



-- VIEW


view : Model -> Html msg
view scores =
    table [ class "score-table" ] (List.map playerRow (Array.toList scores))


playerRow : PlayerScores -> Html msg
playerRow playerScores =
    tr [ class "player-scores" ]
        (td [ class "player-name" ] [ text playerScores.name ] :: td [ class "score-sum" ] [ text (String.fromInt (List.sum playerScores.scores)) ] :: scoreCells (List.reverse playerScores.scores))


scoreCells : List Int -> List (Html msg)
scoreCells scores =
    List.map scoreCell scores


scoreCell : Int -> Html msg
scoreCell score =
    td [ class "score" ] [ text (String.fromInt score) ]
