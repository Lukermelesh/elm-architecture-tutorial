import Html exposing (..)
import Html.Events exposing (..)
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Time exposing (Time, second)



main =
  Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }



-- MODEL


type alias Model =
  { time : Time
  , stopped : Bool
  }


init : (Model, Cmd Msg)
init =
  (Model 0 False, Cmd.none)



-- UPDATE


type Msg
  = Tick Time
  | SetTimeFlow Bool

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Tick newTime ->
      ({ model | time = newTime }, Cmd.none)

    SetTimeFlow state ->
      ({ model | stopped = state }, Cmd.none)


-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
    if model.stopped
    then Sub.none
    else Time.every second Tick


-- VIEW


view : Model -> Html Msg
view model =
    div []
    [ svg [ viewBox "0 0 100 100", width "300px" ]
        [ circle [ cx "50", cy "50", r "45", fill "#0B79CE" ] []
        , getHand (Time.inMinutes model.time) 1 0.5
        , getHand (Time.inHours model.time) 1 1
        , getHand (Time.inHours model.time / 12) 0.75 1.3
        ]
    , br [] []
    , button [ onClick (SetTimeFlow True) ] [ Html.text "Stop time" ]
    , button [ onClick (SetTimeFlow False) ] [ Html.text "Resume time" ]
    ]

getHand time handLength handWidth =
  let
    angle =
      turns time

    handX =
      toString (50 + 40 * handLength * cos angle)

    handY =
      toString (50 + 40 * handLength * sin angle)

  in
    line [ x1 "50", y1 "50", x2 handX, y2 handY, stroke "#023963", strokeWidth (toString handWidth) ] []