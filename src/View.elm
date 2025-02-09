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
import Logos.Elm
import Logos.Other
import Model exposing (Model)
import Msg exposing (..)
import Phosphor exposing (IconWeight(..))
import Styling.Colors as Colors
import Styling.Theme exposing (theme)
import Title exposing (svgTitle)
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


mediaTypeLabel : MediaType -> Bool -> String
mediaTypeLabel mediaType parenthesis =
    case mediaType of
        Tv ->
            if parenthesis then
                " (TV Show)"

            else
                " TV show"

        Movie ->
            if parenthesis then
                " (Movie)"

            else
                " movie"


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
                                    [ text <| mediaTypeLabel movieTvShow.mediaType True
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
                    [ p
                        [ css
                            [ color theme.colors.textMuted
                            , Css.width (px 220)
                            , margin2 (px 32) auto
                            ]
                        ]
                        [ text "Click on the image above to search for a movie or a TV show."
                        ]
                    ]
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
                                [ text <| mediaTypeLabel item.mediaType True
                                ]
                            ]

                        -- , div [ css [] ] (List.map (\imgSvg -> img [ src imgSvg.logo ] []) item.networks)
                        , p
                            [ css
                                [ marginTop (px 8)
                                , color theme.colors.textMuted
                                , fontSize (px 12)
                                , maxWidth (px 480)
                                , Css.width (px 480)

                                --, Css.minWidth (px 480)
                                , marginTop auto
                                , marginBottom (px 32)
                                ]
                            ]
                            [ text item.description ]
                        ]
                    ]
                ]
            ]
        ]


