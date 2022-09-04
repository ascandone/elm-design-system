module Ui.Tab exposing
    ( item
    , value
    , view
    )

import Html exposing (Html)
import Html.Attributes exposing (class)
import Html.Events
import Utils


type alias Config value =
    { selectedValue : Maybe value
    }


value : value -> Attribute value
value x =
    Attribute <| \c -> { c | selectedValue = Just x }


defaultConfig : Config value
defaultConfig =
    { selectedValue = Nothing
    }


makeConfig : List (Attribute value) -> Config value
makeConfig =
    Utils.getMakeConfig
        { unwrap = \(Attribute s) -> s
        , defaultConfig = defaultConfig
        }


type Attribute value
    = Attribute (Config value -> Config value)


type Item value
    = Item value String


item :
    { value : a
    , label : String
    }
    -> Item a
item args =
    Item args.value args.label


viewItem : Maybe value -> Item value -> Html value
viewItem currentValue (Item value_ label) =
    let
        isSelected =
            currentValue == Just value_
    in
    Html.button
        [ class "group relative px-4 font-semibold"
        , class <|
            if isSelected then
                "text-gray-900"

            else
                "text-gray-500"
        , Html.Events.onClick value_
        ]
        [ Html.div [ class "my-1.5" ] [ Html.text label ]
        , Html.div
            [ class "absolute left-1 right-1 -translate-y-0.5 h-1 rounded-sm"
            , class "transition transition-color duration-100 ease-in-out"
            , class <|
                if isSelected then
                    "bg-slate-700"

                else
                    "bg-transparent group-hover:bg-slate-300"
            ]
            []
        ]


view : List (Attribute value) -> List (Item value) -> Html value
view attributes items =
    let
        config =
            makeConfig attributes
    in
    Html.div [ class "flex border-b text-lg" ]
        (List.map (viewItem config.selectedValue) items)
