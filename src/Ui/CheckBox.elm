module Ui.CheckBox exposing
    ( Attribute
    , checked
    , label
    , onCheck
    , view
    )

import Heroicons.Solid as Icons
import Html exposing (Html)
import Html.Attributes exposing (class, classList)
import Html.Events
import Html.Extra
import Json.Decode exposing (Decoder)
import Svg.Attributes


type Attribute msg
    = Attribute (Config msg -> Config msg)



-- attribute : Html.Attribute msg -> Attribute msg
-- attribute attr_ =
--     Attribute <| \c -> { c | checkboxAttributes = attr_ :: c.checkboxAttributes }


label : String -> Attribute msg
label label_ =
    Attribute <| \c -> { c | label = Just label_ }


checked : Bool -> Attribute msg
checked value =
    Attribute <| \c -> { c | checked = value }


onCheck : (Bool -> msg) -> Attribute msg
onCheck onCheck_ =
    Attribute <| \c -> { c | onCheck = Just onCheck_ }


type alias Config msg =
    { checkboxAttributes : List (Html.Attribute msg)
    , label : Maybe String
    , checked : Bool
    , onCheck : Maybe (Bool -> msg)
    }


defaultConfig : Config msg
defaultConfig =
    { checkboxAttributes = []
    , label = Nothing
    , checked = False
    , onCheck = Nothing
    }


makeConfig : List (Attribute msg) -> Config msg
makeConfig =
    List.foldr (\(Attribute setConfig) current -> setConfig current) defaultConfig


view : List (Attribute msg) -> Html msg
view attributes =
    let
        config =
            makeConfig attributes
    in
    Html.div []
        [ Html.div [ class "hidden" ]
            [ Html.Extra.concatAttributes Html.input
                (List.filterMap identity [ Maybe.map Html.Events.onCheck config.onCheck ])
                [ Html.Attributes.type_ "checkbox"
                , Html.Attributes.checked config.checked
                ]
                []
            ]
        , viewFakeCheckbox config
        ]


spaceKeyCode : Int
spaceKeyCode =
    32


decodeSpace : msg -> Decoder msg
decodeSpace msg =
    Html.Events.keyCode
        |> Json.Decode.andThen
            (\kc ->
                if kc == spaceKeyCode then
                    Json.Decode.succeed msg

                else
                    Json.Decode.fail ""
            )


viewFakeCheckbox : Config msg -> Html msg
viewFakeCheckbox config =
    let
        maybeOnCheck =
            Maybe.map
                (\onCheck_ -> onCheck_ (not config.checked))
                config.onCheck
    in
    Html.Extra.concatAttributes
        Html.div
        (List.filterMap identity
            [ Maybe.map Html.Events.onClick maybeOnCheck
            , Maybe.map (\msg -> Html.Events.on "keydown" (decodeSpace msg)) maybeOnCheck
            ]
        )
        [ class "h-5 w-5 rounded-md border shadow-sm cursor-pointer"
        , class "hover:border-blue-300 focus:outline-none focus:border-blue-300 focus:ring ring-blue-100"
        , classList [ ( "bg-indigo-600 border-indigo-700", config.checked ) ]
        , Html.Attributes.tabindex 0
        ]
        [ if config.checked then
            Icons.check
                [ Svg.Attributes.class "text-indigo-100"
                ]

          else
            Html.text ""
        ]
