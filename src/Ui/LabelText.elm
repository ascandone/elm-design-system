module Ui.LabelText exposing
    ( Attribute
    , validation
    , view
    )

import Html exposing (Html)
import Html.Attributes exposing (class)
import Utils


type alias Config =
    { validation : Maybe (Result String ())
    }


defaultConfig : Config
defaultConfig =
    { validation = Nothing
    }


type Attribute
    = Attribute (Config -> Config)


validation : Maybe (Result String ()) -> Attribute
validation validation_ =
    Attribute <| \c -> { c | validation = validation_ }


makeConfig : List Attribute -> Config
makeConfig =
    Utils.getMakeConfig
        { unwrap = \(Attribute s) -> s
        , defaultConfig = defaultConfig
        }


view : List Attribute -> String -> Html msg
view attributes labelText =
    let
        config =
            makeConfig attributes
    in
    Html.p
        [ class "leading-none cursor-pointer select-none"
        , class <|
            case config.validation of
                Nothing ->
                    "text-gray-600 group-hover:text-blue-500 group-focus-within:text-blue-500"

                Just (Ok _) ->
                    "text-green-600/90 group-hover:text-green-600 group-focus-within:text-green-600"

                Just (Err _) ->
                    "text-red-500/90 group-hover:text-red-500 group-focus-within:text-red-500"
        ]
        [ Html.text labelText ]
