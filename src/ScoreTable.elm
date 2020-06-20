module ScoreTable exposing (Model, PlayerScores, init, playerNames, updateScores, view, winningPlayer)

import Array exposing (Array)
import Html exposing (Html, table, tbody, td, text, tfoot, th, thead, tr)
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
        |> List.map (\player -> player.name)


playerScores : Model -> List Int
playerScores scores =
    scores
        |> Array.toList
        |> List.map (\player -> player.scores)
        |> List.map List.sum


getScores : PlayerScores -> List Int
getScores model =
    model.scores


getHeads : List (List Int) -> List (Maybe Int)
getHeads model =
    List.map List.head model


getTails : List (List Int) -> List (List Int)
getTails scores =
    List.map emptyTails scores


emptyTails : List Int -> List Int
emptyTails list =
    case list of
        _ :: xs ->
            xs

        _ ->
            []



-- VIEW


view : Model -> Html msg
view model =
    table [ class "score-table" ]
        [ thead [] [ playerNamesRow model ]
        , tbody [] (scoreTable model)
        , tfoot [] [ playerScoreTotals model ]
        ]


playerNamesRow : Model -> Html msg
playerNamesRow model =
    tr [ class "player-names" ]
        (List.map (\name -> th [ class "player-name" ] [ text name ]) (playerNames model))


scoreTable : Model -> List (Html msg)
scoreTable model =
    let
        scores =
            model
                |> Array.toList
                |> List.map getScores
    in
    scoreTableRows scores


scoreTableRows : List (List Int) -> List (Html msg)
scoreTableRows model =
    let
        heads =
            getHeads model
    in
    if List.member Nothing heads then
        tr [ class "player-scores" ] (scoreCells heads) :: []

    else
        tr [ class "player-scores" ] (scoreCells heads) :: scoreTableRows (getTails model)


scoreCells : List (Maybe Int) -> List (Html msg)
scoreCells scores =
    List.map scoreCell scores


scoreCell : Maybe Int -> Html msg
scoreCell score =
    case score of
        Just num ->
            td [ class "score" ] [ text (String.fromInt num) ]

        Nothing ->
            td [ class "score" ] []


playerScoreTotals : Model -> Html msg
playerScoreTotals model =
    tr []
        (List.map (\total -> td [ class "score-total" ] [ text total ]) (List.map String.fromInt (playerScores model)))
