module View exposing (..)

import Css exposing (..)
import Css.Global
import Css.Transitions exposing (ease, transition)
import Gallery
import Gallery.Image as GalleryImage
import Html
import Html.Attributes
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import Html.Styled.Events exposing (..)
import Model exposing (Model)
import Msg exposing (..)
import Phosphor exposing (IconWeight(..))
import Styling.Colors as Colors
import Styling.Theme exposing (theme)
import VitePluginHelper


showSharedCast : List CastMember -> ( Maybe MovieTvShow, Maybe MovieTvShow ) -> ( Maybe Details, Maybe Details ) -> Html Msg
showSharedCast sharedCast ( maybeFirstMovieTvShow, maybeSecondMovieTvShow ) ( maybeFirstDetails, maybeSecondDetails ) =
    div
        []
        (List.map
            (\castMember -> showSharedCastMember castMember ( maybeFirstMovieTvShow, maybeSecondMovieTvShow ) ( maybeFirstDetails, maybeSecondDetails ))
            sharedCast
        )


showCast : List CastMember -> Html Msg
showCast cast =
    div
        []
        (List.map
            showCastMember
            cast
        )


mediaTypeLabel : MediaType -> String
mediaTypeLabel mediaType =
    case mediaType of
        Tv ->
            " (TV Show)"

        Movie ->
            " (Movie)"


showMovie : MovieIndex -> Maybe MovieTvShow -> Maybe Details -> List (Html Msg)
showMovie movieIndex maybeMovieTvShow maybeDetails =
    let
        networks =
            case maybeDetails of
                Just details ->
                    details.networks

                Nothing ->
                    []
    in
    movieTvShowCover movieIndex maybeMovieTvShow
        :: (case maybeMovieTvShow of
                Just movieTvShow ->
                    [ div [ css [ margin2 (px 16) (px 0) ] ]
                        [ h2
                            [ css
                                [ Css.height (px 64) ]
                            ]
                            [ text (.title movieTvShow) ]
                        , div
                            [ css
                                [ displayFlex
                                , alignItems center
                                , justifyContent spaceBetween
                                , margin2 (px 4) (px 0)
                                ]
                            ]
                            [ div
                                [ css [ color theme.colors.text ] ]
                                [ span [] [ text movieTvShow.year ]
                                , span [ css [ fontSize (px 12), color theme.colors.textMuted ] ]
                                    [ text <| mediaTypeLabel movieTvShow.mediaType
                                    ]
                                ]
                            , div
                                [ css
                                    [ displayFlex
                                    , alignItems center
                                    , Css.property "gap" "1rem"
                                    , Css.property "filter" "brightness(0) invert(1) drop-shadow(4px 4px 4px black)"
                                    ]
                                ]
                                (List.map
                                    (\network ->
                                        div
                                            [ css
                                                [ Css.display inlineBlock
                                                , margin2
                                                    (px 4)
                                                    (px 0)
                                                , displayFlex
                                                , alignItems center
                                                ]
                                            ]
                                            [ img
                                                [ src network.logo
                                                , title network.name
                                                , css
                                                    [ Css.height (px 24)
                                                    , Css.width auto
                                                    ]
                                                ]
                                                []
                                            ]
                                    )
                                    networks
                                )
                            ]
                        ]
                    , p
                        [ css
                            [ color theme.colors.textMuted
                            , marginBottom (px 16)
                            ]
                        ]
                        [ text (.description movieTvShow)
                        ]
                    ]

                Nothing ->
                    []
           )


