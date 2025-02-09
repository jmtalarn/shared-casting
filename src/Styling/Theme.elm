module Styling.Theme exposing (theme)

import Css exposing (..)


type alias Colors =
    { primary : Color
    , primaryLight : Color
    , primaryDark : Color
    , background : Color
    , surface : Color
    , surfaceDark : Color
    , surfaceLight : Color
    , text : Color
    , textMuted : Color
    , success : Color
    , error : Color
    }


themeColors : Colors
themeColors =
    { primary = rgb 212 175 55 -- Gold-like primary color
    , primaryLight = rgb 240 210 100
    , primaryDark = rgb 160 120 40
    , background = rgb 8 15 25 -- Dark blueish-black background
    , surface = rgb 15 25 40 -- Slightly lighter dark blue
    , surfaceDark = rgb 10 20 35 -- Even darker for deeper sections
    , surfaceLight = rgb 25 45 70 -- Lighter shade for contrast
    , text = rgb 230 230 230 -- Light gray text for contrast
    , textMuted = rgb 150 150 150 -- Muted text for less emphasis
    , success = rgb 50 200 100 -- Slightly softer green
    , error = rgb 200 60 60 -- A deep red for errors
    }


defaultColor : Maybe Color -> Color
defaultColor maybeColor =
    case maybeColor of
        Just color ->
            color

        Nothing ->
            rgb 0 0 0



-- Default to black if no color is provided


type alias ShadowsType =
    { lg : Maybe Color -> Style, md : Maybe Color -> Style, sm : Maybe Color -> Style }


themeShadows : ShadowsType
themeShadows =
    { lg = \color -> boxShadow4 (px 0) (px 0) (px 15) (Maybe.withDefault (rgba 0 0 0 0.9) color)
    , md = \color -> boxShadow4 (px 0) (px 0) (px 10) (Maybe.withDefault (rgba 0 0 0 0.5) color)
    , sm = \color -> boxShadow4 (px 0) (px 0) (px 5) (Maybe.withDefault (rgba 0 0 0 0.3) color)
    }


type alias FontsType =
    { body : List Style, input : List Style, error : List Style }


themeFonts : FontsType
themeFonts =
    { body =
        [ fontFamilies [ "Inter", "Helvetica", "Arial", .value sansSerif ]
        , fontWeight (int 200)
        , color themeColors.text
        ]
    , input =
        [ fontFamilies [ "Inter", "Helvetica", "Arial", .value sansSerif ]
        , fontWeight (int 200)
        , fontSize (px 20)
        , pseudoElement "placeholder"
            [ color themeColors.textMuted ]
        ]
    , error = [ fontFamilies [ .value monospace ], color themeColors.error ]
    }


theme : { colors : Colors, shadows : ShadowsType, fonts : FontsType }
theme =
    { colors = themeColors
    , shadows = themeShadows
    , fonts = themeFonts
    }
