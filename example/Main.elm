module Main exposing (main)

import Browser
import Html exposing (..)
import Html.Attributes exposing (class)
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
    {}


init : Flags -> ( Model, Cmd Msg )
init _ =
    ( {}
    , Cmd.none
    )


type Msg
    = Noop


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Noop ->
            ( model
            , Cmd.none
            )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


view : Model -> Html Msg
view _ =
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
        ]


viewSection : List (Html msg) -> Html msg
viewSection =
    div [ class "space-y-6 max-w-md" ]