dialogMovieSearch : Model -> Html Msg
dialogMovieSearch model =
    section []
        [ node "dialog"
            [ css
                [ pseudoElement "backdrop"
                    [ backgroundColor <| rgba 0 0 0 0.4
                    , Css.property "-webkit-backdrop-filter" "blur(2px)"
                    , Css.property "backdrop-filter" "blur(2px)"
                    , zIndex (int 1)
                    ]
                , zIndex (int 2)
                , position fixed
                , top (pct 5)
                , Css.width (pct 90)
                , maxWidth (px 840)
                , maxHeight (pct 90)

                --, Css.height (pct 70)
                , theme.shadows.lg Nothing
                , borderRadius (px 15)
                , borderStyle Css.none
                , margin2 (px 0) auto
                , backgroundColor theme.colors.surfaceDark
                , color theme.colors.text
                , overflow Css.hidden
                ]
            , id dialogMovieSearchId
            ]
            [ div
                [ css
                    []
                ]
                [ div
                    [ css
                        [ displayFlex
                        , alignItems center
                        , justifyContent end
                        , padding (px 4)
                        , Css.height (px 64)
                        ]
                    ]
                    [ button
                        [ onClick <| HideDialog dialogMovieSearchId
                        , css
                            [ backgroundColor Colors.transparent
                            , borderStyle none
                            , color theme.colors.error
                            , cursor pointer
                            , margin (px 10)
                            , hover
                                [ Css.Global.descendants
                                    [ Css.Global.typeSelector "svg"
                                        [ Css.property "filter" "drop-shadow(2px 2px 2px rgba(0,0,0,0.9))" ]
                                    ]
                                ]
                            ]
                        ]
                        [ Html.Styled.fromUnstyled
                            (Phosphor.x Regular |> Phosphor.toHtml [ Html.Attributes.style "width" "36px", Html.Attributes.style "height" "36px" ])
                        ]
                    ]
                , div
                    [ css
                        [ displayFlex
                        , alignItems center
                        , justifyContent spaceAround
                        , padding2 (px 4) (px 16)
                        , Css.height (px 64)
                        ]
                    ]
                    [ input
                        [ placeholder hintText
                        , id dialogMovieSearchInputId
                        , css
                            ([ padding (px 12)
                             , margin (px 8)
                             , Css.width (pct 100)
                             , borderRadius (px 8)
                             , borderWidth (px 1)
                             ]
                                ++ theme.fonts.input
                            )
                        , value
                            (case model.query of
                                Just text ->
                                    text

                                Nothing ->
                                    ""
                            )
                        , onInput InputChanged
                        ]
                        []
                    , span [ css [ color theme.colors.primary ] ]
                        [ Html.Styled.fromUnstyled
                            (Phosphor.magnifyingGlass Duotone
                                |> Phosphor.toHtml
                                    [ Html.Attributes.style "margin" "8px"
                                    , Html.Attributes.style "width" "24px"
                                    , Html.Attributes.style "height" "24px"
                                    ]
                            )
                        ]
                    ]
                , case model.error of
                    Just errorMessage ->
                        div
                            [ css
                                [ minHeight (px 64), padding (px 64), maxHeight <| Css.calc (vh 90) minus (calc (px 64) plus (px 64)), overflow auto ]
                            ]
                            [ h3 [ css [ color theme.colors.error, textAlign center ] ] [ text "Error" ]
                            , p
                                [ css (theme.fonts.error ++ [ marginTop (px 18) ]) ]
                                [ text errorMessage
                                ]
                            ]

                    Nothing ->
                        div [ css [ minHeight (px 64), Css.maxHeight <| Css.calc (vh 90) minus (calc (px 64) plus (px 64)), overflowY auto ] ] [ showResults model.searchResult ]
                ]
            ]
        ]


showResults : Maybe (List MovieTvShow) -> Html Msg
showResults movieTvShowList =
    case movieTvShowList of
        Just results ->
            let
                resultListStyle =
                    css
                        [ Css.width (pct 100)
                        , marginTop (px 8)
                        , padding (px 4)
                        , listStyleType none
                        , displayFlex
                        , flexDirection column
                        ]
            in
            ul
                [ resultListStyle ]
                (List.map viewItem results)

        Nothing ->
            p [] []


