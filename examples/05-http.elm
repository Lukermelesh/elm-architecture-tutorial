import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode as Decode



main =
  Html.program
    { init = init "cats"
    , view = view
    , update = update
    , subscriptions = subscriptions
    }



-- MODEL


type alias Model =
  { topic : String
  , gifUrl : String
  , errorMsg : String
  }


init : String -> (Model, Cmd Msg)
init topic =
  ( Model topic "waiting.gif" ""
  , getRandomGif topic
  )



-- UPDATE


type Msg
  = MorePlease
  | NewGif (Result Http.Error String)
  | Topic String


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Topic topic ->
      ({ model | topic = topic }, Cmd.none)

    MorePlease ->
      (model, getRandomGif model.topic)

    NewGif (Ok newUrl) ->
      (Model model.topic newUrl "", Cmd.none)

    NewGif (Err msg) ->
      ({ model | errorMsg = toString msg }, Cmd.none)



-- VIEW


view : Model -> Html Msg
view model =
  div []
    [ h2 [] [text model.topic]
    , button [ onClick MorePlease ] [ text "More Please!" ]
    , br [] []
    , maybeRenderError model
    , dropdownMenu model
    , br [] []
    , img [src model.gifUrl] []
    ]

dropdownMenu : Model -> Html Msg
dropdownMenu model =
  select [ onInput Topic ]
    [ option [ value "cats" ] [ text "cats" ]
    , option [ value "dogs" ] [ text "dogs" ]
    , option [ value "penguins" ] [ text "penguins" ]
    ]


maybeRenderError: Model -> Html Msg
maybeRenderError model =
  if String.length model.errorMsg > 0 then
    div [] [ text ("ERROR: " ++ model.errorMsg) ]
  else
    text ""

-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none



-- HTTP


getRandomGif : String -> Cmd Msg
getRandomGif topic =
  let
    url =
      "https://api.giphy.com/v1/gifs/random?api_key=dc6zaTOxFJmzC&tag=" ++ topic
  in
    Http.send NewGif (Http.get url decodeGifUrl)


decodeGifUrl : Decode.Decoder String
decodeGifUrl =
  Decode.at ["data", "image_url"] Decode.string
