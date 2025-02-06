module Msg exposing (CastMember, CastMemberDetails, Details, Gender(..), MediaType(..), MovieIndex(..), MovieTvShow, Msg(..), Network)

import Gallery
import Http


type alias Network =
    { name : String
    , logo : String
    }


type MediaType
    = Tv
    | Movie


type alias MovieTvShow =
    { id : Int
    , mediaType : MediaType
    , title : String
    , year : String
    , description : String
    , popularity : Float
    , vote_average : Float
    , vote_count : Int
    , images : ( Maybe String, Maybe String )
    , networks : List Network
    }


type Cast
    = List CastMember


type Gender
    = NotSpecified
    | Female
    | Male
    | NonBinary


type alias CastMember =
    { id : Int
    , name : String
    , original_name : String
    , profile_path : Maybe String
    , character : String
    , gender : Gender
    , order : Int
    }


type alias CastMemberDetails =
    { id : Int
    , name : String
    , original_name : String
    , images : List String
    , cast : List ( MovieTvShow, String )
    , biography : String
    , gender : Gender
    , birthday : Maybe String
    , place_of_birth : Maybe String
    , deathday : Maybe String
    }


type alias Details =
    { networks : List Network
    , cast : List CastMember
    }


type MovieIndex
    = First
    | Second


type Msg
    = Hello
    | Goodbye
    | ShowSearch MovieIndex
    | ReceiveResults (Result Http.Error (List MovieTvShow))
    | ReceiveDetails MovieIndex (Result Http.Error Details)
    | ShowCastMember Int
    | ImageGalleryMsg Gallery.Msg
    | ReceiveCastMember (Result Http.Error CastMemberDetails)
    | HideDialog String
    | FocusOnInput
    | NoOp
    | InputChanged String
    | DebouncedSearch
    | SelectItem MovieTvShow