viewItem : MovieTvShow -> Html Msg
viewItem item =
    let
        resultItemStyle =
            css
                [ borderRadius (px 8)
                , cursor pointer
                , hover [ backgroundColor Styling.Theme.theme.colors.surface, theme.shadows.lg <| Just theme.colors.primary ]
                , transition
                    [ Css.Transitions.backgroundColor3 300 0 ease
                    , Css.Transitions.boxShadow3 300 0 ease
                    , Css.Transitions.filter3 300 0 ease
                    ]
                , zIndex (int 1)
                , margin2 (px 4) (px 16)
                , padding (px 8)
                ]

        ( cover, _ ) =
            item.images
    in
    li
        [ resultItemStyle
        , onClick (SelectItem item)
        ]
        [ div
            [ css
                [ displayFlex
                , flexDirection row
                , flexWrap Css.wrap
                ]
            ]
            [ div
                [ css [ displayFlex, padding (px 8), flexDirection column ] ]
                [ div
                    [ css [ displayFlex, flexDirection row ] ]
                    [ img
                        [ src (Maybe.withDefault (VitePluginHelper.asset "/src/assets/generic-cinema.jpg") cover)
                        , css
                            [ Css.width auto
                            , Css.height (px 200)
                            , marginRight (px 12)
                            , borderRadius (px 4)
                            ]
                        ]
                        []
                    , div
                        [ css [ displayFlex, flexDirection column, justifyContent Css.start ] ]
                        [ h3 [ css [ marginBottom (px 8) ] ]
                            [ text <| item.title ]
                        , div [ css [ marginBottom (px 8) ] ]
                            [ span [] [ text item.year ]
                            , span [ css [ fontSize (px 12) ] ]
                                [ text <| mediaTypeLabel item.mediaType
                                ]
                            ]

                        -- , div [ css [] ] (List.map (\imgSvg -> img [ src imgSvg.logo ] []) item.networks)
                        , p [ css [ marginTop (px 8), color theme.colors.textMuted, fontSize (px 12), maxWidth (px 480), marginTop auto, marginBottom (px 32) ] ] [ text item.description ]
                        ]
                    ]
                ]
            ]
        ]


formatCharacter : String -> Maybe String -> Html msg
formatCharacter character maybeMovieTitle =
    div [ css [ color theme.colors.textMuted ] ]
        ([ span [ css [ fontStyle italic ] ] [ text "as " ]
         , span [ css [ fontWeight Css.bold ] ] [ text character ]
         ]
            ++ (case maybeMovieTitle of
                    Just movieTitle ->
                        [ span [] [ text " in " ]
                        , span [ css [ fontWeight Css.bold, fontStyle italic ] ] [ text movieTitle ]
                        ]

                    Nothing ->
                        []
               )
        )


showSharedCastMember : CastMember -> ( Maybe MovieTvShow, Maybe MovieTvShow ) -> ( Maybe Details, Maybe Details ) -> Html Msg
showSharedCastMember member ( maybeFirstMovieTvShow, maybeSecondMovieTvShow ) ( maybeFirstDetails, maybeSecondDetails ) =
    let
        firstMovie =
            Maybe.withDefault defaultMovieTvShow maybeFirstMovieTvShow

        secondMovie =
            Maybe.withDefault defaultMovieTvShow maybeSecondMovieTvShow

        showMediaType =
            firstMovie.title == secondMovie.title

        firstMovieTitle =
            firstMovie.title
                ++ (if showMediaType then
                        " " ++ mediaTypeLabel firstMovie.mediaType

                    else
                        ""
                   )

        secondMovieTitle =
            secondMovie.title
                ++ (if showMediaType then
                        " " ++ mediaTypeLabel secondMovie.mediaType

                    else
                        ""
                   )

        characterFirst =
            formatCharacter (Maybe.withDefault "uncredited" (Maybe.map .character (List.head (List.filter (\c -> c.id == member.id) (Maybe.withDefault defaultDetails maybeFirstDetails).cast)))) (Just firstMovieTitle)

        characterSecond =
            formatCharacter (Maybe.withDefault "uncredited" (Maybe.map .character (List.head (List.filter (\c -> c.id == member.id) (Maybe.withDefault defaultDetails maybeSecondDetails).cast)))) (Just secondMovieTitle)

        characters =
            [ characterFirst
            , characterSecond
            ]
    in
    showCastMemberView member characters


