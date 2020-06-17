module SetupTests exposing (..)

import Expect
import Setup
import Test exposing (Test, describe, test)
import Test.Html.Event as Event
import Test.Html.Query as Query
import Test.Html.Selector exposing (class, disabled, tag)


setupSuite : Test
setupSuite =
    describe "Setup component"
        [ describe "update"
            [ test "PlayerInputAdded event adds the input value to the model" <|
                \_ ->
                    Expect.equal bobSelected (Setup.update (Setup.PlayerNameInputChanged "Bob") emptyModel)
            , test "AddPlayer adds the inserted player to the player list" <|
                \_ ->
                    Expect.equal bobAdded (Setup.update Setup.AddPlayer bobSelected)
            , test "StartGame just returns the model" <|
                \_ ->
                    Expect.equal bobAdded (Setup.update Setup.StartGame bobAdded)
            ]
        , describe "view"
            [ test "inserting a player produces expected Msg" <|
                \_ ->
                    Setup.view emptyModel
                        |> Query.fromHtml
                        |> Query.find [ tag "input", class "player-name" ]
                        |> Event.simulate (Event.input "Bob")
                        |> Event.expect (Setup.PlayerNameInputChanged "Bob")
            , test "adding a player produces expected Msg" <|
                \_ ->
                    Setup.view bobSelected
                        |> Query.fromHtml
                        |> Query.find [ tag "button", class "add-player" ]
                        |> Event.simulate Event.click
                        |> Event.expect Setup.AddPlayer
            , test "renders already added players" <|
                \_ ->
                    Setup.view { currentNameInput = Nothing, players = [ "Amanda", "Bob" ] }
                        |> Query.fromHtml
                        |> Query.findAll [ tag "li" ]
                        |> Query.count (Expect.equal 2)
            , test "start game button is disabled if no players have been added" <|
                \_ ->
                    Setup.view emptyModel
                        |> Query.fromHtml
                        |> Query.find [ tag "button", class "start-game" ]
                        |> Query.has [ disabled True ]
            , test "start game button is enabled if at least one player has been added" <|
                \_ ->
                    Setup.view bobAdded
                        |> Query.fromHtml
                        |> Query.find [ tag "button", class "start-game" ]
                        |> Query.has [ disabled False ]
            , test "start game button produces expected Msg" <|
                \_ ->
                    Setup.view bobAdded
                        |> Query.fromHtml
                        |> Query.find [ tag "button", class "start-game" ]
                        |> Event.simulate Event.click
                        |> Event.expect Setup.StartGame
            ]
        ]


emptyModel =
    Setup.init


bobSelected =
    { currentNameInput = Just "Bob", players = [] }


bobAdded =
    { currentNameInput = Nothing, players = [ "Bob" ] }
