module Setup exposing (Model, Msg(..), init, update, view)

import Html exposing (Html, button, div, input, li, text, ul)
import Html.Attributes exposing (class, disabled, placeholder, value)
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
    div [ class "setup", class "section" ]
        [ div [ class "row" ] [ playerList model.players ]
        , div [ class "row" ] (addPlayerInputs model)
        , div [ class "row" ] [ startGameButton model ]
        ]


playerList : List String -> Html Msg
playerList players =
    div [ class "col s12" ] [ ul [ class "player-list" ] (List.map (\player -> li [] [ text player ]) players) ]


addPlayerInputs : Model -> List (Html Msg)
addPlayerInputs model =
    [ div [ class "input-field col s12 m6" ]
        [ input [ class "player-name", onInput PlayerNameInputChanged, placeholder "insert player name", value (getPlayerNameInput model) ] []
        ]
    , div
        [ class "col s12 m6" ]
        [ button [ class "add-player", class "waves-effect waves-light btn", onClick AddPlayer ] [ text "Add" ] ]
    ]


getPlayerNameInput : Model -> String
getPlayerNameInput model =
    case model.currentNameInput of
        Just input ->
            input

        Nothing ->
            ""


startGameButton : Model -> Html Msg
startGameButton model =
    div [ class "col s12" ]
        [ button [ class "start-game", class "waves-effect waves-light btn red", disabled (List.isEmpty model.players), onClick StartGame ] [ text "Start Game" ]
        ]
