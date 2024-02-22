module Flags exposing (..)

import Browser
import Html exposing (Html, button, div, text, p)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Elmex exposing (pushEvent, pullEvent)




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
    { currentTime : Int
    , messageFromLV : String
    }


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
    ( { currentTime = t, messageFromLV = "...waiting for live view..." }
    , Cmd.none
    )



-- UPDATE


type Msg
    = NoOp
    | TalkToLV
    | Recv String



update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        TalkToLV ->
            ( model, pushEvent "hey" )

        Recv message ->
            ( { model | messageFromLV = message }, Cmd.none)



-- VIEW


view : Model -> Html Msg
view model =
    div [ class "space-y-2" ]
        [ p [] [ text ("I am a flag: " ++ String.fromInt model.currentTime) ]
        , p [] [ text model.messageFromLV ]
        , button [ onClick TalkToLV, class "rounded bg-slate-200 p-2" ] [ text "Send event to the live view" ]
        ]



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    pullEvent Recv
