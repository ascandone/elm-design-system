module Html.Attributes.Extra exposing (none)

import Html exposing (Attribute)
import Html.Attributes
import Json.Encode


none : Attribute msg
none =
    Html.Attributes.property "[[Attributes.none]]" Json.Encode.null
