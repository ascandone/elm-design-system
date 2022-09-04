module Ui.Internal exposing (formFieldContainerClass, formFieldElementClass)

import Html exposing (Attribute)
import Html.Attributes exposing (class, classList)


formFieldContainerClass : Maybe (Result e v) -> Attribute msg
formFieldContainerClass validation =
    classList
        [ ( "relative border rounded-md focus-within:ring shadow-sm transition-all duration-100", True )
        , ( case validation of
                Nothing ->
                    "hover:border-blue-500 group-hover:border-blue-500 focus-within:border-blue-600 ring-blue-200"

                Just (Ok _) ->
                    "hover:border-green-500 group-hover:border-green-500 focus-within:border-green-600 ring-green-200 border-green-300"

                Just (Err _) ->
                    "hover:border-red-500 group-hover:border-red-500 focus-within:border-red-600 ring-red-200 border-red-200"
          , True
          )
        ]


formFieldElementClass : Attribute msg
formFieldElementClass =
    class "rounded-md w-full focus:outline-none disabled:opacity-80"
