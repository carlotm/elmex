module Flags exposing (..)

import Browser
import Html exposing (Html, text)



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
        t = case String.toInt currentTime of
            Just x -> x
            Nothing -> 0
    in
    ( { currentTime = t }
    , Cmd.none
    )



-- UPDATE


type Msg
    = NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update _ model =
    ( model, Cmd.none )



-- VIEW


view : Model -> Html Msg
view model =
    text (String.fromInt model.currentTime)



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none
