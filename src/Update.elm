port module Update exposing (..)

import Browser.Dom as Dom
import Gallery
import Http
import Model exposing (Model)
import MovieSearch exposing (fetchCastMemberDetails, fetchData, fetchDetails)
import Msg exposing (MovieIndex(..), MovieTvShow, Msg(..))
import Process
import Task
import View exposing (dialogCastMemberDetailsId, dialogMovieSearchId, dialogMovieSearchInputId, imageSlides)



-- Define the port


port toggleDialog : String -> Cmd msg



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Hello ->
            ( { model | greeting = "I say \"hello\"" }, Cmd.none )

        Goodbye ->
            ( { model | greeting = "You say \"goodbye\"" }, Cmd.none )

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
                updatedModel =
                    { model
                        | details =
                            case movieIndex of
                                First ->
                                    ( Just details, Tuple.second model.details )

                                Second ->
                                    ( Tuple.first model.details, Just details )
                        , error = Nothing
                    }
            in
            ( cleanDialogData updatedModel, toggleDialog ("#" ++ dialogMovieSearchId) )

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
                        , targetMovieIndex = Nothing
                    }
            in
            case model.targetMovieIndex of
                Just index ->
                    ( updatedModel, fetchDetails index movie )

                Nothing ->
                    ( model, Cmd.none )

        ShowCastMember id ->
            ( model, fetchCastMemberDetails <| String.fromInt id )

        ImageGalleryMsg imageGalleryMsg ->
            ( { model | imageGallery = Gallery.update imageGalleryMsg model.imageGallery }
            , Cmd.none
            )


cleanDialogData : Model -> Model
cleanDialogData model =
    { model
        | query = Nothing
        , searchResult = Nothing
        , targetMovieIndex = Nothing
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
