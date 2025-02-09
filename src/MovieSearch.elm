module MovieSearch exposing (fetchCastMemberDetails, fetchData, fetchDetails)

import Http
import Json.Decode exposing (Decoder, at, bool, fail, field, float, int, list, map, map2, oneOf, string, succeed)
import Json.Decode.Pipeline exposing (custom, optional, required)
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


imagesDecoder : Decoder ( Maybe String, Maybe String )
imagesDecoder =
    map2 (\img1 img2 -> ( img1, img2 ))
        (field "poster_path" (Json.Decode.nullable string) |> Json.Decode.map (Maybe.map (\path -> "https://image.tmdb.org/t/p/original" ++ path)))
        (field "backdrop_path" (Json.Decode.nullable string) |> Json.Decode.map (Maybe.map (\path -> "https://image.tmdb.org/t/p/original" ++ path)))


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
