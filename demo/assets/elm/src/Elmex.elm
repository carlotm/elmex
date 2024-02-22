port module Elmex exposing (..)

port pushEvent : String -> Cmd msg
port pullEvent : (String -> msg) -> Sub msg
