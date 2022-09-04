module Ui.Alert exposing (Attribute, default, error, onClose, warning)

import Heroicons.Solid
import Html exposing (Html)
import Html.Attributes exposing (class)
import Html.Events
import Svg.Attributes
import Utils


type Variant
    = Default
    | Warning
    | Error


type alias Config msg =
    { onClose : Maybe msg
    }


defaultConfig : Config msg
defaultConfig =
    { onClose = Nothing
    }


makeConfig : List (Attribute msg) -> Config msg
makeConfig =
    Utils.getMakeConfig
        { unwrap = \(Attribute s) -> s
        , defaultConfig = defaultConfig
        }


type Attribute msg
    = Attribute (Config msg -> Config msg)


onClose : msg -> Attribute msg
onClose msg =
    Attribute <| \c -> { c | onClose = Just msg }


error : List (Attribute msg) -> List (Html msg) -> Html msg
error =
    view Error


default : List (Attribute msg) -> List (Html msg) -> Html msg
default =
    view Default


warning : List (Attribute msg) -> List (Html msg) -> Html msg
warning =
    view Warning


view : Variant -> List (Attribute msg) -> List (Html msg) -> Html msg
view variant attributes children =
    let
        config =
            makeConfig attributes
    in
    Html.div
        [ class "rounded-md text-base border px-4 py-2 w-full"
        , class "flex justify-between"
        , class <|
            case variant of
                Default ->
                    "bg-sky-100 border-sky-300 text-sky-900"

                Warning ->
                    "bg-orange-100 border-orange-300 text-orange-900"

                Error ->
                    "bg-red-100 border-red-300 text-red-900"
        ]
        [ Html.div [] children
        , case config.onClose of
            Nothing ->
                Html.text ""

            Just onClose_ ->
                Html.div [ class "self-center" ] [ closeIcon onClose_ ]
        ]


closeIcon : msg -> Html msg
closeIcon onClick =
    Html.button
        [ Html.Events.onClick onClick
        , class "hover:bg-white/40 hover:shadow-sm p-1 -m-1 rounded-md block"
        , Html.Attributes.type_ "button"
        ]
        [ Heroicons.Solid.x
            [ Svg.Attributes.class "h-5 w-5 "
            ]
        ]
