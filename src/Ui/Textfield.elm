module Ui.Textfield exposing
    ( Attribute
    , Type
    , autofocus
    , disabled
    , email
    , label
    , loading
    , number
    , onInput
    , password
    , placeholder
    , spellcheck
    , text
    , type_
    , validation
    , value
    , view
    )

import Heroicons.Outline
import Html exposing (Html)
import Html.Attributes exposing (class)
import Html.Events
import Html.Extra
import Svg.Attributes
import Ui.LabelText
import Ui.Loader
import Utils


type Attribute msg
    = Attribute (Config msg -> Config msg)


type Type
    = Type String


type_ : Type -> Attribute msg
type_ x =
    Attribute <| \c -> { c | type_ = x }


text : Type
text =
    Type "text"


password : Type
password =
    Type "password"


number : Type
number =
    Type "number"


email : Type
email =
    Type "email"


attribute : Html.Attribute msg -> Attribute msg
attribute attr_ =
    Attribute <| \c -> { c | inputAttributes = attr_ :: c.inputAttributes }


placeholder : String -> Attribute msg
placeholder =
    attribute << Html.Attributes.placeholder


spellcheck : Bool -> Attribute msg
spellcheck =
    attribute << Html.Attributes.spellcheck


autofocus : Bool -> Attribute msg
autofocus =
    attribute << Html.Attributes.autofocus


disabled : Bool -> Attribute msg
disabled =
    attribute << Html.Attributes.disabled


loading : Bool -> Attribute msg
loading loading_ =
    Attribute <| \c -> { c | loading = loading_ }


label : String -> Attribute msg
label label_ =
    Attribute <| \c -> { c | label = Just label_ }


validation : Maybe (Result String ()) -> Attribute msg
validation validation_ =
    Attribute <| \c -> { c | validation = validation_ }


value : String -> Attribute msg
value =
    attribute << Html.Attributes.value


onInput : (String -> msg) -> Attribute msg
onInput =
    attribute << Html.Events.onInput


type alias Config msg =
    { inputAttributes : List (Html.Attribute msg)
    , label : Maybe String
    , validation : Maybe (Result String ())
    , type_ : Type
    , loading : Bool
    }


defaultConfig : Config msg
defaultConfig =
    { inputAttributes = []
    , label = Nothing
    , validation = Nothing
    , type_ = text
    , loading = False
    }


makeConfig : List (Attribute msg) -> Config msg
makeConfig =
    Utils.getMakeConfig
        { unwrap = \(Attribute s) -> s
        , defaultConfig = defaultConfig
        }


view : List (Attribute msg) -> Html msg
view attributes =
    let
        config =
            makeConfig attributes
    in
    Html.div []
        [ case config.label of
            Nothing ->
                viewInput config

            Just labelText ->
                Html.label [ class "group" ]
                    [ Html.div [ class "ml-2 mb-2" ]
                        [ Ui.LabelText.view
                            [ Ui.LabelText.validation config.validation ]
                            labelText
                        ]
                    , viewInput config
                    ]
        , Html.div [ class "h-2" ]
            [ case config.validation of
                Just (Err reason) ->
                    viewErrorMessage reason

                _ ->
                    Html.text ""
            ]
        ]


viewErrorMessage : String -> Html msg
viewErrorMessage reason =
    Html.div [ class "ml-2 my-1 leading-none text-xs text-red-500 absolute" ] [ Html.text reason ]


viewInput : Config msg -> Html msg
viewInput config =
    let
        (Type thisType) =
            config.type_
    in
    Html.div
        [ class "border rounded-md focus-within:ring shadow-sm transition-all duration-100"
        , class "flex items-center"
        , class <|
            case config.validation of
                Nothing ->
                    "group-hover:border-blue-500 focus-within:border-blue-600 ring-blue-200"

                Just (Ok _) ->
                    "group-hover:border-green-500 focus-within:border-green-600 ring-green-200 border-green-300"

                Just (Err _) ->
                    "group-hover:border-red-500 focus-within:border-red-600 ring-red-200 border-red-200"
        ]
        [ Html.Extra.concatAttributes Html.input
            config.inputAttributes
            [ class "px-4 py-2 rounded-md w-full focus:outline-none disabled:opacity-80"
            , Html.Attributes.type_ thisType
            ]
            []
        , case config.validation of
            Nothing ->
                if config.loading then
                    Html.div [ class " w-10 h-full" ]
                        [ Ui.Loader.view []
                        ]

                else
                    Html.text ""

            Just result ->
                Html.span [ class "px-2" ]
                    [ case result of
                        Ok _ ->
                            viewCheckIcon

                        Err _ ->
                            viewErrorIcon
                    ]
        ]


viewCheckIcon : Html msg
viewCheckIcon =
    Heroicons.Outline.checkCircle [ Svg.Attributes.class "h-6 w-6 text-green-500" ]


viewErrorIcon : Html msg
viewErrorIcon =
    Heroicons.Outline.exclamationCircle [ Svg.Attributes.class "h-6 w-6 text-red-500" ]
