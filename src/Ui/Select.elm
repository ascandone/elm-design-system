module Ui.Select exposing (onChange, option, optionValue, placeholer, value, view)

import Heroicons.Outline
import Html exposing (Html)
import Html.Attributes exposing (class)
import Html.Attributes.Extra
import Html.Events
import Svg.Attributes
import Ui.Internal
import Utils


type alias Config msg =
    { selectAttributes : List (Html.Attribute msg)
    , placeholder : Maybe String
    , onChange : Maybe (String -> msg)
    , value : Maybe String

    -- , customDescription : Maybe (List (Html msg))
    -- , label : Maybe String
    , validation : Maybe (Result String ())

    -- , type_ : Type
    -- , loading : Bool
    }


placeholer : String -> Attribute msg
placeholer text_ =
    Attribute <| \c -> { c | placeholder = Just text_ }


value : Maybe String -> Attribute msg
value value_ =
    Attribute <| \c -> { c | value = value_ }


onChange : (String -> msg) -> Attribute msg
onChange onChange_ =
    Attribute <| \c -> { c | onChange = Just onChange_ }


defaultConfig : Config msg
defaultConfig =
    { selectAttributes = []
    , placeholder = Nothing
    , onChange = Nothing
    , value = Nothing

    -- , label = Nothing
    , validation = Nothing

    -- , type_ = text
    -- , loading = False
    -- , customDescription = Nothing
    }


type Attribute msg
    = Attribute (Config msg -> Config msg)


makeConfig : List (Attribute msg) -> Config msg
makeConfig =
    Utils.getMakeConfig
        { unwrap = \(Attribute s) -> s
        , defaultConfig = defaultConfig
        }


type Option
    = Option
        { label : String
        , value : String
        }


option :
    { label : String
    , value : String
    }
    -> Option
option =
    Option


optionValue : String -> Option
optionValue value_ =
    Option
        { label = value_
        , value = value_
        }


view : List (Attribute msg) -> List Option -> Html msg
view attributes options =
    let
        config =
            makeConfig attributes

        htmlOptions_ =
            List.map
                (\(Option option_) ->
                    Html.option
                        [ Html.Attributes.selected (config.value == Just option_.value)
                        ]
                        [ Html.text option_.label ]
                )
                options
    in
    Html.div [ class "w-full relative" ]
        [ Html.select
            [ Ui.Internal.formFieldContainerClass config.validation
            , Ui.Internal.formFieldElementClass
            , Html.Attributes.value (Maybe.withDefault "" config.value)
            , class "pl-4 pr-8 py-2 appearance-none"
            , class <|
                case config.value of
                    Nothing ->
                        "text-gray-400"

                    Just _ ->
                        "text-gray-800"
            , case config.onChange of
                Nothing ->
                    Html.Attributes.Extra.none

                Just onChange_ ->
                    Html.Events.onInput onChange_
            ]
            (Html.option
                [ Html.Attributes.disabled True
                , Html.Attributes.selected (config.value == Nothing)
                ]
                [ Html.text (Maybe.withDefault "" config.placeholder) ]
                :: htmlOptions_
            )
        , Heroicons.Outline.chevronDown
            [ Svg.Attributes.class "h-5 w-5 absolute top-px bottom-0 right-2 translate-y-1/2" ]
        ]
