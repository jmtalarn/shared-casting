module MovieSearch exposing (fetchCastMemberDetails, fetchData, fetchDetails)

import Http
import Json.Decode exposing (Decoder, andThen, at, bool, fail, field, float, int, list, map, map2, map3, oneOf, string, succeed)
import Json.Decode.Pipeline exposing (custom, optional, required)
import List
import Msg exposing (..)
import Platform.Cmd as Cmd
import String exposing (String)


movieTvShowDecoder : Decoder MovieTvShow
movieTvShowDecoder =
    succeed MovieTvShow
        |> required "id" int
        |> required "media_type" mediaTypeDecoder
        |> custom (oneOf [ field "title" string, field "name" string ])
        |> custom
            (oneOf
                [ field "release_date" (map (String.split "-" >> List.head >> Maybe.withDefault "1920") string)
                , field "first_air_date" (map (String.split "-" >> List.head >> Maybe.withDefault "1920") string)
                ]
            )
        |> custom descriptionDecoder
        |> required "popularity" float
        |> required "vote_average" float
        |> required "vote_count" int
        |> custom imagesDecoder
        |> optional "networks" (Json.Decode.list networkDecoder) []
        |> custom contentRatingsDecoder
        |> custom runtimeDecoder
        |> custom genresDecoder


imagesDecoder : Decoder Images
imagesDecoder =
    map3 (\poster backdrop logo -> Images poster backdrop logo)
        (field "poster_path" (Json.Decode.nullable string) |> Json.Decode.map (Maybe.map (\path -> "https://image.tmdb.org/t/p/original" ++ path)))
        (field "backdrop_path" (Json.Decode.nullable string) |> Json.Decode.map (Maybe.map (\path -> "https://image.tmdb.org/t/p/original" ++ path)))
        imagesLogoDecoder


imagesLogoDecoder : Decoder (Maybe String)
imagesLogoDecoder =
    oneOf
        [ at [ "images", "logos" ] (list logoDecoder)
            |> Json.Decode.map
                (\logos ->
                    logos
                        |> List.filter (\logo -> logo.iso_3166_1 == Just "US" || logo.iso_3166_1 == Nothing)
                        |> List.sortBy (\logo -> -logo.vote_average)
                        |> List.head
                        |> Maybe.map .file_path
                        |> Maybe.map (\path -> "https://image.tmdb.org/t/p/original" ++ path)
                )
        , succeed Nothing
        ]


type alias Logo =
    { iso_3166_1 : Maybe String
    , vote_average : Float
    , file_path : String
    }


logoDecoder : Decoder Logo
logoDecoder =
    succeed Logo
        |> required "iso_3166_1" (Json.Decode.nullable string)
        |> required "vote_average" float
        |> required "file_path" string


contentRatingsDecoder : Decoder (List ( String, String ))
contentRatingsDecoder =
    oneOf
        [ movieContentRatingsDecoder
        , -- Try to decode as TV (has content_ratings)
          tvContentRatingsDecoder
        , succeed []
        ]


tvContentRatingsDecoder : Decoder (List ( String, String ))
tvContentRatingsDecoder =
    at [ "content_ratings", "results" ] (list tvContentRatingItemDecoder)
        |> Json.Decode.map
            (\items ->
                items
                    |> List.filter
                        (\item ->
                            item.iso_3166_1
                                == Just "US"
                                || item.iso_3166_1
                                == Just "ES"
                                || item.iso_3166_1
                                == Nothing
                        )
                    |> List.map
                        (\item ->
                            ( Maybe.withDefault "" item.iso_3166_1, item.rating )
                        )
            )


type alias TvContentRatingItem =
    { iso_3166_1 : Maybe String
    , rating : String
    }


tvContentRatingItemDecoder : Decoder TvContentRatingItem
tvContentRatingItemDecoder =
    succeed TvContentRatingItem
        |> required "iso_3166_1" (Json.Decode.nullable string)
        |> required "rating" string


movieContentRatingsDecoder : Decoder (List ( String, String ))
movieContentRatingsDecoder =
    at [ "release_dates", "results" ] (list movieReleaseDateResultDecoder)
        |> Json.Decode.map
            (\results ->
                results
                    |> List.filter
                        (\result ->
                            result.iso_3166_1
                                == Just "US"
                                || result.iso_3166_1
                                == Just "ES"
                                || result.iso_3166_1
                                == Nothing
                        )
                    |> List.filterMap
                        (\result ->
                            result.release_dates
                                |> List.filter (\rd -> rd.type_ == 3)
                                |> List.head
                                |> Maybe.map
                                    (\rd ->
                                        ( Maybe.withDefault "" result.iso_3166_1, rd.certification )
                                    )
                        )
            )


type alias MovieReleaseDateResult =
    { iso_3166_1 : Maybe String
    , release_dates : List ReleaseDate
    }


type alias ReleaseDate =
    { certification : String
    , type_ : Int
    }


movieReleaseDateResultDecoder : Decoder MovieReleaseDateResult
movieReleaseDateResultDecoder =
    succeed MovieReleaseDateResult
        |> required "iso_3166_1" (Json.Decode.nullable string)
        |> required "release_dates" (list releaseDateDecoder)


releaseDateDecoder : Decoder ReleaseDate
releaseDateDecoder =
    succeed ReleaseDate
        |> required "certification" string
        |> required "type" int


runtimeDecoder : Decoder (Maybe Int)
runtimeDecoder =
    let
        nIsNothing n =
            if n == 0 then
                Nothing

            else
                Just n
    in
    oneOf
        [ field "runtime"
            (Json.Decode.nullable int
                |> Json.Decode.map
                    (Maybe.andThen nIsNothing)
            )
        , field "episode_runtime"
            (list int
                |> Json.Decode.map List.head
                |> Json.Decode.map
                    (Maybe.andThen nIsNothing)
            )
        , Json.Decode.at [ "last_episode_to_air", "runtime" ]
            (Json.Decode.nullable int
                |> Json.Decode.map
                    (Maybe.andThen nIsNothing)
            )
        , succeed Nothing
        ]


