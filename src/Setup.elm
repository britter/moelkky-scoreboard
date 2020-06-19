module Setup exposing (Model, Msg(..), init, update, view)

import Html exposing (Html, button, div, input, li, text, ul)
import Html.Attributes exposing (class, disabled, placeholder)
import Html.Events exposing (onClick, onInput)



-- MODEL


type alias Model =
    { currentNameInput : Maybe String
    , players : List String
    }


init : Model
init =
    { currentNameInput = Nothing, players = [] }



-- UPDATE


type Msg
    = PlayerNameInputChanged String
    | AddPlayer
    | StartGame


update : Msg -> Model -> Model
update msg model =
    case msg of
        PlayerNameInputChanged newPlayerName ->
            { model | currentNameInput = Just newPlayerName }

        AddPlayer ->
            case model.currentNameInput of
                Just name ->
                    { model | currentNameInput = Nothing, players = model.players ++ [ name ] }

                Nothing ->
                    model

        StartGame ->
            model



-- VIEW


view : Model -> Html Msg
view model =
    div [ class "setup" ]
        [ playerList model.players
        , addPlayerInputs
        , startGameButton model
        ]


playerList : List String -> Html Msg
playerList players =
    ul [ class "player-list" ] (List.map (\player -> li [] [ text player ]) players)


addPlayerInputs : Html Msg
addPlayerInputs =
    div []
        [ input [ class "player-name", onInput PlayerNameInputChanged, placeholder "insert player name" ] []
        , button [ class "add-player", onClick AddPlayer ] [ text "Add" ]
        ]


startGameButton : Model -> Html Msg
startGameButton model =
    button [ class "start-game", disabled (List.isEmpty model.players), onClick StartGame ] [ text "Start Game" ]
