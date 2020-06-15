module Main exposing (..)

import Array exposing (Array)
import Browser
import Html exposing (Html, button, div, h1, input, li, table, td, text, tr, ul)
import Html.Attributes
import Html.Events exposing (onClick, onInput)



-- MAIN


main =
    Browser.sandbox { init = init, update = update, view = view }



-- MODEL


type Model
    = Setup SetupModel
    | GameState GameStateModel
    | PlayerWins String Scores


type alias SetupModel =
    { currentNameInput : Maybe String
    , players : List String
    }


type alias GameStateModel =
    { gameRound : Int
    , currentScoreInput : Maybe Int
    , scores : Scores
    }


type alias Scores =
    Array PlayerScores


type alias PlayerScores =
    { name : String
    , scores : List Int
    }


init : Model
init =
    Setup { currentNameInput = Nothing, players = [] }



-- UPDATE


type Msg
    = PlayerNameInputChanged String
    | AddPlayer
    | StartGame
    | ScoreInputChanged String
    | Score
    | Rematch
    | NewGame


update : Msg -> Model -> Model
update msg model =
    case ( msg, model ) of
        ( PlayerNameInputChanged newPlayerName, Setup setup ) ->
            Setup { setup | currentNameInput = Just newPlayerName }

        ( AddPlayer, Setup setup ) ->
            case setup.currentNameInput of
                Just name ->
                    Setup { setup | currentNameInput = Nothing, players = setup.players ++ [ name ] }

                Nothing ->
                    model

        ( StartGame, Setup setup ) ->
            GameState { gameRound = 0, currentScoreInput = Nothing, scores = initScores setup.players }

        ( ScoreInputChanged newScoreInput, GameState state ) ->
            GameState { state | currentScoreInput = String.toInt newScoreInput }

        ( Score, GameState state ) ->
            let
                updatedScores =
                    updateScores state.scores (currentPlayer state) state.currentScoreInput
            in
            case winningPlayer updatedScores of
                Just player ->
                    PlayerWins player updatedScores

                Nothing ->
                    GameState { state | gameRound = state.gameRound + 1, scores = updatedScores }

        ( Rematch, PlayerWins _ scores ) ->
            GameState { gameRound = 0, currentScoreInput = Nothing, scores = initScores (playerNames scores) }

        ( NewGame, _ ) ->
            init

        ( _, _ ) ->
            model


initScores : List String -> Scores
initScores players =
    Array.fromList (List.map (\player -> { name = player, scores = [] }) players)


currentPlayer : GameStateModel -> Int
currentPlayer model =
    modBy (Array.length model.scores) model.gameRound


updateScores : Scores -> Int -> Maybe Int -> Scores
updateScores scores player currentScoreInput =
    let
        currentPlayerScores =
            Array.get player scores
    in
    case ( currentPlayerScores, currentScoreInput ) of
        ( Just someScores, Just input ) ->
            Array.set player { someScores | scores = calculateScores someScores.scores input } scores

        ( _, _ ) ->
            scores


calculateScores : List Int -> Int -> List Int
calculateScores scores newScore =
    let
        total =
            List.sum scores

        newTotal =
            total + newScore
    in
    case ( scores, newScore ) of
        ( 0 :: 0 :: _, 0 ) ->
            if total < 15 then
                -total :: scores

            else
                -15 :: scores

        ( _, _ ) ->
            if newTotal > 50 then
                -(total - 25) :: scores

            else
                newScore :: scores


winningPlayer : Scores -> Maybe String
winningPlayer scores =
    scores
        |> Array.filter (\x -> List.sum x.scores == 50)
        |> playerNames
        |> List.head


playerNames : Scores -> List String
playerNames scores =
    scores
        |> Array.toList
        |> List.map (\x -> x.name)



-- VIEW


renderScoreTable : Scores -> Html Msg
renderScoreTable scores =
    table [] (List.map renderPlayerScores (Array.toList scores))


renderPlayerScores : PlayerScores -> Html Msg
renderPlayerScores playerScores =
    tr [] (td [] [ text playerScores.name ] :: td [] [ text (String.fromInt (List.sum playerScores.scores)) ] :: renderScores (List.reverse playerScores.scores))


renderScores : List Int -> List (Html Msg)
renderScores scores =
    List.map (\x -> td [] [ text (String.fromInt x) ]) scores


renderScoreInput : Html Msg
renderScoreInput =
    div []
        [ input [ Html.Attributes.type_ "number", Html.Attributes.value "0", Html.Attributes.min "0", Html.Attributes.max "12", onInput ScoreInputChanged ] []
        , button [ onClick Score ] [ text "Add" ]
        ]


renderPlayers : List String -> Html Msg
renderPlayers players =
    ul [] (List.map (\player -> li [] [ text player ]) players)


renderAddPlayerInputs : Html Msg
renderAddPlayerInputs =
    div []
        [ input [ onInput PlayerNameInputChanged ] []
        , button [ onClick AddPlayer ] [ text "Add" ]
        ]


view : Model -> Html Msg
view model =
    case model of
        Setup setup ->
            div []
                [ renderPlayers setup.players
                , renderAddPlayerInputs
                , button [ Html.Attributes.disabled (List.isEmpty setup.players), onClick StartGame ] [ text "Start Game" ]
                ]

        GameState state ->
            div []
                [ renderScoreTable state.scores
                , renderScoreInput
                ]

        PlayerWins name scores ->
            div []
                [ renderScoreTable scores
                , h1 [] [ text ("Player " ++ name ++ " wins the game!") ]
                , button [ onClick Rematch ] [ text "Rematch" ]
                , button [ onClick NewGame ] [ text "New Game" ]
                ]