showCastMember : CastMember -> Html Msg
showCastMember castMember =
    showCastMemberView castMember <| [ div [ css [ color theme.colors.text ] ] [ formatCharacter castMember.character Nothing ] ]


showCastMemberView : CastMember -> List (Html Msg) -> Html Msg
showCastMemberView castMember characters =
    let
        name =
            castMember.name
                ++ (if castMember.name == castMember.original_name then
                        ""

                    else
                        " (" ++ castMember.original_name ++ ")"
                   )

        backgroundImagePath =
            [ case castMember.profile_path of
                Just path ->
                    backgroundImage (url path)

                Nothing ->
                    backgroundImage (url <| VitePluginHelper.asset "/src/assets/profile.png")
            , backgroundSize (pct 100)
            , backgroundRepeat noRepeat
            , backgroundPosition2 (pct 50) (pct 0)
            ]
    in
    button
        [ css
            [ displayFlex
            , padding (px 8)
            , Css.property "gap" "8px"
            , borderRadius (px 8)
            , borderStyle none
            , margin2 (px 4) (px 0)
            , backgroundColor Colors.transparent
            , Css.width (pct 100)
            , cursor pointer
            , hover [ backgroundColor Styling.Theme.theme.colors.surface, theme.shadows.lg <| Just theme.colors.primary ]
            , transition
                [ Css.Transitions.backgroundColor3 300 0 ease
                , Css.Transitions.boxShadow3 300 0 ease
                , Css.Transitions.filter3 300 0 ease
                ]
            , zIndex (int 1)
            ]
        , onClick <| ShowCastMember castMember.id
        ]
        [ div
            [ css
                ([ borderRadius (pct 50)
                 , Css.width
                    (px 72)
                 , Css.height (px 72)
                 , overflow Css.hidden
                 ]
                    ++ backgroundImagePath
                )
            , class "profile-image"
            ]
            []
        , div [ css [ displayFlex, flexDirection column, padding (px 8), Css.property "gap" "4px", alignItems Css.start ] ]
            (h4
                [ css [ color theme.colors.text ] ]
                [ text name ]
                :: characters
            )
        ]


showCastSection : ( Maybe MovieTvShow, Maybe MovieTvShow ) -> ( Maybe Details, Maybe Details ) -> Html Msg
showCastSection ( maybeFirstMovieTvShow, maybeSecondMovieTvShow ) ( maybeFirstDetails, maybeSecondDetails ) =
    let
        showCastColumnStyles additionalCss =
            css
                ([ minWidth (px 220)
                 , maxWidth (px 480)
                 , marginBottom (rem 2)
                 ]
                    ++ Maybe.withDefault [] additionalCss
                )

        firstMovieTvShow =
            Maybe.withDefault defaultMovieTvShow maybeFirstMovieTvShow

        secondMovieTvShow =
            Maybe.withDefault defaultMovieTvShow maybeSecondMovieTvShow

        firstDetails =
            Maybe.withDefault defaultDetails maybeFirstDetails

        secondDetails =
            Maybe.withDefault defaultDetails maybeSecondDetails

        ( sharedCast, firstCast, secondCast ) =
            sharedCastMembers firstDetails.cast secondDetails.cast

        showCastColumn =
            \cast title ->
                div
                    [ showCastColumnStyles Nothing
                    ]
                    (if not <| List.isEmpty cast then
                        [ h3 [ css [ Css.height (px 58) ] ] [ text ("Cast for " ++ title) ]
                        , showCast cast
                        ]

                     else
                        []
                    )

        showSharedCastColumn =
            \sharedCastC title ( maybeFirstMovieTvShowC, maybeSecondMovieTvShowC ) ( maybeFirstDetailsC, maybeSecondDetailsC ) ->
                div
                    [ showCastColumnStyles (Just [ maxWidth (pct 100) ])
                    ]
                    (if not <| List.isEmpty sharedCastC then
                        [ h3 [ css [ Css.height (px 58) ] ] [ text ("Cast for " ++ title) ]
                        , showSharedCast sharedCastC ( maybeFirstMovieTvShowC, maybeSecondMovieTvShowC ) ( maybeFirstDetailsC, maybeSecondDetailsC )
                        ]

                     else
                        []
                    )

        showMediaType =
            firstMovieTvShow.title == secondMovieTvShow.title

        firstMovieTitle =
            firstMovieTvShow.title
                ++ (if showMediaType then
                        " " ++ mediaTypeLabel firstMovieTvShow.mediaType

                    else
                        ""
                   )

        secondMovieTitle =
            secondMovieTvShow.title
                ++ (if showMediaType then
                        " " ++ mediaTypeLabel secondMovieTvShow.mediaType

                    else
                        ""
                   )

        firstColumn =
            if List.isEmpty firstCast then
                []

            else
                [ showCastColumn firstCast firstMovieTitle ]

        secondColumn =
            if List.isEmpty secondCast then
                []

            else
                [ showCastColumn secondCast secondMovieTitle ]
    in
    section []
        [ div [ css [ margin2 (rem 1) auto, displayFlex, alignItems center, flexDirection column ] ]
            (if not <| List.isEmpty sharedCast then
                [ showSharedCastColumn sharedCast "both" ( maybeFirstMovieTvShow, maybeSecondMovieTvShow ) ( maybeFirstDetails, maybeSecondDetails )
                ]

             else
                []
            )
        , div
            [ css
                [ displayFlex
                , flexWrap Css.wrap
                , justifyContent spaceAround
                , Css.property "gap" "1rem"
                ]
            ]
            (firstColumn ++ secondColumn)
        ]


