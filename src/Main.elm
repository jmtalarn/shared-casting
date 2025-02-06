port module Main exposing (main)

import Browser
import Css exposing (..)
import Gallery
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import Html.Styled.Events exposing (..)
import Model exposing (Model)
import Msg exposing (..)
import Phosphor exposing (IconWeight(..))
import Update exposing (update)
import View exposing (dialogCastMemberDetails, dialogMovieSearch, imageSlides, mainStyle, showCastSection, showMovie)



-- Define the port


port toggleDialog : String -> Cmd msg



-- import VitePluginHelper


main : Program () Model Msg
main =
    Browser.document
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view >> toUnstyledDocument
        }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { greeting = "Hello Goodbye"
      , searchResult = Nothing
      , query = Nothing
      , debounceTask = Nothing
      , targetMovieIndex = Just First
      , openedDialog = Nothing
      , movies = ( Nothing, Nothing )
      , details = ( Nothing, Nothing )
      , castMemberDetails = Nothing
      , imageGallery = Gallery.init (List.length [])
      , error = Nothing
      }
    , Cmd.none
    )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- VIEW


type alias Document msg =
    { title : String
    , body : List (Html msg)
    }


toUnstyledDocument : Document msg -> Browser.Document msg
toUnstyledDocument doc =
    { title = doc.title
    , body = List.map toUnstyled doc.body
    }


view : Model -> Document Msg
view model =
    { title = "Hello Goodbye"
    , body =
        [ main_ [ mainStyle ]
            [ h1 [] [ text model.greeting ]
            , div []
                [ button
                    [ onClick
                        (if model.greeting == "You say \"goodbye\"" then
                            Hello

                         else
                            Goodbye
                        )
                    ]
                    [ text "Click me! " ]
                ]
            , div
                [ css
                    [ displayFlex
                    , flexWrap Css.wrap
                    , justifyContent spaceAround
                    , Css.property "gap" "1rem"
                    ]
                ]
                [ div
                    [ css
                        [ flexGrow (int 0), maxWidth (px 480) ]
                    ]
                    (showMovie First (Tuple.first model.movies) (Tuple.first model.details))
                , div
                    [ css
                        [ flexGrow (int 0), maxWidth (px 480) ]

                    --, maxWidth (calc (pct 50) minus (rem 1)) ]
                    ]
                    (showMovie Second (Tuple.second model.movies) (Tuple.second model.details))
                ]
            , showCastSection model.movies model.details
            , dialogMovieSearch model
            , dialogCastMemberDetails model
            ]
        ]
    }
