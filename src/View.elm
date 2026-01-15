module View exposing (..)

import ContentRating
import Css exposing (..)
import Css.Global exposing (children, typeSelector)
import Css.Media as Media
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


mediaTypeLabelText : MediaType -> String
mediaTypeLabelText mediaType =
    case mediaType of
        Tv ->
            " TV show"

        Movie ->
            " Movie"


mediaTypeLabel : MediaType -> Html msg
mediaTypeLabel mediaType =
    span [ css [ displayFlex, alignItems center, Css.property "gap" "4px" ] ]
        [ mediaTypeIcon mediaType
        , text (mediaTypeLabelText mediaType)
        ]


directorsLabel : List Director -> Html msg
directorsLabel directors =
    if List.isEmpty directors then
        text ""

    else
        div
            [ css
                [ displayFlex
                , alignItems center
                , flexWrap Css.wrap
                , Css.property "gap" "0.75rem"
                , marginTop (px 4)
                , marginBottom (px 4)
                , color theme.colors.textMuted
                , fontSize (rem 0.875)
                ]
            ]
            [ Html.Styled.fromUnstyled
                (Phosphor.megaphoneSimple Regular
                    |> Phosphor.toHtml
                        [ Html.Attributes.style "width" "16px"
                        , Html.Attributes.style "height" "16px"
                        ]
                )
            , div
                [ css
                    [ displayFlex
                    , alignItems center
                    , flexWrap Css.wrap
                    , Css.property "gap" "0.5rem"
                    ]
                ]
                (List.map directorItem directors)
            ]


directorItem : Director -> Html msg
directorItem director =
    div
        [ css
            [ displayFlex
            , alignItems center
            , Css.property "gap" "0.5rem"
            ]
        ]
        [ div
            [ css
                ([ borderRadius (pct 50)
                 , Css.width (px 24)
                 , Css.height (px 24)
                 , overflow Css.hidden
                 , flexShrink (int 0)
                 ]
                    ++ (case director.profile_path of
                            Just path ->
                                [ backgroundImage (url path) ]

                            Nothing ->
                                [ backgroundImage (url <| VitePluginHelper.asset "/src/assets/profile.png") ]
                       )
                    ++ [ backgroundSize cover
                       , backgroundRepeat noRepeat
                       , backgroundPosition2 (pct 50) (pct 50)
                       ]
                )
            ]
            []
        , span [] [ text director.name ]
        ]


mediaTypeIcon : MediaType -> Html msg
mediaTypeIcon mediaType =
    Html.Styled.fromUnstyled
        (case mediaType of
            Tv ->
                Phosphor.television Regular
                    |> Phosphor.toHtml
                        [ Html.Attributes.title "TV Show"
                        ]

            Movie ->
                Phosphor.filmSlate Regular
                    |> Phosphor.toHtml
                        [ Html.Attributes.title "Movie"
                        ]
        )


contentRatingImage : ( String, String ) -> Html Msg
contentRatingImage contentRating =
    case ContentRating.contentRatingImagePath contentRating of
        Just imagePath ->
            let
                ( countryCode, rating ) =
                    contentRating

                normalizedCountryCode =
                    if countryCode == "" then
                        "US"

                    else
                        countryCode
            in
            img
                [ src imagePath
                , css
                    [ Css.height (px 24)
                    , Css.width auto
                    ]
                , Html.Styled.Attributes.alt <| normalizedCountryCode ++ " " ++ rating
                ]
                []

        Nothing ->
            let
                ( countryCode, rating ) =
                    contentRating

                normalizedCountryCode =
                    if countryCode == "" then
                        "US"

                    else
                        countryCode
            in
            span
                [ css
                    [ position absolute
                    , Css.width (px 1)
                    , Css.height (px 1)
                    , padding zero
                    , margin (px -1)
                    , overflow Css.hidden
                    , Css.property "clip" "rect(0, 0, 0, 0)"
                    , whiteSpace noWrap
                    , borderWidth zero
                    ]
                ]
                [ text <| normalizedCountryCode ++ " " ++ rating ]


