module Main exposing (main)

import Browser
import Css exposing (..)
import Gallery
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import Html.Styled.Events exposing (..)
import Model exposing (Model)
import Msg exposing (..)
import Phosphor exposing (IconWeight(..))
import Title exposing (svgTitle)
import Update exposing (update)
import View exposing (dialogCastMemberDetails, dialogMovieSearch, footerBand, mainStyle, pageHeader, showCastSection, showMovie, twoColumnsCssLayout)



-- Define the port
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
    { title = "Shared Cast"
    , body =
        [ main_ [ mainStyle ]
            [ pageHeader
            , div
                [ css
                    twoColumnsCssLayout
                ]
                [ div
                    [ css
                        [ flexGrow (int 0)
                        , Css.width (px 480)

                        --, minWidth (px 480)
                        , maxWidth (px 480)
                        , padding (px 8)
                        ]
                    ]
                    (showMovie First (Tuple.first model.movies) (Tuple.first model.details))
                , div
                    [ css
                        [ flexGrow (int 0)
                        , Css.width (px 480)

                        --, minWidth (px 480)
                        , maxWidth (px 480)
                        , padding (px 8)
                        ]
                    ]
                    (showMovie Second (Tuple.second model.movies) (Tuple.second model.details))
                ]
            , showCastSection model.movies model.details
            , dialogMovieSearch model
            , dialogCastMemberDetails model
            ]
        , footerBand
        ]
    }
