module Ui.Button exposing
    ( Attribute
    , Size
    , default
    , large
    , medium
    , onClick
    , primary
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
        [ class "shadow-sm leading-none rounded font-semibold"
        , class "focus:outline-none focus:ring ring-blue-100 focus:border-blue-700"
        , class <|
            case variant of
                Default ->
                    "border bg-gray-50 hover:bg-gray-100 text-gray-900 active:bg-gray-200"

                Primary ->
                    "bg-black text-white hover:bg-black/90 active:bg-black/80"
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
