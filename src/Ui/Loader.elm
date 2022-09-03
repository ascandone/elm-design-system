module Ui.Loader exposing
    ( Attribute
    , darkTheme
    , lightTheme
    , medium
    , size
    , small
    , variant
    , view
    )

import Html exposing (Html)
import Html.Attributes exposing (class)
import Utils


type Attribute
    = Attribute (Config -> Config)


variant : Variant -> Attribute
variant variant_ =
    Attribute <| \c -> { c | variant = variant_ }


type Variant
    = LightTheme
    | DarkTheme


lightTheme : Variant
lightTheme =
    LightTheme


darkTheme : Variant
darkTheme =
    DarkTheme


type Size
    = Small
    | Medium


small : Size
small =
    Small


medium : Size
medium =
    Medium


size : Size -> Attribute
size size_ =
    Attribute <| \c -> { c | size = size_ }


type alias Config =
    { variant : Variant
    , size : Size
    }


defaultConfig : Config
defaultConfig =
    { variant = LightTheme
    , size = Medium
    }


makeConfig : List Attribute -> Config
makeConfig =
    Utils.getMakeConfig
        { unwrap = \(Attribute s) -> s
        , defaultConfig = defaultConfig
        }


view : List Attribute -> Html msg
view attributes =
    let
        config =
            makeConfig attributes
    in
    Html.div
        [ class "animate-spin rounded-full"
        , class <|
            case config.size of
                Small ->
                    "border-2 h-4 w-4"

                Medium ->
                    "border-4 h-6 w-6"
        , class <|
            case config.variant of
                LightTheme ->
                    "border-slate-400 border-t-slate-900"

                DarkTheme ->
                    "border-slate-500 border-t-white"
        ]
        []