sharedCastMembers : List CastMember -> List CastMember -> ( List CastMember, List CastMember, List CastMember )
sharedCastMembers listA listB =
    let
        shared =
            List.filter (\castMember -> List.any (\b -> b.id == castMember.id) listB) listA

        firstCast =
            List.filter (\castMember -> not (List.any (\sharedMember -> sharedMember.id == castMember.id) shared)) listA

        secondCast =
            List.filter (\castMember -> not (List.any (\sharedMember -> sharedMember.id == castMember.id) shared)) listB

        _ =
            Debug.log "shared" shared
    in
    ( shared, firstCast, secondCast )


hintText : String
hintText =
    "Click to search for a movie or a TV Show"


movieTvShowCover : MovieIndex -> Maybe MovieTvShow -> Html Msg
movieTvShowCover index maybeMovieTvShow =
    let
        defaultCover =
            VitePluginHelper.asset "/src/assets/generic-cinema.jpg"

        cover =
            case maybeMovieTvShow of
                Just movieTvShow ->
                    case Tuple.first movieTvShow.images of
                        Just url ->
                            url

                        Nothing ->
                            defaultCover

                Nothing ->
                    defaultCover
    in
    div [ css [ displayFlex, alignItems center, justifyContent center ] ]
        [ button
            [ css
                [ cursor pointer
                , borderRadius (px 4)
                , borderStyle none
                , Css.width (px 220)
                , Css.height (px 330)
                , position relative
                , flexShrink (int 0)
                , hover
                    [ Css.Global.descendants
                        [ Css.Global.typeSelector "img"
                            [ Css.Global.withClass "cover"
                                [ transform (scale 1.2)
                                , Css.property "filter" "brightness(0.50)"
                                ]
                            ]
                        , Css.Global.typeSelector "div"
                            [ Css.Global.withClass "hint"
                                [ opacity (num 1)
                                , transform (scale 1)
                                ]
                            ]
                        ]
                    , zIndex (int 1)
                    ]
                ]
            , title hintText
            , onClick (ShowSearch index)
            ]
            [ img
                [ class "cover"
                , src <| cover
                , css
                    [ borderRadius (px 4)
                    , transform (scale 1)
                    , transition
                        [ Css.Transitions.transform3 300 0 ease
                        , Css.Transitions.filter3 300 0 ease
                        ]
                    ]
                ]
                []
            , div
                [ class "hint"
                , css
                    (theme.fonts.body
                        ++ [ position absolute
                           , displayFlex
                           , flexDirection column
                           , alignItems center
                           , fontWeight bold
                           , Css.width (pct 100)
                           , Css.height (pct 100)
                           , top (px 0)
                           , transform (scale 0)
                           , opacity (num 0)
                           , transition
                                [ Css.Transitions.opacity3 300 0 ease
                                , Css.Transitions.transform3 300 0 ease
                                ]
                           ]
                    )
                ]
                [ Html.Styled.fromUnstyled
                    (Phosphor.magnifyingGlass Duotone
                        |> Phosphor.toHtml
                            [ Html.Attributes.style "width" "80%"
                            , Html.Attributes.style "height" "80%"
                            , Html.Attributes.style "margin" "0 auto"
                            , Html.Attributes.style "color" "white"
                            ]
                    )
                , p [ css [ color Colors.white ] ] [ text hintText ]
                ]
            ]
        ]


