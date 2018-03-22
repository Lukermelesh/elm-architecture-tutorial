import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Regex exposing (..)
import Char exposing (..)


main =
  Html.beginnerProgram
    { model = model
    , view = view
    , update = update
    }



-- MODEL


type alias Model =
  { name : String
  , password : String
  , passwordAgain : String
  , age : String
  , validate : Bool
  }


model : Model
model =
  Model "" "" "" "" False



-- UPDATE


type Msg
    = Name String
    | Password String
    | PasswordAgain String
    | Age String
    | Validate


update : Msg -> Model -> Model
update msg model =
  case msg of
    Name name ->
      { model | name = name }

    Age age ->
      { model | age = age }

    Password password ->
      { model | password = password }

    PasswordAgain password ->
      { model | passwordAgain = password }

    Validate ->
      { model | validate = True }

-- VIEW


view : Model -> Html Msg
view model =
  div []
    [ input [ type_ "text", placeholder "Name", onInput Name ] []
    , input [ type_ "text", placeholder "Age", onInput Age ] []
    , input [ type_ "password", placeholder "Password", onInput Password ] []
    , input [ type_ "password", placeholder "Re-enter Password", onInput PasswordAgain ] []
    , button [ onClick Validate ] [ text "Submit" ]
    , viewValidation model
    ]



viewValidation : Model -> Html msg
viewValidation model =
  if model.validate then
    let
      (color, message) =
        if isIntParsable model.age == False then
          ("red", "Age must be a number!")
        else if model.password /= model.passwordAgain then
          ("red", "Passwords do not match!")
        else if String.length model.password < 8 then
          ("red", "Password must be at least 8 characters long!")
        else if not (String.any isDigit model.password) then
          ("red", "Password must contain at least one digit!")
        else if not (Regex.contains (regex "[A-Z]") model.password) then
          ("red", "Password must contain at least one upper case character!")
        else
          ("green", "OK")
    in
      div [ style [("color", color)] ] [ text message ]
  else
    div [] []

isIntParsable str =
  case String.toInt str of
    Ok _ -> True
    _ -> False