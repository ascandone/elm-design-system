module FormExample exposing (main)

import Browser
import Html exposing (..)
import Html.Attributes exposing (class)
import Ui.Button
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
    div [ class "max-w-md px-6 py-6 w-full rounded-lg bg-white border shadow-md" ]


view : Model -> Html Msg
view _ =
    div [ class "flex flex-col items-center justify-center h-screen" ]
        [ div [ class "text-center" ]
            [ h3 [ class "font-bold text-2xl leading-none" ]
                [ text "Sign up" ]
            , div [ class "h-3" ] []
            , p [ class "text-gray-700" ]
                [ text "Already got an account? "
                , a
                    [ class "text-cyan-600 underline cursor-pointer"
                    ]
                    [ text "Click here" ]
                , text " to log in"
                ]
            ]
        , div [ class "h-10" ] []
        , viewCard
            [ Ui.Input.view
                [ Ui.Input.label "Email"
                ]
            , div [ class "h-4" ] []
            , div [ class "flex gap-x-5" ]
                [ Ui.Input.view
                    [ Ui.Input.label "First name"
                    ]
                , Ui.Input.view
                    [ Ui.Input.label "Last name"
                    ]
                ]
            , div [ class "h-4" ] []
            , Ui.Input.view
                [ Ui.Input.label "Password"
                , Ui.Input.type_ Ui.Input.password
                ]
            , div [ class "h-4" ] []
            , Ui.CheckBox.view
                [ Ui.CheckBox.label "Agree to receive spam" ]
            , div [ class "h-8" ] []
            , Ui.Button.primary
                [ Ui.Button.stretch True
                , Ui.Button.size Ui.Button.large
                ]
                "Create"
            ]
        ]
