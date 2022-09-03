module FormExample exposing (main)

import Browser
import Html exposing (..)
import Html.Attributes exposing (class)
import Ui.Button
import Ui.CheckBox
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
    { bannerIsActive : Bool
    }


init : Flags -> ( Model, Cmd Msg )
init _ =
    ( { bannerIsActive = True }
    , Cmd.none
    )


type Msg
    = CloseBanner


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        CloseBanner ->
            ( { model
                | bannerIsActive = False
              }
            , Cmd.none
            )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


viewCard : List (Html msg) -> Html msg
viewCard =
    div [ class "max-w-md px-6 py-6 w-full rounded-lg bg-white border shadow-md" ]


viewCookieBanner : Html Msg
viewCookieBanner =
    div [ class "bg-black/20 fixed inset-0 flex align-center justify-center" ]
        [ div [ class "absolute bg-white w-72 rounded-md shadow bottom-0 right-0 rounded-0 m-10 p-4" ]
            [ h3 [ class "font-semibold text-lg" ] [ text "Usiamo i cookies 🍪" ]
            , div [ class "h-2" ] []
            , p [ class "text-sm text-gray-600" ]
                [ text """
                    Questo sito fa uso di cookie per migliorare l’esperienza
                    di navigazione degli utenti e per raccogliere informazioni
                    sull’utilizzo del sito stesso.
                    Puoi consultare la nostra """
                , a [ class "text-cyan-600 border-b border-cyan-600 font-semibold" ] [ text "cookie policy" ]
                , text " per ulteriori dettagli."
                ]
            , div [ class "h-7" ] []
            , div [ class "flex justify-between" ]
                [ Ui.Button.secondary
                    [ Ui.Button.onClick CloseBanner
                    ]
                    "No, grazie"
                , Ui.Button.primary
                    [ Ui.Button.onClick CloseBanner
                    ]
                    "Accetta"
                ]
            ]
        ]


view : Model -> Html Msg
view model =
    div []
        [ if model.bannerIsActive then
            viewCookieBanner

          else
            text ""
        , div [ class "flex flex-col items-center justify-center h-screen" ]
            [ div [ class "text-center" ]
                [ h3 [ class "font-bold text-2xl leading-none" ]
                    [ text "Sign up" ]
                , div [ class "h-3" ] []
                , p [ class "text-gray-700" ]
                    [ text "Already got an account? "
                    , a
                        [ class "text-cyan-600 border-b border-cyan-600 cursor-pointer"
                        ]
                        [ text "Click here" ]
                    , text " to log in"
                    ]
                ]
            , div [ class "h-10" ] []
            , viewCard
                [ Ui.Textfield.view
                    [ Ui.Textfield.label "Email"
                    ]
                , div [ class "h-4" ] []
                , div [ class "flex gap-x-5" ]
                    [ Ui.Textfield.view
                        [ Ui.Textfield.label "First name"
                        ]
                    , Ui.Textfield.view
                        [ Ui.Textfield.label "Last name"
                        ]
                    ]
                , div [ class "h-4" ] []
                , Ui.Textfield.view
                    [ Ui.Textfield.label "Password"
                    , Ui.Textfield.type_ Ui.Textfield.password
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
        ]
