module FormExample exposing (main)

import Browser
import Html exposing (..)
import Html.Attributes exposing (class)
import Ui.Button
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


type alias Msg =
    Never


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        _ ->
            ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


viewCard : List (Html msg) -> Html msg
viewCard =
    div [ class "max-w-md px-4 py-4 w-full rounded bg-white border shadow-sm" ]


view : Model -> Html Msg
view _ =
    div [ class "flex items-center justify-center h-screen" ]
        [ viewCard
            [ h3 [ class "font-bold text-xl leading-none" ] [ text "Log in" ]
            , div [ class "h-4" ] []
            , Ui.Input.view
                [ Ui.Input.label "Email"
                , Ui.Input.placeholder "johndoe@example.com"
                ]
            , div [ class "h-4" ] []
            , Ui.Input.view
                [ Ui.Input.label "Password"
                , Ui.Input.placeholder "password"
                , Ui.Input.type_ Ui.Input.password
                ]
            , div [ class "h-8" ] []
            , div [ class "flex justify-around gap-x-4" ]
                [ Ui.Button.primary
                    [ Ui.Button.stretch True
                    ]
                    "Create"
                , Ui.Button.secondary []
                    "Cancel"
                ]
            ]
        ]