dialogMovieSearchId : String
dialogMovieSearchId =
    "movie-search"


dialogCastMemberDetailsId : String
dialogCastMemberDetailsId =
    "cast-member"


dialogMovieSearchInputId : String
dialogMovieSearchInputId =
    "movie-search-input"


defaultDetails : Details
defaultDetails =
    { cast = []
    , networks = []
    }


defaultMovieTvShow : MovieTvShow
defaultMovieTvShow =
    { id = 0
    , title = ""
    , year = ""
    , description = ""
    , images = ( Nothing, Nothing )
    , networks = []
    , mediaType = Movie
    , popularity = 0
    , vote_average = 0
    , vote_count = 0
    }


mainStyle : Attribute msg
mainStyle =
    css
        [ backgroundColor theme.colors.surface
        , color theme.colors.text
        , minHeight (Css.pct 100)
        ]


dialogCastMemberDetails : Model -> Html Msg
dialogCastMemberDetails model =
    let
        maybeCastMember =
            model.castMemberDetails
    in
    section []
        [ node "dialog"
            [ css
                [ pseudoElement "backdrop"
                    [ backgroundColor <| rgba 0 0 0 0.4
                    , Css.property "-webkit-backdrop-filter" "blur(2px)"
                    , Css.property "backdrop-filter" "blur(2px)"
                    , zIndex (int 1)
                    ]
                , zIndex (int 2)
                , position fixed
                , top (pct 5)
                , Css.width (pct 90)

                --, maxWidth (px 840)
                , maxHeight (pct 90)

                --, Css.height (pct 70)
                , theme.shadows.lg Nothing
                , borderRadius (px 15)
                , borderStyle Css.none
                , margin2 (px 0) auto
                , backgroundColor theme.colors.surfaceDark
                , color theme.colors.text
                , overflow Css.hidden
                ]
            , id dialogCastMemberDetailsId
            ]
            [ div
                [ css
                    []
                ]
                [ div
                    [ css
                        [ displayFlex
                        , alignItems center
                        , justifyContent end
                        , padding (px 4)
                        , Css.height (px 64)
                        ]
                    ]
                    [ button
                        [ onClick <| HideDialog dialogCastMemberDetailsId
                        , css
                            [ backgroundColor Colors.transparent
                            , borderStyle none
                            , color theme.colors.error
                            , cursor pointer
                            , margin (px 10)
                            , hover
                                [ Css.Global.descendants
                                    [ Css.Global.typeSelector "svg"
                                        [ Css.property "filter" "drop-shadow(2px 2px 2px rgba(0,0,0,0.9))" ]
                                    ]
                                ]
                            ]
                        ]
                        [ Html.Styled.fromUnstyled
                            (Phosphor.x Regular |> Phosphor.toHtml [ Html.Attributes.style "width" "36px", Html.Attributes.style "height" "36px" ])
                        ]
                    ]
                , div
                    [ css
                        [ displayFlex
                        , alignItems center
                        , flexDirection row
                        , minHeight (px 64)
                        , flexWrap Css.wrap
                        , justifyContent center

                        --, padding (px 64)
                        , maxHeight <| Css.calc (vh 90) minus (calc (px 64) plus (px 64))
                        , overflow auto
                        , minHeight (vh 70)
                        ]
                    ]
                    (case maybeCastMember of
                        Nothing ->
                            []

                        Just castMember ->
                            [ div
                                [ css
                                    [ flex3 (int 1) (int 1) (pct 50) --flex3 (int 0) (int 1) (px 500)
                                    , Css.height (pct 100)
                                    , maxWidth (px 670)
                                    ]
                                ]
                                [ Html.Styled.fromUnstyled <| Html.map ImageGalleryMsg <| Gallery.view imageConfig model.imageGallery [ Gallery.Arrows ] (imageSlides castMember.images)
                                ]
                            , div [ css [ flex3 (int 1) (int 1) (px 400) ] ]
                                ([ h2 []
                                    [ text
                                        (castMember.name
                                            ++ (if castMember.name == castMember.original_name then
                                                    ""

                                                else
                                                    " (" ++ castMember.original_name ++ ")"
                                               )
                                        )
                                    ]
                                 , p [] [ text castMember.biography ]
                                 , span
                                    [ css [ color theme.colors.primary ] ]
                                    [ Html.Styled.fromUnstyled
                                        ((case castMember.gender of
                                            Male ->
                                                Phosphor.genderMale

                                            Female ->
                                                Phosphor.genderFemale

                                            NonBinary ->
                                                Phosphor.genderNonbinary

                                            NotSpecified ->
                                                Phosphor.maskHappy
                                         )
                                            Duotone
                                            |> Phosphor.toHtml
                                                [ Html.Attributes.style "margin" "8px"
                                                , Html.Attributes.style "width" "24px"
                                                , Html.Attributes.style "height" "24px"
                                                ]
                                        )
                                    ]
                                 , div
                                    [ css
                                        [ color theme.colors.primary ]
                                    ]
                                    [ Html.Styled.fromUnstyled
                                        (Phosphor.cake Duotone
                                            |> Phosphor.toHtml
                                                [ Html.Attributes.style "margin" "8px"
                                                , Html.Attributes.style "width" "24px"
                                                , Html.Attributes.style "height" "24px"
                                                ]
                                        )
                                    , span []
                                        [ text castMember.birthday
                                        ]
                                    , span [] [ text castMember.place_of_birth ]
                                    ]
                                 ]
                                    ++ (case castMember.deathday of
                                            Nothing ->
                                                []

                                            Just deathday ->
                                                [ div
                                                    [ css
                                                        [ color theme.colors.primary ]
                                                    ]
                                                    [ Html.Styled.fromUnstyled
                                                        (Phosphor.cake Duotone
                                                            |> Phosphor.toHtml
                                                                [ Html.Attributes.style "margin" "8px"
                                                                , Html.Attributes.style "width" "24px"
                                                                , Html.Attributes.style "height" "24px"
                                                                ]
                                                        )
                                                    , span []
                                                        [ text deathday ]
                                                    ]
                                                ]
                                       )
                                )
                            ]
                    )
                , case model.error of
                    Just errorMessage ->
                        div
                            [ css
                                [ minHeight (px 64), padding (px 64), maxHeight <| Css.calc (vh 90) minus (calc (px 64) plus (px 64)), overflow auto ]
                            ]
                            [ h3 [ css [ color theme.colors.error, textAlign center ] ] [ text "Error" ]
                            , p
                                [ css (theme.fonts.error ++ [ marginTop (px 18) ]) ]
                                [ text errorMessage
                                ]
                            ]

                    Nothing ->
                        div [ css [ minHeight (Css.px 64), Css.maxHeight <| Css.calc (Css.vh 90) minus (calc (Css.px 64) plus (Css.px 64)), overflowY auto ] ] [ showResults model.searchResult ]
                ]
            ]
        ]


imageConfig : Gallery.Config
imageConfig =
    Gallery.config
        { id = "image-gallery"
        , transition = 500
        , width = Gallery.pct 100
        , height = Gallery.vh 70
        }


imageSlides : List GalleryImage.Url -> List ( GalleryImage.Url, Html.Html msg )
imageSlides images =
    List.map
        (\x ->
            ( x, GalleryImage.slide x GalleryImage.Contain )
        )
        images
