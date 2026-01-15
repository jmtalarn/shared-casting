module Msg exposing (AlsoInDirection(..), CastMember, CastMemberDetails, Details, Director, Gender(..), Images, MediaType(..), MovieIndex(..), MovieTvShow, Msg(..), NetworkOrProductionCompany, Review)

import Gallery
import Http


type alias NetworkOrProductionCompany =
    { name : String
    , logo : String
    }


type MediaType
    = Tv
    | Movie


type alias Images =
    { poster : Maybe String, backdrop : Maybe String, logo : Maybe String }


type alias MovieTvShow =
    { id : Int
    , mediaType : MediaType
    , title : String
    , year : String
    , description : String
    , popularity : Float
    , vote_average : Float
    , vote_count : Int
    , images : Images
    , networks : List NetworkOrProductionCompany
    , content_ratings : List ( String, String )
    , runtime : Maybe Int
    , genres : List String
    , directors : List Director
    }


type Cast
    = List CastMember


type Gender
    = NotSpecified
    | Female
    | Male
    | NonBinary


type alias Director =
    { name : String, profile_path : Maybe String }


type alias Review =
    { author : String
    , avatar_path : Maybe String
    , content : String
    }


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
    { networks : List NetworkOrProductionCompany
    , content_ratings : List ( String, String )
    , runtime : Maybe Int
    , genres : List String
    , logo : Maybe String
    , cast : List CastMember
    , directors : List Director
    , reviews : List Review
    }


type AlsoInDirection
    = Backward
    | Forward


type MovieIndex
    = First
    | Second


type Msg
    = ShowSearch MovieIndex
    | ReceiveResults (Result Http.Error (List MovieTvShow))
    | ReceiveDetails MovieIndex (Result Http.Error Details)
    | ShowCastMember Int
    | ImageGalleryMsg Gallery.Msg
    | ReceiveCastMember (Result Http.Error CastMemberDetails)
    | HideDialog String
    | Scroll AlsoInDirection
    | FocusOnInput
    | NoOp
    | InputChanged String
    | DebouncedSearch
    | SelectItem MovieTvShow
    | ShowMovieDetails MovieIndex
    | ToggleCastExpansion MovieIndex
