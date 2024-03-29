module Ui.Textfield exposing
    ( Attribute
    , Type
    , autofocus
    , customDescription
    , disabled
    , email
    , label
    , loading
    , number
    , onBlur
    , onFocus
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
import Ui.Internal
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


customDescription : List (Html msg) -> Attribute msg
customDescription html =
    Attribute <| \c -> { c | customDescription = Just html }


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


onBlur : msg -> Attribute msg
onBlur =
    attribute << Html.Events.onBlur


onFocus : msg -> Attribute msg
onFocus =
    attribute << Html.Events.onFocus


type alias Config msg =
    { inputAttributes : List (Html.Attribute msg)
    , customDescription : Maybe (List (Html msg))
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
    , customDescription = Nothing
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
    Html.div [ class "w-full max-w-sm" ]
        [ case config.label of
            Nothing ->
                viewInput config

            Just labelText ->
                Html.label [ class "group" ]
                    [ Html.div [ class "ml-1.5 mb-2" ]
                        [ Ui.LabelText.view
                            [ Ui.LabelText.validation config.validation ]
                            labelText
                        , case config.customDescription of
                            Nothing ->
                                Html.text ""

                            Just descr ->
                                Html.div
                                    [ class "text-sm text-gray-500 mt-1 leading-snug"
                                    ]
                                    descr
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
    Html.div [ class "ml-2 my-1 leading-none text-xs text-red-500" ]
        [ Html.text reason ]


viewIcon : Config msg -> Html msg
viewIcon config =
    case config.validation of
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


viewInput : Config msg -> Html msg
viewInput config =
    let
        (Type thisType) =
            config.type_
    in
    Html.div
        [ Ui.Internal.formFieldContainerClass config.validation
        , class "flex items-center"
        ]
        [ Html.Extra.concatAttributes Html.input
            config.inputAttributes
            [ class "px-4 py-2"
            , Ui.Internal.formFieldElementClass
            , Html.Attributes.type_ thisType
            ]
            []
        , viewIcon config
        ]


viewCheckIcon : Html msg
viewCheckIcon =
    Heroicons.Outline.checkCircle [ Svg.Attributes.class "h-6 w-6 text-green-500" ]


viewErrorIcon : Html msg
viewErrorIcon =
    Heroicons.Outline.exclamationCircle [ Svg.Attributes.class "h-6 w-6 text-red-500" ]
