module Main exposing (main)

import Browser
import Html exposing (..)
import Html.Attributes exposing (class)
import Ui.CheckBox
import Ui.Input


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
    }


init : Flags -> ( Model, Cmd Msg )
init _ =
    ( { checkbox = False
      }
    , Cmd.none
    )


type Msg
    = Checked Bool


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Checked value ->
            ( { model | checkbox = value }
            , Cmd.none
            )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


view : Model -> Html Msg
view model =
    div [ class "p-10 max-w-md" ]
        [ viewSection
            [ Ui.Input.view [ Ui.Input.placeholder "Insert text" ]
            , Ui.Input.view [ Ui.Input.value "value" ]
            , Ui.Input.view [ Ui.Input.label "Label" ]
            , Ui.Input.view
                [ Ui.Input.value "value"
                , Ui.Input.validation (Just (Ok ()))
                ]
            , Ui.Input.view
                [ Ui.Input.value "value"
                , Ui.Input.validation (Just (Err "Error message"))
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
        ]


viewSection : List (Html msg) -> Html msg
viewSection =
    div [ class "space-y-6 max-w-md mb-10" ]
