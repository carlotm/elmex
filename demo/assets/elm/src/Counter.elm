module Counter exposing (main)


import Browser
import Html exposing (Html, button, div, text)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)



-- MAIN


main =
    Browser.sandbox { init = init, update = update, view = view }



-- MODEL


type alias Model =
    Int


init : Model
init =
    0



-- UPDATE


type Msg
    = Increment
    | Decrement


update : Msg -> Model -> Model
update msg model =
    case msg of
        Increment ->
            model + 1

        Decrement ->
            model - 1



-- VIEW


view : Model -> Html Msg
view model =
    div [ class "flex space-x-2" ]
        [ button [ class "bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded-full", onClick Decrement ] [ text "-" ]
        , div [ class "bg-slate-200 flex items-center justify-center w-12 rounded-full" ] [ text (String.fromInt model) ]
        , button [ class "bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded-full", onClick Increment ] [ text "+" ]
        ]
