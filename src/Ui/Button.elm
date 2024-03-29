module Ui.Button exposing
    ( Attribute
    , Size
    , Type
    , button
    , default
    , disabled
    , large
    , loading
    , medium
    , onClick
    , primary
    , secondary
    , size
    , small
    , stretch
    , submit
    , type_
    )

import Html exposing (Html)
import Html.Attributes exposing (class, classList)
import Html.Events
import Html.Extra
import Ui.Loader
import Utils


type Attribute msg
    = Attribute (Config msg -> Config msg)


type Variant
    = Default
    | Primary
    | Secondary


type Size
    = Small
    | Medium
    | Large


small : Size
small =
    Small


medium : Size
medium =
    Medium


large : Size
large =
    Large


size : Size -> Attribute msg
size size_ =
    Attribute <| \c -> { c | size = size_ }


type Type
    = Type String


type_ : Type -> Attribute msg
type_ x =
    Attribute <| \c -> { c | type_ = x }


button : Type
button =
    Type "button"


submit : Type
submit =
    Type "submit"


stretch : Bool -> Attribute msg
stretch stretch_ =
    Attribute <| \c -> { c | stretch = stretch_ }


loading : Bool -> Attribute msg
loading loading_ =
    Attribute <| \c -> { c | loading = loading_ }


disabled : Bool -> Attribute msg
disabled =
    attribute << Html.Attributes.disabled


onClick : msg -> Attribute msg
onClick =
    attribute << Html.Events.onClick


attribute : Html.Attribute msg -> Attribute msg
attribute attr_ =
    Attribute <| \c -> { c | buttonAttributes = attr_ :: c.buttonAttributes }


type alias Config msg =
    { buttonAttributes : List (Html.Attribute msg)
    , size : Size
    , stretch : Bool
    , loading : Bool
    , type_ : Type
    }


defaultConfig : Config msg
defaultConfig =
    { buttonAttributes = []
    , size = medium
    , stretch = False
    , loading = False
    , type_ = button
    }


makeConfig : List (Attribute msg) -> Config msg
makeConfig =
    Utils.getMakeConfig
        { unwrap = \(Attribute s) -> s
        , defaultConfig = defaultConfig
        }


view : Variant -> List (Attribute msg) -> String -> Html msg
view variant attributes label =
    let
        config =
            makeConfig attributes

        (Type btnType) =
            config.type_
    in
    Html.Extra.concatAttributes Html.button
        [ class "leading-none rounded-md whitespace-nowrap"
        , class "focus:outline-none focus:ring active:ring-2 focus:border-blue-700 min-w-10"
        , class "transition transition-all duration-100 ease-in-out"
        , class "flex justify-center items-center"
        , class "disabled:active:scale-100 disabled:shadow-none disabled:opacity-95"
        , classList [ ( "w-full", config.stretch ) ]
        , Html.Attributes.disabled config.loading
        , Html.Attributes.type_ btnType
        , class <|
            case variant of
                Default ->
                    "border font-semibold shadow-sm hover:bg-slate-100 text-slate-900 active:bg-slate-200 ring-blue-100"

                Primary ->
                    "shadow-lg font-semibold tracking-wider bg-slate-900 text-white/90 hover:bg-slate-900/95 active:bg-slate-900 active:scale-[0.99] active:shadow-none ring-blue-300"

                Secondary ->
                    "border hover:border-slate-500 text-slate-700 ring-blue-100"
        , class <|
            case config.size of
                Small ->
                    "px-3 py-1.5 text-sm"

                Medium ->
                    "px-5 py-2"

                Large ->
                    "px-7 py-3"
        ]
        config.buttonAttributes
        [ if config.loading then
            Html.span [ class "absolute insets-0" ]
                [ Ui.Loader.view
                    [ Ui.Loader.variant Ui.Loader.darkTheme
                    , Ui.Loader.size <|
                        case config.size of
                            Small ->
                                Ui.Loader.small

                            Medium ->
                                Ui.Loader.medium

                            Large ->
                                Ui.Loader.medium
                    ]
                ]

          else
            Html.text ""
        , Html.span [ classList [ ( "invisible", config.loading ) ] ]
            [ Html.text label ]
        ]


default : List (Attribute msg) -> String -> Html msg
default =
    view Default


primary : List (Attribute msg) -> String -> Html msg
primary =
    view Primary


secondary : List (Attribute msg) -> String -> Html msg
secondary =
    view Secondary
