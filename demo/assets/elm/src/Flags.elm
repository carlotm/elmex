module Flags exposing (..)

import Browser
import Html exposing (Html, button, div, text)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
-- import LiveView exposing (pushEvent)




-- MAIN


main : Program String Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


type alias Model =
    { currentTime : Int }


init : String -> ( Model, Cmd Msg )
init currentTime =
    let
        t =
            case String.toInt currentTime of
                Just x ->
                    x

                Nothing ->
                    0
    in
    ( { currentTime = t }
    , Cmd.none
    )



-- UPDATE


type Msg
    = NoOp
    | TalkToLV


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        TalkToLV ->
            ( model, pushEvent "hey" )



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ text ("I am a flag: " ++ String.fromInt model.currentTime)
        , button [ onClick TalkToLV, class "ml-2 rounded bg-slate-200 p-2" ] [ text "Send event to the live view" ]
        ]



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none
