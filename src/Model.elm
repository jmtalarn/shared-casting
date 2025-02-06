module Model exposing (..)

import Gallery
import Msg exposing (..)


type alias Model =
    { greeting : String
    , targetMovieIndex : Maybe MovieIndex
    , query : Maybe String
    , debounceTask : Maybe (Cmd Msg)
    , searchResult : Maybe (List MovieTvShow)
    , movies : ( Maybe MovieTvShow, Maybe MovieTvShow )
    , details : ( Maybe Details, Maybe Details )
    , castMemberDetails : Maybe CastMemberDetails
    , imageGallery : Gallery.State
    , error : Maybe String
    }
