module Playground exposing (main)

import Browser
import Html exposing (..)
import Html.Attributes exposing (class)
import Ui.Button
import Ui.CheckBox
import Ui.Tab
import Ui.Textfield


main : Program Flags Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


type alias Flags =
    {}


type alias Model =
    { checkbox : Bool
    , selected : Int
    }


init : Flags -> ( Model, Cmd Msg )
init _ =
    ( { checkbox = False
      , selected = 1
      }
    , Cmd.none
    )


type Msg
    = Checked Bool
    | Selected Int


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Checked value ->
            ( { model | checkbox = value }
            , Cmd.none
            )

        Selected n ->
            ( { model | selected = n }
            , Cmd.none
            )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


view : Model -> Html Msg
view model =
    div [ class "p-10 max-w-md" ]
        [ viewSection
            [ Ui.Tab.view
                [ Ui.Tab.value model.selected ]
                [ Ui.Tab.item
                    { value = 0
                    , label = "Feed"
                    }
                , Ui.Tab.item
                    { value = 1
                    , label = "Favorites"
                    }
                , Ui.Tab.item
                    { value = 2
                    , label = "New"
                    }
                ]
            ]
            |> Html.map Selected
        , viewSection
            [ Ui.Textfield.view [ Ui.Textfield.placeholder "Insert text" ]
            , Ui.Textfield.view [ Ui.Textfield.label "Label" ]
            , Ui.Textfield.view
                [ Ui.Textfield.value "value"
                , Ui.Textfield.loading True
                ]
            , Ui.Textfield.view
                [ Ui.Textfield.value "value"
                , Ui.Textfield.validation (Just (Ok ()))
                ]
            , Ui.Textfield.view
                [ Ui.Textfield.value "value"
                , Ui.Textfield.validation (Just (Err "Error message"))
                ]
            , Ui.Textfield.view
                [ Ui.Textfield.value "disabled textfield"
                , Ui.Textfield.disabled True
                ]
            ]
        , viewSection
            [ Ui.CheckBox.view
                [ Ui.CheckBox.onCheck Checked
                , Ui.CheckBox.checked model.checkbox
                ]
            , Ui.CheckBox.view
                [ Ui.CheckBox.onCheck Checked
                , Ui.CheckBox.checked model.checkbox
                , Ui.CheckBox.label "Label"
                ]
            ]
        , groupSections
            [ viewSection
                [ Ui.Button.default [ Ui.Button.size Ui.Button.small ] "Click me"
                , Ui.Button.default [ Ui.Button.size Ui.Button.medium ] "Click me"
                , Ui.Button.default [ Ui.Button.size Ui.Button.large ] "Click me"

                --
                , Ui.Button.default [ Ui.Button.size Ui.Button.small, Ui.Button.loading True ] "Click me"
                , Ui.Button.default [ Ui.Button.size Ui.Button.medium, Ui.Button.loading True ] "Click me"
                , Ui.Button.default [ Ui.Button.size Ui.Button.large, Ui.Button.loading True ] "Click me"
                ]
            , viewSection
                [ Ui.Button.primary [ Ui.Button.size Ui.Button.small ] "Click me"
                , Ui.Button.primary [ Ui.Button.size Ui.Button.medium ] "Click me"
                , Ui.Button.primary [ Ui.Button.size Ui.Button.large ] "Click me"

                --
                , Ui.Button.primary [ Ui.Button.size Ui.Button.small, Ui.Button.loading True ] "Click me"
                , Ui.Button.primary [ Ui.Button.size Ui.Button.medium, Ui.Button.loading True ] "Click me"
                , Ui.Button.primary [ Ui.Button.size Ui.Button.large, Ui.Button.loading True ] "Click me"
                ]
            , viewSection
                [ Ui.Button.secondary [ Ui.Button.size Ui.Button.small ] "Click me"
                , Ui.Button.secondary [ Ui.Button.size Ui.Button.medium ] "Click me"
                , Ui.Button.secondary [ Ui.Button.size Ui.Button.large ] "Click me"

                --
                , Ui.Button.secondary [ Ui.Button.size Ui.Button.small, Ui.Button.loading True ] "Click me"
                , Ui.Button.secondary [ Ui.Button.size Ui.Button.medium, Ui.Button.loading True ] "Click me"
                , Ui.Button.secondary [ Ui.Button.size Ui.Button.large, Ui.Button.loading True ] "Click me"
                ]
            ]
        ]


viewSection : List (Html msg) -> Html msg
viewSection =
    div [ class "space-y-6 max-w-md mb-10 flex flex-col items-start" ]


groupSections : List (Html msg) -> Html msg
groupSections =
    div [ class "gap-x-8 w-max mb-10 flex" ]
