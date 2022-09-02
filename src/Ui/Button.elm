module Ui.Button exposing
    ( Attribute
    , Size
    , default
    , large
    , medium
    , onClick
    , primary
    , secondary
    , size
    , small
    )

import Html exposing (Html)
import Html.Attributes exposing (class)
import Html.Events
import Html.Extra
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


onClick : msg -> Attribute msg
onClick =
    attribute << Html.Events.onClick


attribute : Html.Attribute msg -> Attribute msg
attribute attr_ =
    Attribute <| \c -> { c | buttonAttributes = attr_ :: c.buttonAttributes }


type alias Config msg =
    { buttonAttributes : List (Html.Attribute msg)
    , size : Size
    }


defaultConfig : Config msg
defaultConfig =
    { buttonAttributes = []
    , size = medium
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
    in
    Html.Extra.concatAttributes Html.button
        [ class "leading-none rounded-md"
        , class "focus:outline-none focus:ring focus:border-blue-700"
        , class "transition transition-all duration-100 ease-in-out"
        , class <|
            case variant of
                Default ->
                    "border font-semibold shadow-sm bg-slate-50 hover:bg-slate-100 text-slate-900 active:bg-slate-200 ring-blue-100"

                Primary ->
                    "shadow-lg font-semibold bg-slate-900 text-white hover:bg-slate-900/95 active:bg-slate-900 active:scale-[0.98] active:shadow-none ring-blue-300"

                Secondary ->
                    "border hover:border-slate-500 text-slate-700 ring-blue-100"
        , class <|
            case config.size of
                Small ->
                    "px-2 py-1.5 text-sm"

                Medium ->
                    "px-4 py-2"

                Large ->
                    "px-6 py-3"
        ]
        config.buttonAttributes
        [ Html.text label ]


default : List (Attribute msg) -> String -> Html msg
default =
    view Default


primary : List (Attribute msg) -> String -> Html msg
primary =
    view Primary


secondary : List (Attribute msg) -> String -> Html msg
secondary =
    view Secondary