genresDecoder : Decoder (List String)
genresDecoder =
    oneOf
        [ field "genres" (list (field "name" string))
        , succeed []
        ]


descriptionDecoder : Decoder String
descriptionDecoder =
    oneOf [ field "description" string, field "overview" string ]



-- Add an extra field here


networkDecoder : Decoder Network
networkDecoder =
    Json.Decode.map2 Network
        (field "name" string)
        (field "logo_path" string |> Json.Decode.map (\path -> "https://image.tmdb.org/t/p/original" ++ path))


mediaTypeDecoder : Decoder MediaType
mediaTypeDecoder =
    string
        |> Json.Decode.andThen
            (\str ->
                case str of
                    "tv" ->
                        Json.Decode.succeed Tv

                    "movie" ->
                        Json.Decode.succeed Movie

                    _ ->
                        fail ("Invalid media type: " ++ str)
            )


mediaTypeToString : MediaType -> String
mediaTypeToString mediaType =
    case mediaType of
        Tv ->
            "tv"

        Movie ->
            "movie"


fetchData : Maybe String -> Cmd Msg
fetchData query =
    case query of
        Just value ->
            let
                trimmedValue =
                    String.trim value

                url =
                    "/search/" ++ trimmedValue
            in
            if String.isEmpty trimmedValue then
                Cmd.none

            else
                Http.get
                    { url = url
                    , expect = Http.expectJson ReceiveResults (Json.Decode.list movieTvShowDecoder)
                    }

        Nothing ->
            Cmd.none


fetchDetails : MovieIndex -> MovieTvShow -> Cmd Msg
fetchDetails index movieTvShow =
    let
        url =
            "/get/" ++ mediaTypeToString movieTvShow.mediaType ++ "/" ++ String.fromInt movieTvShow.id
    in
    Http.get
        { url = url
        , expect = Http.expectJson (ReceiveDetails index) detailsDecoder
        }


fetchCastMemberDetails : String -> Cmd Msg
fetchCastMemberDetails id =
    let
        url =
            "/people/" ++ id
    in
    Http.get
        { url = url
        , expect = Http.expectJson ReceiveCastMember castMemberDetailsDecoder
        }


creditsDecoder : Decoder (List CastMember)
creditsDecoder =
    oneOf
        [ Json.Decode.at [ "credits", "cast" ] (Json.Decode.list castMemberDecoder)
        , Json.Decode.at [ "aggregate_credits", "cast" ] (Json.Decode.list castMemberDecoder)
        ]


genderDecoder : Decoder Gender
genderDecoder =
    int
        |> Json.Decode.andThen
            (\n ->
                case n of
                    1 ->
                        Json.Decode.succeed Female

                    2 ->
                        Json.Decode.succeed Male

                    3 ->
                        Json.Decode.succeed NonBinary

                    _ ->
                        Json.Decode.succeed NotSpecified
            )


detailsDecoder : Decoder Details
detailsDecoder =
    succeed Details
        |> optional "networks" (Json.Decode.list networkDecoder) []
        |> custom contentRatingsDecoder
        |> custom runtimeDecoder
        |> custom genresDecoder
        |> custom imagesLogoDecoder
        |> custom creditsDecoder


castMemberDecoder : Decoder CastMember
castMemberDecoder =
    succeed CastMember
        |> required "id" int
        |> required "name" string
        |> required "original_name" string
        |> optional "profile_path" (Json.Decode.nullable string |> Json.Decode.map (Maybe.map (\path -> "https://image.tmdb.org/t/p/original" ++ path))) Nothing
        |> custom
            (oneOf
                [ field "character" string
                , field "roles" (Json.Decode.list (field "character" string) |> Json.Decode.map (String.join ", "))
                ]
            )
        |> required "gender" genderDecoder
        |> required "order" int


castMemberDetailsDecoder : Decoder CastMemberDetails
castMemberDetailsDecoder =
    succeed CastMemberDetails
        |> required "id" int
        |> required "name" string
        |> custom decodePrimaryTranslationName
        |> custom (at [ "images", "profiles" ] (Json.Decode.list (field "file_path" string |> Json.Decode.map (\path -> "https://image.tmdb.org/t/p/original" ++ path))))
        |> custom
            (at [ "combined_credits", "cast" ]
                (Json.Decode.list (Json.Decode.map2 (\movie character -> ( movie, character )) movieTvShowDecoder (field "character" string)))
            )
        |> required "biography" string
        |> required "gender" genderDecoder
        |> optional "birthday" (Json.Decode.nullable string) Nothing
        |> optional "place_of_birth" (Json.Decode.nullable string) Nothing
        |> optional "deathday" (Json.Decode.nullable string) Nothing


decodePrimaryTranslationName : Decoder String
decodePrimaryTranslationName =
    at [ "translations", "translations" ] (list (field "data" translationDataHelperDecoder))
        |> Json.Decode.map (getPrimaryTranslationName >> Maybe.withDefault "")


type alias TranslationDataHelper =
    { name : String
    , primary : Bool
    }



-- Extract the name of the first translation with primary = true


getPrimaryTranslationName : List TranslationDataHelper -> Maybe String
getPrimaryTranslationName translations =
    List.filter (\t -> t.primary) translations
        |> List.head
        |> Maybe.map .name


translationDataHelperDecoder : Decoder TranslationDataHelper
translationDataHelperDecoder =
    succeed TranslationDataHelper
        |> required "name" string
        |> required "primary" bool
