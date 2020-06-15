module Main exposing (..)

-- Press buttons to increment and decrement a counter.
--
-- Read how it works:
--   https://guide.elm-lang.org/architecture/buttons.html
--

import Array exposing (Array)
import Browser
import Html exposing (Html, button, div, input, li, table, td, text, tr, ul)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)



-- MAIN


main =
    Browser.sandbox { init = init, update = update, view = view }



-- MODEL


type Model
    = Setup SetupModel
    | GameState GameStateModel


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
            GameState { state | gameRound = state.gameRound + 1, scores = newScores state.scores (currentPlayer state) state.currentScoreInput }

        ( _, _ ) ->
            model


initScores : List String -> Scores
initScores players =
    Array.fromList (List.map (\player -> { name = player, scores = [] }) players)


currentPlayer : GameStateModel -> Int
currentPlayer model =
    modBy (Array.length model.scores) model.gameRound


newScores : Scores -> Int -> Maybe Int -> Scores
newScores scores player currentScore =
    case currentScore of
        Nothing ->
            scores

        Just score ->
            updateScores scores player score


updateScores : Scores -> Int -> Int -> Scores
updateScores scores player currentScore =
    let
        currentPlayerScore =
            Array.get player scores
    in
    case currentPlayerScore of
        Nothing ->
            scores

        Just someScores ->
            Array.set player { someScores | scores = someScores.scores ++ [ currentScore ] } scores



-- VIEW


renderScoreTable : GameStateModel -> Html Msg
renderScoreTable model =
    div []
        [ text ("Current game round: " ++ String.fromInt model.gameRound)
        , table [] (List.map renderPlayerScores (Array.toList model.scores))
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
                , button [ onClick StartGame ] [ text "Start Game" ]
                ]

        GameState state ->
            div []
                [ renderScoreTable state
                , renderScoreInput
                ]