formatCharacter : String -> Maybe String -> Html msg
formatCharacter character maybeMovieTitle =
    div
        [ css
            [ color theme.colors.textMuted
            , textAlign left
            ]
        ]
        ([ span
            [ css
                [ fontStyle italic ]
            ]
            [ text "as " ]
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
                        " " ++ mediaTypeLabel firstMovie.mediaType True

                    else
                        ""
                   )

        secondMovieTitle =
            secondMovie.title
                ++ (if showMediaType then
                        " " ++ mediaTypeLabel secondMovie.mediaType True

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
                 , flexShrink (int 0)
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
                 , Css.width (px 480)

                 --, Css.minWidth (px 480)
                 , marginBottom (rem 2)

                 --, flex3 (int 1) (int 1) (px 480)
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
                        [ div [ css [ padding (px 8) ] ]
                            [ h3 [ css [ Css.height (px 58) ] ] [ text ("Cast for " ++ title) ]
                            , showCast cast
                            ]
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
                        [ h3 [ css [ Css.height (px 58) ] ]
                            [ text <|
                                "Cast for "
                                    ++ title
                            ]
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
                        " " ++ mediaTypeLabel firstMovieTvShow.mediaType True

                    else
                        ""
                   )

        secondMovieTitle =
            secondMovieTvShow.title
                ++ (if showMediaType then
                        " " ++ mediaTypeLabel secondMovieTvShow.mediaType True

                    else
                        ""
                   )

        firstColumn =
            if List.isEmpty firstCast then
                [ div [ showCastColumnStyles Nothing ] [] ]

            else
                [ showCastColumn firstCast firstMovieTitle ]

        secondColumn =
            if List.isEmpty secondCast then
                [ div [ showCastColumnStyles Nothing ] [] ]

            else
                [ showCastColumn secondCast secondMovieTitle ]
    in
    section []
        [ div [ css [ displayFlex, alignItems center, flexDirection column ] ]
            (if not <| List.isEmpty sharedCast then
                [ showSharedCastColumn sharedCast "both" ( maybeFirstMovieTvShow, maybeSecondMovieTvShow ) ( maybeFirstDetails, maybeSecondDetails )
                ]

             else
                []
            )
        , div
            [ css
                twoColumnsCssLayout
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
    in
    ( shared, firstCast, secondCast )


hintText : String
hintText =
    "Click to search for a movie or a TV Show"


hintMiniText : MediaType -> String
hintMiniText mediaType =
    "Select this " ++ mediaTypeLabel mediaType False


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
        , minHeight (calc (Css.pct 100) minus (rem 4))
        ]


twoColumnsCssLayout : List Style
twoColumnsCssLayout =
    [ displayFlex
    , flexWrap Css.wrap
    , justifyContent spaceAround
    , Css.property "gap" "1rem"
    , maxWidth (calc (px 960) plus (rem 1))
    , margin2 (px 0) auto
    ]


dialogCastMemberDetails : Model -> Html Msg
dialogCastMemberDetails model =
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
                , case model.error of
                    Just errorMessage ->
                        div
                            [ css
                                [ minHeight (px 64), padding (px 64), maxHeight <| Css.calc (vh 90) minus (px 64), overflow auto ]
                            ]
                            [ h3 [ css [ color theme.colors.error, textAlign center ] ] [ text "Error" ]
                            , p
                                [ css (theme.fonts.error ++ [ marginTop (px 18) ]) ]
                                [ text errorMessage
                                ]
                            ]

                    Nothing ->
                        div [ css [ minHeight (Css.px 64), Css.maxHeight <| Css.calc (Css.vh 90) minus (calc (Css.px 64) plus (Css.px 64)), overflowY auto ] ] <| showCastMemberDetails model
                ]
            ]
        ]


showCastMemberDetails : Model -> List (Html Msg)
showCastMemberDetails model =
    let
        maybeCastMember =
            model.castMemberDetails

        nameHeight =
            px 42

        additionalInfoHeight =
            px 32

        additionalInfoCss =
            [ color theme.colors.primary
            , Css.height additionalInfoHeight
            , displayFlex
            , alignItems center
            , Css.property "gap" "8px"
            ]
    in
    [ div
        [ css
            [ displayFlex
            , alignItems Css.start
            , flexDirection row
            , minHeight (px 64)
            , flexWrap Css.wrap
            , justifyContent center
            , overflow auto
            ]
        ]
        (case maybeCastMember of
            Nothing ->
                []

            Just castMember ->
                [ div
                    [ css
                        [ flex3 (int 0) (int 0) (px imageGalleryWidth) --flex3 (int 0) (int 1) (px 500),
                        , Css.height (pct 100)
                        , Css.width (px 300)
                        , marginBottom (px 48)
                        ]
                    ]
                    (if List.isEmpty castMember.images then
                        []

                     else
                        [ Html.Styled.fromUnstyled <| Html.map ImageGalleryMsg <| Gallery.view imageConfig model.imageGallery [ Gallery.Arrows ] (imageSlides castMember.images) ]
                    )
                , div [ css [ flex3 (int 1) (int 1) (px 450), Css.padding2 (px 0) (px 16) ] ]
                    [ header [ css [ displayFlex, Css.height nameHeight, marginLeft (px 8) ] ]
                        [ h2 [ css [] ]
                            [ text
                                (castMember.name
                                    ++ (if castMember.name == castMember.original_name then
                                            ""

                                        else
                                            " (" ++ castMember.original_name ++ ")"
                                       )
                                )
                            ]
                        , div
                            [ css additionalInfoCss ]
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
                        ]
                    , div
                        [ css additionalInfoCss ]
                        (case castMember.birthday of
                            Nothing ->
                                []

                            Just birthday ->
                                [ Html.Styled.fromUnstyled
                                    (Phosphor.cake Duotone
                                        |> Phosphor.toHtml
                                            [ Html.Attributes.style "margin" "8px"
                                            , Html.Attributes.style "width" "24px"
                                            , Html.Attributes.style "height" "24px"
                                            ]
                                    )
                                , span []
                                    [ text birthday
                                    ]
                                , span [] [ text <| Maybe.withDefault "" castMember.place_of_birth ]
                                ]
                        )
                    , div
                        [ css additionalInfoCss ]
                        (case castMember.deathday of
                            Nothing ->
                                []

                            Just deathday ->
                                [ Html.Styled.fromUnstyled
                                    (Phosphor.cross Duotone
                                        |> Phosphor.toHtml
                                            [ Html.Attributes.style "margin" "8px"
                                            , Html.Attributes.style "width" "24px"
                                            , Html.Attributes.style "height" "24px"
                                            ]
                                    )
                                , span [] [ text deathday ]
                                ]
                        )
                    , div
                        [ css
                            [ maxHeight <|
                                calc (px imageGalleryHeight)
                                    minus
                                    (calc nameHeight
                                        plus
                                        (calc
                                            (calc additionalInfoHeight
                                                plus
                                                (case castMember.deathday of
                                                    Just _ ->
                                                        additionalInfoHeight

                                                    Nothing ->
                                                        px 0
                                                )
                                            )
                                            plus
                                            (px 48)
                                         --margin
                                        )
                                    )
                            , overflow auto
                            , margin2 (px 24) (px 8)
                            ]
                        ]
                        [ p
                            [ css [ lineHeight (rem 1.6), paddingRight (px 24) ] ]
                            [ text castMember.biography ]
                        ]
                    ]
                ]
        )
    , div [ css [ displayFlex, alignItems baseline, justifyContent spaceAround, marginBottom (px 32) ] ]
        [ miniCoverButton Backward
        , div
            [ css
                [ displayFlex

                --, flexWrap Css.wrap
                , Css.property "gap" "16px"

                --, padding2 (px 0) (px 24)
                -- , justifyContent center
                , maxWidth (pct 85)
                , padding2 (px 24) (px 16)
                , overflow Css.hidden
                ]
            , id castMemberDetailsAlsoInId
            ]
            (case maybeCastMember of
                Nothing ->
                    []

                Just castMember ->
                    List.map
                        (\( movieTvShow, character ) ->
                            div [ css [ Css.width (px miniCoverWidth) ] ]
                                [ movieTvShowMiniCover movieTvShow
                                , div [ css [ fontSize Css.small, fontWeight bold ] ] [ text movieTvShow.title ]
                                , div [ css [ fontSize Css.small ] ] [ formatCharacter character Nothing ]
                                ]
                        )
                        castMember.cast
            )
        , miniCoverButton Forward
        ]
    ]


castMemberDetailsAlsoInId : String
castMemberDetailsAlsoInId =
    "also-in"


miniCoverButton : AlsoInDirection -> Html Msg
miniCoverButton direction =
    let
        icon =
            case direction of
                Forward ->
                    Phosphor.fastForward

                Backward ->
                    Phosphor.rewind
    in
    button
        [ css
            [ backgroundColor Colors.transparent
            , borderStyle none
            , color theme.colors.primary
            , cursor pointer
            , margin (px 10)
            , flexShrink (int 0)
            , hover
                [ Css.Global.descendants
                    [ Css.Global.typeSelector "svg"
                        [ Css.property "filter" "drop-shadow(2px 2px 2px rgba(0,0,0,0.9))" ]
                    ]
                ]
            ]
        , onClick <| Scroll direction
        ]
        [ Html.Styled.fromUnstyled
            (icon Duotone |> Phosphor.toHtml [ Html.Attributes.style "width" "36px", Html.Attributes.style "height" "36px" ])
        ]


miniCoverWidth : number
miniCoverWidth =
    120


movieTvShowMiniCover : MovieTvShow -> Html Msg
movieTvShowMiniCover movieTvShow =
    let
        defaultCover =
            VitePluginHelper.asset "/src/assets/generic-cinema.jpg"

        cover =
            case Tuple.first movieTvShow.images of
                Just url ->
                    url

                Nothing ->
                    defaultCover
    in
    div [ css [ displayFlex, alignItems center, justifyContent center ] ]
        [ div
            [ css
                [ cursor pointer
                , borderRadius (px 4)
                , borderStyle none
                , Css.width (px 120)

                --, Css.height (px 330)
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
                    ]
                ]
            , title hintText
            , onClick (SelectItem movieTvShow)
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
                    (Phosphor.cursorClick Duotone
                        |> Phosphor.toHtml
                            [ Html.Attributes.style "width" "80%"
                            , Html.Attributes.style "height" "80%"
                            , Html.Attributes.style "margin" "0 auto"
                            , Html.Attributes.style "color" "white"
                            ]
                    )
                , p [ css [ color Colors.white ] ] [ text <| hintMiniText movieTvShow.mediaType ]
                ]
            ]
        ]


