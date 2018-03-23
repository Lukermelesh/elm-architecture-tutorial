import Html exposing (..)
import Html.Events exposing (..)
import String exposing (..)
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Random



main =
  Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }



-- MODEL


type alias Model =
  { face1 : Int
  , face2 : Int
  }


init : (Model, Cmd Msg)
init =
  (Model 1 1, Cmd.none)



-- UPDATE


type Msg
  = Roll
  | NewFace (Int, Int)


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Roll ->
      (model, Random.generate NewFace (Random.pair (randomInt) (randomInt)))

    NewFace (face1, face2) ->
      (Model face1 face2, Cmd.none)

randomInt =
  Random.int 1 6

-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none



-- VIEW

-- TODO: from elm-architecture:
-- After you have learned about tasks and animation, have the dice flip around randomly before they settle on a final value.
view : Model -> Html Msg
view model =
  div []
    [ showSvgDie model.face1
    , showSvgDie model.face2
    , br [] []
    , button [ onClick Roll ] [ Html.text "Roll" ]
    ]

showSvgDie num =
  case num of
    1 ->
      svgElement
        [ Svg.circle [ cx "60", cy "60", r "5" ] [] ]
    2 ->
      svgElement
        [ Svg.circle [ cx "80", cy "60", r "5" ] []
        , Svg.circle [ cx "40", cy "60", r "5" ] []
        ]
    3 ->
      svgElement
        [ Svg.circle [ cx "80", cy "40", r "5" ] []
        , Svg.circle [ cx "60", cy "60", r "5" ] []
        , Svg.circle [ cx "40", cy "80", r "5" ] []
        ]
    4 ->
      svgElement
        [ Svg.circle [ cx "80", cy "40", r "5" ] []
        , Svg.circle [ cx "40", cy "40", r "5" ] []
        , Svg.circle [ cx "80", cy "80", r "5" ] []
        , Svg.circle [ cx "40", cy "80", r "5" ] []
        ]
    5 ->
      svgElement
        [ Svg.circle [ cx "80", cy "40", r "5" ] []
        , Svg.circle [ cx "40", cy "40", r "5" ] []
        , Svg.circle [ cx "80", cy "80", r "5" ] []
        , Svg.circle [ cx "40", cy "80", r "5" ] []
        , Svg.circle [ cx "60", cy "60", r "5" ] []
        ]
    6 ->
      svgElement
        [ Svg.circle [ cx "80", cy "40", r "5" ] []
        , Svg.circle [ cx "40", cy "40", r "5" ] []
        , Svg.circle [ cx "80", cy "80", r "5" ] []
        , Svg.circle [ cx "40", cy "80", r "5" ] []
        , Svg.circle [ cx "40", cy "60", r "5" ] []
        , Svg.circle [ cx "80", cy "60", r "5" ] []
        ]
    _ ->
      -- TODO: show nothing!
      div [] []

svgElement args =
  svg
    [ width "120", height "120", viewBox "0 0 120 120" ]
    args