showMovie : MovieIndex -> Maybe MovieTvShow -> Maybe Details -> List (Html Msg)
showMovie movieIndex maybeMovieTvShow maybeDetails =
    -- let
    --     networks =
    --         case maybeDetails of
    --             Just details ->
    --                 details.networks
    --             Nothing ->
    --                 []
    -- in
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
                                [ css
                                    [ color theme.colors.text
                                    , displayFlex
                                    , alignItems center
                                    , Css.property "gap" "0.5rem"
                                    ]
                                ]
                                [ span [] [ text movieTvShow.year ]
                                , span [ css [ fontSize (px 14), color theme.colors.textMuted ] ]
                                    [ mediaTypeLabel movieTvShow.mediaType ]
                                , button
                                    [ onClick <| ShowMovieDetails movieIndex
                                    , css
                                        [ backgroundColor Colors.transparent
                                        , borderStyle none
                                        , cursor pointer
                                        , padding (px 4)
                                        , displayFlex
                                        , alignItems center
                                        , justifyContent center
                                        , borderRadius (pct 50)
                                        , transition
                                            [ Css.Transitions.backgroundColor3 200 0 ease
                                            , Css.Transitions.transform3 200 0 ease
                                            ]
                                        , hover
                                            [ backgroundColor theme.colors.primaryDark
                                            , transform (scale 1.25)
                                            ]
                                        ]
                                    , title "View Details"
                                    ]
                                    [ Html.Styled.fromUnstyled
                                        (Phosphor.arrowsOut Regular
                                            |> Phosphor.toHtml
                                                [ Html.Attributes.style "color" "#d4af37"
                                                , Html.Attributes.style "width" "18px"
                                                , Html.Attributes.style "height" "18px"
                                                ]
                                        )
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
                                    movieTvShow.networks
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
                    , div [ css [ displayFlex, alignItems center, Css.property "gap" "0.5rem" ] ]
                        [ div
                            [ css
                                [ color theme.colors.textMuted
                                , fontSize (px 14)
                                , displayFlex
                                , alignItems center
                                , Css.property "gap" "0.5rem"
                                ]
                            ]
                            (case movieTvShow.runtime of
                                Just runtime ->
                                    [ Html.Styled.fromUnstyled (Phosphor.timer Regular |> Phosphor.toHtml [])
                                    , span
                                        []
                                        [ text (String.fromInt runtime ++ " min")
                                        ]
                                    ]

                                Nothing ->
                                    []
                            )
                        , directorsLabel movieTvShow.directors
                        ]
                    , div
                        [ css
                            [ displayFlex
                            , flexWrap Css.wrap
                            , alignItems center
                            , Css.property "gap" "0.5rem"
                            , marginBottom (px 16)
                            , marginTop (px 16)
                            ]
                        ]
                        (if List.isEmpty movieTvShow.genres then
                            []

                         else
                            List.map
                                (\genre ->
                                    span
                                        [ css
                                            [ backgroundColor theme.colors.primary
                                            , color theme.colors.text
                                            , padding2 (px 4) (px 8)
                                            , borderRadius (px 4)
                                            , fontSize (px 12)
                                            ]
                                        ]
                                        [ text genre ]
                                )
                                movieTvShow.genres
                        )
                    , div
                        [ css
                            [ displayFlex
                            , flexWrap Css.wrap
                            , alignItems center
                            , Css.property "gap" "0.5rem"
                            , marginBottom (px 16)
                            , marginTop (px 16)
                            ]
                        ]
                        (if List.isEmpty movieTvShow.content_ratings then
                            []

                         else
                            List.map contentRatingImage movieTvShow.content_ratings
                        )
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

        cover =
            item.images.poster
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
                            , span [ css [ fontSize (px 14) ] ]
                                [ mediaTypeLabel item.mediaType ]
                            ]

                        -- , div [ css [] ] (List.map (\imgSvg -> img [ src imgSvg.logo ] []) item.networks)
                        , p
                            [ css
                                [ marginTop (px 8)
                                , color theme.colors.textMuted
                                , fontSize (px 12)

                                -- , maxWidth (px 480)
                                -- , Css.width (px 480)
                                --, Css.minWidth (px 480)
                                , marginTop auto
                                , marginBottom (px 8)
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


getCharacterForMember : CastMember -> Maybe Details -> String -> Html msg
getCharacterForMember member maybeDetails movieTitle =
    let
        character =
            case maybeDetails of
                Just details ->
                    details.cast
                        |> List.filter (\c -> c.id == member.id)
                        |> List.head
                        |> Maybe.map .character
                        |> Maybe.withDefault "uncredited"

                Nothing ->
                    "uncredited"
    in
    formatCharacter character (Just movieTitle)


getMovieTitles : MovieTvShow -> MovieTvShow -> ( String, String )
getMovieTitles firstMovie secondMovie =
    let
        baseFirstTitle =
            firstMovie.title

        baseSecondTitle =
            secondMovie.title
    in
    if baseFirstTitle /= baseSecondTitle then
        ( baseFirstTitle, baseSecondTitle )

    else
        let
            firstWithType =
                baseFirstTitle ++ " (" ++ mediaTypeLabelText firstMovie.mediaType ++ ")"

            secondWithType =
                baseSecondTitle ++ " (" ++ mediaTypeLabelText secondMovie.mediaType ++ ")"
        in
        if firstWithType /= secondWithType then
            ( firstWithType, secondWithType )

        else
            ( baseFirstTitle ++ " (" ++ mediaTypeLabelText firstMovie.mediaType ++ " - " ++ firstMovie.year ++ ")"
            , baseSecondTitle ++ " (" ++ mediaTypeLabelText secondMovie.mediaType ++ " - " ++ secondMovie.year ++ ")"
            )


showSharedCastMember : CastMember -> ( Maybe MovieTvShow, Maybe MovieTvShow ) -> ( Maybe Details, Maybe Details ) -> Html Msg
showSharedCastMember member ( maybeFirstMovieTvShow, maybeSecondMovieTvShow ) ( maybeFirstDetails, maybeSecondDetails ) =
    let
        firstMovie =
            Maybe.withDefault defaultMovieTvShow maybeFirstMovieTvShow

        secondMovie =
            Maybe.withDefault defaultMovieTvShow maybeSecondMovieTvShow

        ( firstMovieTitle, secondMovieTitle ) =
            getMovieTitles firstMovie secondMovie

        characterFirst =
            getCharacterForMember member maybeFirstDetails firstMovieTitle

        characterSecond =
            getCharacterForMember member maybeSecondDetails secondMovieTitle

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

        movieTitleWithParenthesis movieTvShow isShowMediaType =
            if isShowMediaType then
                movieTvShow.title ++ " (" ++ mediaTypeLabelText movieTvShow.mediaType ++ ")"

            else
                movieTvShow.title

        firstMovieTitle =
            movieTitleWithParenthesis firstMovieTvShow showMediaType

        secondMovieTitle =
            movieTitleWithParenthesis secondMovieTvShow showMediaType

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
    "Select this "
        ++ (if mediaType == Movie then
                "movie"

            else
                "TV show"
           )


movieTvShowCover : MovieIndex -> Maybe MovieTvShow -> Html Msg
movieTvShowCover index maybeMovieTvShow =
    let
        defaultCover =
            VitePluginHelper.asset "/src/assets/generic-cinema.jpg"

        cover =
            case maybeMovieTvShow of
                Just movieTvShow ->
                    case movieTvShow.images.poster of
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


dialogMovieDetailsId : String
dialogMovieDetailsId =
    "movie-details"


dialogMovieSearchInputId : String
dialogMovieSearchInputId =
    "movie-search-input"


defaultDetails : Details
defaultDetails =
    { cast = []
    , networks = []
    , content_ratings = []
    , runtime = Nothing
    , genres = []
    , logo = Nothing
    , directors = []
    , reviews = []
    }


defaultMovieTvShow : MovieTvShow
defaultMovieTvShow =
    { id = 0
    , title = ""
    , year = ""
    , description = ""
    , images = { poster = Nothing, backdrop = Nothing, logo = Nothing }
    , networks = []
    , mediaType = Movie
    , popularity = 0
    , vote_average = 0
    , vote_count = 0
    , content_ratings = []
    , runtime = Nothing
    , genres = []
    , directors = []
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


dialogMovieDetails : Model -> Html Msg
dialogMovieDetails model =
    let
        ( maybeFirstMovie, maybeSecondMovie ) =
            model.movies

        ( maybeFirstDetails, maybeSecondDetails ) =
            model.details

        getMovieAndDetails : MovieIndex -> ( Maybe MovieTvShow, Maybe Details )
        getMovieAndDetails index =
            case index of
                First ->
                    ( maybeFirstMovie, maybeFirstDetails )

                Second ->
                    ( maybeSecondMovie, maybeSecondDetails )
    in
    section []
        [ node "dialog"
            [ css
                [ pseudoElement "backdrop"
                    [ backgroundColor <| rgba 0 0 0 0.8
                    , Css.property "-webkit-backdrop-filter" "blur(4px)"
                    , Css.property "backdrop-filter" "blur(4px)"
                    , zIndex (int 1)
                    ]
                , zIndex (int 2)
                , position fixed
                , top (px 0)
                , right (px 0)
                , bottom (px 0)
                , left (px 0)
                , Css.width (pct 100)
                , Css.height (pct 100)
                , maxWidth (pct 100)
                , maxHeight (pct 100)
                , margin (px 0)
                , padding (px 0)
                , borderStyle Css.none
                , borderWidth (px 0)
                , backgroundColor Colors.transparent
                , overflow Css.hidden
                , Css.property "inset" "0"
                ]
            , id dialogMovieDetailsId
            ]
            [ case model.targetMovieIndex of
                Just movieIndex ->
                    let
                        ( maybeMovie, maybeDetails ) =
                            getMovieAndDetails movieIndex
                    in
                    case maybeMovie of
                        Just movie ->
                            showMovieDetailsDialog movie maybeDetails model.castExpanded model.expandedReviews movieIndex

                        Nothing ->
                            text ""

                Nothing ->
                    text ""
            ]
        ]


reviewsSectionId : String
reviewsSectionId =
    "reviews-section"


showReviewsSection : List Review -> List ( MovieIndex, Int ) -> MovieIndex -> Html Msg
showReviewsSection reviews expandedReviews currentMovieIndex =
    let
        reviewsInPairs =
            List.indexedMap Tuple.pair reviews
                |> List.foldr
                    (\( index, review ) acc ->
                        case acc of
                            [] ->
                                [ [ ( index, review ) ] ]

                            (firstPair :: rest) as pairs ->
                                if List.length firstPair < 2 then
                                    (( index, review ) :: firstPair) :: rest

                                else
                                    [ ( index, review ) ] :: pairs
                    )
                    []
                |> List.reverse
    in
    div
        [ css
            [ marginTop (px 32)
            , paddingTop (px 32)
            , paddingBottom (px 32)
            , paddingLeft (px 32)
            , paddingRight (px 32)
            , borderTop3 (px 1) solid (rgba 255 255 255 0.1)
            , backgroundColor <| rgba 0 0 0 0.6
            , borderRadius (px 16)
            , Css.property "backdrop-filter" "blur(8px)"
            , maxWidth (px 1000)
            , margin2 (px 0) auto
            ]
        ]
        [ h2
            [ css
                [ color theme.colors.text
                , fontSize (rem 1.5)
                , fontWeight (int 600)
                , marginBottom (px 24)
                ]
            ]
            [ text "Reviews" ]
        , div
            [ css
                [ displayFlex
                , alignItems baseline
                , justifyContent spaceAround
                , marginBottom (px 32)
                ]
            ]
            [ miniCoverButton Backward
            , div
                [ css
                    [ displayFlex
                    , Css.property "gap" "16px"
                    , maxWidth (pct 85)
                    , padding2 (px 24) (px 16)
                    , overflow Css.auto
                    , Css.property "scroll-snap-type" "x mandatory"
                    , Css.property "-webkit-overflow-scrolling" "touch"
                    , cursor grab
                    , children
                        [ typeSelector "div"
                            [ Css.property "scroll-snap-align" "center" ]
                        ]
                    , Media.withMedia [ Media.only Media.screen [ Media.minWidth (px 768) ] ]
                        [ overflow Css.hidden
                        ]
                    ]
                , id reviewsSectionId
                ]
                (List.map
                    (\reviewPair ->
                        div
                            [ css
                                [ displayFlex
                                , Css.property "gap" "1rem"
                                , Css.width (px 800)
                                , flexShrink (int 0)
                                ]
                            ]
                            (List.map
                                (\( reviewIndex, review ) ->
                                    div
                                        [ css
                                            [ flex (int 1)
                                            , minWidth (px 0)
                                            ]
                                        ]
                                        [ showReview review expandedReviews currentMovieIndex reviewIndex ]
                                )
                                reviewPair
                            )
                    )
                    reviewsInPairs
                )
            , miniCoverButton Forward
            ]
        ]


showReview : Review -> List ( MovieIndex, Int ) -> MovieIndex -> Int -> Html Msg
showReview review expandedReviews currentMovieIndex reviewIndex =
    let
        isExpanded =
            List.member ( currentMovieIndex, reviewIndex ) expandedReviews

        maxLength =
            300

        shouldTruncate =
            String.length review.content > maxLength

        displayContent =
            if isExpanded || not shouldTruncate then
                review.content

            else
                String.left maxLength review.content ++ "..."
    in
    div
        [ css
            [ backgroundColor <| rgba 255 255 255 0.05
            , padding (px 20)
            , borderRadius (px 12)
            , borderLeft3 (px 3) solid theme.colors.primary
            ]
        ]
        [ div
            [ css
                [ displayFlex
                , alignItems center
                , Css.property "gap" "0.75rem"
                , marginBottom (px 12)
                ]
            ]
            [ div
                [ css
                    ([ borderRadius (pct 50)
                     , Css.width (px 40)
                     , Css.height (px 40)
                     , overflow Css.hidden
                     , flexShrink (int 0)
                     ]
                        ++ (case review.avatar_path of
                                Just path ->
                                    [ backgroundImage (url path) ]

                                Nothing ->
                                    [ backgroundImage (url <| VitePluginHelper.asset "/src/assets/profile.png") ]
                           )
                        ++ [ backgroundSize cover
                           , backgroundRepeat noRepeat
                           , backgroundPosition2 (pct 50) (pct 50)
                           ]
                    )
                ]
                []
            , div
                [ css
                    [ displayFlex
                    , flexDirection column
                    ]
                ]
                [ span
                    [ css
                        [ color theme.colors.text
                        , fontSize (rem 1)
                        , fontWeight (int 600)
                        ]
                    ]
                    [ text review.author ]
                ]
            ]
        , p
            [ css
                [ color theme.colors.textMuted
                , fontSize (rem 0.95)
                , lineHeight (num 1.6)
                , whiteSpace preWrap
                ]
            ]
            [ text displayContent ]
        , if shouldTruncate then
            button
                [ onClick <| ToggleReviewExpansion currentMovieIndex reviewIndex
                , css
                    [ backgroundColor Colors.transparent
                    , borderStyle none
                    , color theme.colors.primary
                    , cursor pointer
                    , padding (px 8)
                    , marginTop (px 8)
                    , fontSize (rem 0.9)
                    , fontWeight (int 500)
                    , displayFlex
                    , alignItems center
                    , Css.property "gap" "0.5rem"
                    , hover
                        [ Css.property "opacity" "0.8"
                        ]
                    ]
                ]
                [ Html.Styled.fromUnstyled
                    (Phosphor.dotsThree Regular
                        |> Phosphor.toHtml
                            [ Html.Attributes.style "width" "16px"
                            , Html.Attributes.style "height" "16px"
                            ]
                    )
                , text <|
                    if isExpanded then
                        "Show less"

                    else
                        "Show more"
                ]

          else
            text ""
        ]


showMovieDetailsDialog : MovieTvShow -> Maybe Details -> Maybe MovieIndex -> List ( MovieIndex, Int ) -> MovieIndex -> Html Msg
showMovieDetailsDialog movie maybeDetails castExpanded expandedReviews currentMovieIndex =
    let
        backdropUrl =
            Maybe.withDefault "" movie.images.backdrop

        logoUrl =
            Maybe.withDefault "" movie.images.logo

        hasBackdrop =
            backdropUrl /= ""

        backdropStyle =
            if hasBackdrop then
                [ backgroundImage (url backdropUrl)
                , backgroundSize cover
                , backgroundPosition center
                , backgroundRepeat noRepeat

                --, Css.property "filter" "brightness(0.3)"
                ]

            else
                [ backgroundColor theme.colors.surfaceDark ]

        contentOverlay =
            [ position absolute
            , top (px 0)
            , left (px 0)
            , right (px 0)
            , bottom (px 0)
            , Css.width (pct 100)
            , Css.height (pct 100)
            , overflowY auto
            , zIndex (int 3)
            , margin (px 0)
            , padding (px 0)
            ]
    in
    div
        [ css
            ([ position absolute
             , top (px 0)
             , left (px 0)
             , right (px 0)
             , bottom (px 0)
             , Css.width (pct 100)
             , Css.height (pct 100)
             , margin (px 0)
             , padding (px 0)
             ]
                ++ backdropStyle
            )
        ]
        [ div
            [ css contentOverlay ]
            [ -- Header with logo and close button
              div
                [ css
                    [ displayFlex
                    , alignItems center
                    , justifyContent spaceBetween
                    , padding (px 24)
                    , position sticky
                    , top (px 0)
                    , zIndex (int 4)
                    , backgroundColor <| rgba 0 0 0 0.3
                    , Css.property "backdrop-filter" "blur(8px)"
                    ]
                ]
                [ -- Logo on the left
                  if logoUrl /= "" then
                    img
                        [ src logoUrl
                        , css
                            [ Css.maxWidth (px 300)
                            , Css.maxHeight (px 80)
                            , Css.width auto
                            , Css.height auto
                            , Css.property "filter" "drop-shadow(0 4px 8px rgba(0,0,0,0.5))"
                            ]
                        , Html.Styled.Attributes.alt movie.title
                        ]
                        []

                  else
                    h1
                        [ css
                            [ color theme.colors.text
                            , fontSize (rem 2)
                            , fontWeight (int 700)
                            , Css.property "text-shadow" "2px 2px 8px rgba(0,0,0,0.8)"
                            ]
                        ]
                        [ text movie.title ]

                -- Close button on the right
                , button
                    [ onClick <| HideDialog dialogMovieDetailsId
                    , css
                        [ backgroundColor Colors.transparent
                        , borderStyle none
                        , color theme.colors.text
                        , cursor pointer
                        , padding (px 8)
                        , borderRadius (px 50)
                        , hover
                            [ backgroundColor <| rgba 255 255 255 0.1
                            ]
                        ]
                    ]
                    [ Html.Styled.fromUnstyled
                        (Phosphor.x Regular
                            |> Phosphor.toHtml
                                [ Html.Attributes.style "width" "32px"
                                , Html.Attributes.style "height" "32px"
                                , Html.Attributes.style "color" "#e6e6e6"
                                ]
                        )
                    ]
                ]
            , div
                [ css
                    [ maxWidth (px 1400)
                    , margin2 (px 0) auto
                    , padding (px 32)
                    , displayFlex
                    , flexDirection column
                    , Css.property "gap" "2rem"
                    ]
                ]
                [ -- Main content with poster and info side by side
                  div
                    [ css
                        [ displayFlex
                        , flexWrap Css.wrap
                        , Css.property "gap" "2rem"
                        , alignItems flexStart
                        ]
                    ]
                    [ -- Poster
                      case movie.images.poster of
                        Just posterUrl ->
                            img
                                [ src posterUrl
                                , css
                                    [ Css.width (px 300)
                                    , Css.height auto
                                    , borderRadius (px 12)
                                    , Css.property "box-shadow" "0 8px 24px rgba(0,0,0,0.5)"
                                    , flexShrink (int 0)
                                    ]
                                , Html.Styled.Attributes.alt movie.title
                                ]
                                []

                        Nothing ->
                            text ""

                    -- Movie info section
                    , div
                        [ css
                            [ flex (int 1)
                            , minWidth (px 300)
                            ]
                        ]
                        [ div
                            [ css
                                [ displayFlex
                                , flexDirection column
                                , Css.property "gap" "1.5rem"
                                , backgroundColor <| rgba 0 0 0 0.6
                                , padding (px 32)
                                , borderRadius (px 16)
                                , Css.property "backdrop-filter" "blur(8px)"
                                ]
                            ]
                            [ -- Title, year, type
                              div
                                [ css
                                    [ displayFlex
                                    , alignItems flexStart
                                    , flexWrap Css.wrap
                                    , Css.property "gap" "1rem"
                                    , marginBottom (px 8)
                                    , flexDirection column
                                    ]
                                ]
                                [ --if logoUrl == "" then
                                  h1
                                    [ css
                                        [ color theme.colors.text
                                        , fontSize (rem 2.5)
                                        , fontWeight (int 700)
                                        , Css.property "text-shadow" "2px 2px 8px rgba(0,0,0,0.8)"
                                        ]
                                    ]
                                    [ text movie.title ]

                                --   else
                                --     text ""
                                , div [ css [ displayFlex, alignItems center, Css.property "gap" "0.5rem" ] ]
                                    [ span
                                        [ css
                                            [ color theme.colors.textMuted
                                            , fontSize (rem 1.2)
                                            ]
                                        ]
                                        [ text movie.year ]
                                    , span
                                        [ css
                                            [ color theme.colors.textMuted
                                            , fontSize (rem 1)
                                            , padding2 (px 6) (px 12)
                                            , backgroundColor (rgba 255 255 255 0.1)
                                            , borderRadius (px 6)
                                            ]
                                        ]
                                        [ mediaTypeLabel movie.mediaType ]
                                    ]
                                , directorsLabel movie.directors

                                -- Description
                                , p
                                    [ css
                                        [ color theme.colors.text
                                        , fontSize (rem 1.1)
                                        , lineHeight (num 1.6)
                                        , marginTop (px 8)
                                        ]
                                    ]
                                    [ text movie.description ]

                                -- Stats row
                                , div
                                    [ css
                                        [ displayFlex
                                        , flexWrap Css.wrap
                                        , alignItems center
                                        , Css.property "gap" "2rem"
                                        , marginTop (px 16)
                                        ]
                                    ]
                                    [ -- Rating
                                      div
                                        [ css
                                            [ displayFlex
                                            , alignItems center
                                            , Css.property "gap" "0.5rem"
                                            ]
                                        ]
                                        [ Html.Styled.fromUnstyled
                                            (Phosphor.star Regular
                                                |> Phosphor.toHtml
                                                    [ Html.Attributes.style "color" "#e6e6e6"
                                                    , Html.Attributes.style "width" "20px"
                                                    , Html.Attributes.style "height" "20px"
                                                    ]
                                            )
                                        , span
                                            [ css
                                                [ color theme.colors.text
                                                , fontSize (rem 1.1)
                                                , fontWeight (int 600)
                                                ]
                                            ]
                                            [ text <| String.fromFloat movie.vote_average ]
                                        , span
                                            [ css
                                                [ color theme.colors.textMuted
                                                , fontSize (rem 0.9)
                                                ]
                                            ]
                                            [ text <| "(" ++ String.fromInt movie.vote_count ++ " votes)" ]
                                        ]

                                    -- Runtime
                                    , case movie.runtime of
                                        Just runtime ->
                                            div
                                                [ css
                                                    [ displayFlex
                                                    , alignItems center
                                                    , Css.property "gap" "0.5rem"
                                                    ]
                                                ]
                                                [ Html.Styled.fromUnstyled
                                                    (Phosphor.timer Regular
                                                        |> Phosphor.toHtml
                                                            [ Html.Attributes.style "color" "#e6e6e6"
                                                            , Html.Attributes.style "width" "20px"
                                                            , Html.Attributes.style "height" "20px"
                                                            ]
                                                    )
                                                , span
                                                    [ css
                                                        [ color theme.colors.text
                                                        , fontSize (rem 1.1)
                                                        ]
                                                    ]
                                                    [ text <| String.fromInt runtime ++ " min" ]
                                                ]

                                        Nothing ->
                                            text ""

                                    -- Popularity
                                    , div
                                        [ css
                                            [ displayFlex
                                            , alignItems center
                                            , Css.property "gap" "0.5rem"
                                            ]
                                        ]
                                        [ Html.Styled.fromUnstyled
                                            (Phosphor.trendUp Regular
                                                |> Phosphor.toHtml
                                                    [ Html.Attributes.style "color" "#e6e6e6"
                                                    , Html.Attributes.style "width" "20px"
                                                    , Html.Attributes.style "height" "20px"
                                                    ]
                                            )
                                        , span
                                            [ css
                                                [ color theme.colors.text
                                                , fontSize (rem 1.1)
                                                ]
                                            ]
                                            [ text <| String.fromFloat movie.popularity ]
                                        ]
                                    ]

                                -- Genres
                                , if not (List.isEmpty movie.genres) then
                                    div
                                        [ css
                                            [ displayFlex
                                            , flexWrap Css.wrap
                                            , alignItems center
                                            , Css.property "gap" "0.75rem"
                                            , marginTop (px 8)
                                            ]
                                        ]
                                        (List.map
                                            (\genre ->
                                                span
                                                    [ css
                                                        [ backgroundColor theme.colors.primary
                                                        , color theme.colors.text
                                                        , padding2 (px 8) (px 16)
                                                        , borderRadius (px 8)
                                                        , fontSize (rem 0.95)
                                                        , fontWeight (int 500)
                                                        ]
                                                    ]
                                                    [ text genre ]
                                            )
                                            movie.genres
                                        )

                                  else
                                    text ""

                                -- Networks or Production Companies
                                , if not (List.isEmpty movie.networks) then
                                    div
                                        [ css
                                            [ displayFlex
                                            , flexWrap Css.wrap
                                            , alignItems center
                                            , Css.property "gap" "1rem"
                                            , marginTop (px 16)
                                            , paddingTop (px 16)
                                            , borderTop3 (px 1) solid (rgba 255 255 255 0.1)
                                            ]
                                        ]
                                        (List.map
                                            (\network ->
                                                div
                                                    [ css
                                                        [ displayFlex
                                                        , alignItems center
                                                        , padding2 (px 8) (px 12)
                                                        , backgroundColor (rgba 255 255 255 0.1)
                                                        , borderRadius (px 8)
                                                        ]
                                                    , title network.name
                                                    ]
                                                    [ img
                                                        [ src network.logo
                                                        , css
                                                            [ Css.maxHeight (px 32)
                                                            , Css.width auto
                                                            , Css.property "filter" "brightness(0) invert(1)"
                                                            ]
                                                        , Html.Styled.Attributes.alt network.name
                                                        ]
                                                        []
                                                    ]
                                            )
                                            movie.networks
                                        )

                                  else
                                    text ""

                                -- Content ratings
                                , if not (List.isEmpty movie.content_ratings) then
                                    div
                                        [ css
                                            [ displayFlex
                                            , flexWrap Css.wrap
                                            , alignItems center
                                            , Css.property "gap" "0.75rem"
                                            , marginTop (px 8)
                                            ]
                                        ]
                                        (List.map contentRatingImage movie.content_ratings)

                                  else
                                    text ""
                                ]
                            ]
                        ]
                    ]
                ]

            -- Reviews section
            , case maybeDetails of
                Just details ->
                    if not (List.isEmpty details.reviews) then
                        showReviewsSection details.reviews expandedReviews currentMovieIndex

                    else
                        text ""

                Nothing ->
                    text ""

            -- Cast section
            , case maybeDetails of
                Just details ->
                    if not (List.isEmpty details.cast) then
                        let
                            isExpanded =
                                castExpanded == Just currentMovieIndex

                            castToShow =
                                if isExpanded then
                                    details.cast

                                else
                                    List.take 6 details.cast

                            hasMore =
                                List.length details.cast > 6
                        in
                        div
                            [ css
                                [ marginTop (px 32)
                                , paddingTop (px 32)
                                , paddingBottom (px 32)
                                , paddingLeft (px 32)
                                , paddingRight (px 32)
                                , borderTop3 (px 1) solid (rgba 255 255 255 0.1)
                                , backgroundColor <| rgba 0 0 0 0.6
                                , borderRadius (px 16)
                                , Css.property "backdrop-filter" "blur(8px)"
                                ]
                            ]
                            [ div
                                [ css
                                    [ displayFlex
                                    , alignItems center
                                    , justifyContent spaceBetween
                                    , marginBottom (px 24)
                                    ]
                                ]
                                [ h2
                                    [ css
                                        [ color theme.colors.text
                                        , fontSize (rem 1.8)
                                        , fontWeight (int 700)
                                        , margin (px 0)
                                        ]
                                    ]
                                    [ text "Cast" ]
                                ]
                            , div
                                [ css
                                    [ displayFlex
                                    , flexWrap Css.wrap
                                    , Css.property "gap" "0.5rem"
                                    , justifyContent flexStart
                                    ]
                                ]
                                (List.map
                                    (\castMember ->
                                        div
                                            [ css
                                                [ Css.width (px 200)
                                                , flexShrink (int 0)
                                                ]
                                            ]
                                            [ showCastMember castMember ]
                                    )
                                    castToShow
                                )
                            , if hasMore then
                                button
                                    [ onClick <| ToggleCastExpansion currentMovieIndex
                                    , css
                                        [ backgroundColor Colors.transparent
                                        , borderStyle none
                                        , color theme.colors.primary
                                        , cursor pointer
                                        , padding (px 12)
                                        , marginTop (px 16)
                                        , fontSize (rem 1)
                                        , fontWeight (int 500)
                                        , displayFlex
                                        , alignItems center
                                        , justifyContent center
                                        , Css.property "gap" "0.5rem"
                                        , hover
                                            [ Css.property "opacity" "0.8"
                                            ]
                                        ]
                                    ]
                                    [ text <|
                                        if isExpanded then
                                            "Show Less"

                                        else
                                            "Show All (" ++ String.fromInt (List.length details.cast) ++ ")"
                                    , Html.Styled.fromUnstyled
                                        (if isExpanded then
                                            Phosphor.caretUp Regular
                                                |> Phosphor.toHtml
                                                    [ Html.Attributes.style "color" "#d4af37"
                                                    , Html.Attributes.style "width" "16px"
                                                    , Html.Attributes.style "height" "16px"
                                                    ]

                                         else
                                            Phosphor.caretDown Regular
                                                |> Phosphor.toHtml
                                                    [ Html.Attributes.style "color" "#d4af37"
                                                    , Html.Attributes.style "width" "16px"
                                                    , Html.Attributes.style "height" "16px"
                                                    ]
                                        )
                                    ]

                              else
                                text ""
                            ]

                    else
                        text ""

                Nothing ->
                    text ""
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
            , Css.property "overflow" "clip"
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
                , div
                    [ css
                        [ Css.padding2 (px 0) (px 16)

                        --, flex3 (int 1) (int 1) (px 450)
                        ]
                    ]
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
    , div
        [ css
            [ displayFlex
            , alignItems baseline
            , justifyContent spaceAround
            , marginBottom (px 32)
            ]
        ]
        [ miniCoverButton Backward
        , div
            [ css
                [ displayFlex
                , Css.property "gap" "16px"
                , maxWidth (pct 85)
                , padding2 (px 24) (px 16)
                , overflow Css.auto
                , Css.property "scroll-snap-type" "x mandatory"
                , Css.property "-webkit-overflow-scrolling" "touch"
                , cursor grab
                , children
                    [ typeSelector "div"
                        [ Css.property "scroll-snap-align" "center" ]
                    ]
                , Media.withMedia [ Media.only Media.screen [ Media.minWidth (px 768) ] ]
                    [ overflow Css.hidden
                    ]
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
            case movieTvShow.images.poster of
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
