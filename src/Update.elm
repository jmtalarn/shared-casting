port module Update exposing (..)

import Browser.Dom as Dom
import Gallery
import Http
import Model exposing (Model)
import MovieSearch exposing (fetchCastMemberDetails, fetchData, fetchDetails)
import Msg exposing (AlsoInDirection(..), MovieIndex(..), MovieTvShow, Msg(..))
import Process
import Task
import View exposing (castMemberDetailsAlsoInId, dialogCastMemberDetailsId, dialogMovieSearchId, dialogMovieSearchInputId)



-- Define the port


port toggleDialog : String -> Cmd msg


port scroll : ( String, Int ) -> Cmd msg



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ReceiveResults (Ok result) ->
            ( { model
                | searchResult = Just (List.sortBy sortValue result |> List.reverse)
                , error = Nothing
              }
            , Cmd.none
            )

        ReceiveResults (Err err) ->
            ( { model
                | error = Just (httpErrorToString err)
              }
            , Cmd.none
            )

        ReceiveDetails movieIndex (Ok details) ->
            let
                _ =
                    Debug.log "details" details

                updateMovieWithDetails : Maybe MovieTvShow -> Maybe MovieTvShow
                updateMovieWithDetails maybeMovie =
                    case maybeMovie of
                        Just movie ->
                            Just
                                { movie
                                    | networks = details.networks
                                    , content_ratings = details.content_ratings
                                    , runtime = details.runtime
                                    , genres = details.genres
                                    , images =
                                        { poster = movie.images.poster
                                        , backdrop = movie.images.backdrop
                                        , logo = details.logo
                                        }
                                }

                        Nothing ->
                            Nothing

                updatedMovies =
                    case movieIndex of
                        First ->
                            ( updateMovieWithDetails (Tuple.first model.movies)
                            , Tuple.second model.movies
                            )

                        Second ->
                            ( Tuple.first model.movies
                            , updateMovieWithDetails (Tuple.second model.movies)
                            )

                updatedModel =
                    { model
                        | details =
                            case movieIndex of
                                First ->
                                    ( Just details, Tuple.second model.details )

                                Second ->
                                    ( Tuple.first model.details, Just details )
                        , movies = updatedMovies
                        , error = Nothing
                    }
            in
            ( cleanDialogData updatedModel
            , case model.openedDialog of
                Just id ->
                    toggleDialog ("#" ++ id)

                Nothing ->
                    Cmd.none
            )

        ReceiveDetails movieIndex (Err err) ->
            ( { model
                | error = Just (httpErrorToString err)
                , details =
                    case movieIndex of
                        First ->
                            ( Nothing, Tuple.second model.details )

                        Second ->
                            ( Tuple.first model.details, Nothing )
              }
            , Cmd.none
            )

        ReceiveCastMember (Ok castMemberDetails) ->
            ( { model
                | castMemberDetails = Just castMemberDetails
                , imageGallery = Gallery.init (List.length castMemberDetails.images)
                , error = Nothing
              }
            , toggleDialog ("#" ++ dialogCastMemberDetailsId)
            )

        ReceiveCastMember (Err err) ->
            ( { model
                | error = Just (httpErrorToString err)
                , castMemberDetails = Nothing
              }
            , toggleDialog ("#" ++ dialogCastMemberDetailsId)
            )

        ShowSearch movieIndex ->
            ( { model
                | targetMovieIndex = Just movieIndex
                , openedDialog = Just dialogMovieSearchId
              }
            , Cmd.batch [ toggleDialog ("#" ++ dialogMovieSearchId), Task.attempt (\_ -> NoOp) (Dom.focus dialogMovieSearchInputId) ]
            )

        HideDialog dialogId ->
            ( cleanDialogData model
            , toggleDialog ("#" ++ dialogId)
            )

        FocusOnInput ->
            ( model, Task.attempt (\_ -> NoOp) (Dom.focus dialogMovieSearchInputId) )

        NoOp ->
            ( model, Cmd.none )

        InputChanged newQuery ->
            let
                debounce =
                    Task.perform (always DebouncedSearch) (Process.sleep 1000)

                newQueryValue =
                    case newQuery of
                        "" ->
                            Nothing

                        value ->
                            Just value
            in
            ( { model
                | query = newQueryValue
                , debounceTask = Just debounce
                , searchResult =
                    case newQueryValue of
                        Nothing ->
                            Maybe.map identity Nothing

                        _ ->
                            model.searchResult
                , error =
                    case newQueryValue of
                        Nothing ->
                            Maybe.map identity Nothing

                        _ ->
                            model.error
              }
            , debounce
            )

        DebouncedSearch ->
            ( model, fetchData model.query )

        SelectItem movie ->
            let
                currentIndex =
                    model.targetMovieIndex

                updatedModel =
                    { model
                        | movies =
                            case model.targetMovieIndex of
                                Just First ->
                                    ( Just movie, Tuple.second model.movies )

                                Just Second ->
                                    ( Tuple.first model.movies, Just movie )

                                Nothing ->
                                    model.movies
                        , targetMovieIndex =
                            case model.targetMovieIndex of
                                Just First ->
                                    Just Second

                                _ ->
                                    Just First
                    }
            in
            case currentIndex of
                Just index ->
                    ( updatedModel, fetchDetails index movie )

                Nothing ->
                    ( model, Cmd.none )

        ShowCastMember id ->
            ( { model | openedDialog = Just dialogCastMemberDetailsId }, fetchCastMemberDetails <| String.fromInt id )

        ImageGalleryMsg imageGalleryMsg ->
            ( { model | imageGallery = Gallery.update imageGalleryMsg model.imageGallery }
            , Cmd.none
            )

        Scroll direction ->
            let
                scrollAmount =
                    case direction of
                        Forward ->
                            120 + 16

                        Backward ->
                            -(120 + 16)
            in
            ( model, scroll ( castMemberDetailsAlsoInId, scrollAmount ) )


cleanDialogData : Model -> Model
cleanDialogData model =
    { model
        | query = Nothing
        , searchResult = Nothing
        , openedDialog = Nothing

        --, targetMovieIndex = Nothing
        , castMemberDetails = Nothing
        , error = Nothing
    }


sortValue : MovieTvShow -> Float
sortValue media =
    let
        { popularity, vote_average, vote_count } =
            media

        wP =
            1.5

        -- Weight for popularity
        wA =
            6.0

        -- Weight for vote average
        wC =
            2.5

        -- Weight for vote count
        voteScore =
            wA * (vote_average * toFloat vote_count)

        voteCountWeight =
            wC * sqrt (toFloat vote_count)

        popularityWeight =
            wP * sqrt popularity

        -- Scales votes in a logarithmic way
    in
    (voteScore + voteCountWeight + popularityWeight) / (1 + toFloat vote_count)


httpErrorToString : Http.Error -> String
httpErrorToString error =
    case error of
        Http.BadUrl url ->
            "Bad URL: " ++ url

        Http.Timeout ->
            "Request timed out"

        Http.NetworkError ->
            "Network error"

        Http.BadStatus status ->
            "Bad status: " ++ String.fromInt status

        Http.BadBody body ->
            "Bad body: " ++ body
