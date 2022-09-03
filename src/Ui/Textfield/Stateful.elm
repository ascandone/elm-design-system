module Ui.Textfield.Stateful exposing
    ( Model
    , Msg
    , getValue
    , init
    , update
    , view
    )

import Html exposing (Html)
import Html.Extra
import Ui.Textfield


type Model parsed
    = Model
        { value : String
        , validation : String -> Result String parsed
        , interacted : Bool
        , showValidation : Bool
        }


init : (String -> Result String parsed) -> Model parsed
init validation =
    Model
        { value = ""
        , validation = validation
        , interacted = False
        , showValidation = False
        }


getValue : Model parsed -> Result String parsed
getValue (Model model) =
    model.validation model.value


type Msg
    = Input String
    | Focused
    | Blurred


update : Msg -> Model parsed -> Model parsed
update msg (Model model) =
    Model <|
        case msg of
            Input newText ->
                { model
                    | value = newText
                    , interacted = True
                    , showValidation =
                        case model.validation model.value of
                            Ok _ ->
                                False

                            Err _ ->
                                model.showValidation
                }

            Focused ->
                { model | interacted = True }

            Blurred ->
                { model
                    | showValidation =
                        if model.interacted then
                            True

                        else
                            model.showValidation
                }


showedValidation : Model parsed -> Maybe (Result String ())
showedValidation (Model model) =
    case model.validation model.value of
        Ok _ ->
            Nothing

        Err err ->
            if model.showValidation then
                Just (Err err)

            else
                Nothing


view : Model parsed -> List (Ui.Textfield.Attribute Msg) -> Html Msg
view ((Model _) as model) attributes =
    Html.Extra.concatAttributes Ui.Textfield.view
        attributes
        [ Ui.Textfield.onInput Input
        , Ui.Textfield.validation (showedValidation model)
        , Ui.Textfield.onBlur Blurred
        , Ui.Textfield.onFocus Focused
        ]