imageGalleryWidth : number
imageGalleryWidth =
    450


imageGalleryHeight : number
imageGalleryHeight =
    500


imageConfig : Gallery.Config
imageConfig =
    Gallery.config
        { id = "image-gallery"
        , transition = 500
        , width = Gallery.px imageGalleryWidth
        , height = Gallery.px imageGalleryHeight
        }


imageSlides : List GalleryImage.Url -> List ( GalleryImage.Url, Html.Html msg )
imageSlides images =
    List.map
        (\x ->
            ( x, GalleryImage.slide x GalleryImage.Contain )
        )
        images


footerBand : Html msg
footerBand =
    let
        commonSVG =
            [ Css.property "filter" "brightness(0) invert(1)"
            , flexShrink (int 0)
            ]

        commonSpan =
            [ whiteSpace noWrap, margin (px 4) ]
    in
    footer [ css [ padding2 (rem 1) (rem 2), backgroundColor theme.colors.surfaceDark, color theme.colors.text ] ]
        [ div
            [ css [ displayFlex, alignItems center, fontSize (px 10), flexWrap Css.wrap ] ]
            [ span
                [ css commonSpan ]
                [ text "Made with love" ]
            , Logos.Elm.view
                [ css
                    (Css.height (rem 2) :: commonSVG)
                , title "love"
                ]
                Logos.Elm.modelHeart
            , span [ css commonSpan ] [ text "and Elm" ]
            , Logos.Elm.view
                [ css
                    (Css.height (rem 2) :: commonSVG)
                , title "Elm"
                ]
                Logos.Elm.modelStart
            , span [ css commonSpan ] [ text ", using the API from The TMDB.org" ]
            , Logos.Other.theTMDBorg [ css (Css.width (px 80) :: commonSVG), title "The TMDB.org" ]
            , span [ css commonSpan ] [ text " and deployed over Netlify" ]
            , Logos.Other.netlify [ css (Css.height (rem 2) :: commonSVG), title "Netlify." ]
            , span [ css commonSpan ] [ text " Check it on Github" ]
            , span [ css [] ]
                [ a [ href "https://github.com/jmtalarn/shared-casting", css [ color inherit, textDecoration inherit ] ]
                    [ Html.Styled.fromUnstyled
                        (Phosphor.githubLogo Duotone
                            |> Phosphor.toHtml
                                [ Html.Attributes.style "margin" "8px"
                                , Html.Attributes.style "width" "16px"
                                , Html.Attributes.style "height" "16px"
                                ]
                        )
                    ]
                ]
            ]
        ]


pageHeader : Html msg
pageHeader =
    header
        [ css [ displayFlex, alignItems center, justifyContent center, padding3 (px 16) (px 8) (px 0), marginBottom (px 32), position relative ]
        , title "Shared Cast"
        ]
        [ svgTitle
        ]
