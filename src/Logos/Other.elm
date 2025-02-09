module Logos.Other exposing (..)

import Html.Styled exposing (Html)
import Html.Styled.Attributes as Attr
import Svg.Styled as Svg exposing (..)
import Svg.Styled.Attributes as SvgAttr


netlify : List (Svg.Attribute msg) -> Html msg
netlify attrs =
    svg
        ([ SvgAttr.viewBox "0 0 512 209"

         --, SvgAttr.fill "none"
         , Attr.attribute "aria-hidden" "true"
         , Attr.attribute "data-astro-cid-jwiz4kkf" ""
         ]
            ++ attrs
        )
        [ Svg.g
            [ SvgAttr.clipPath "url(#clip0_235_8)"
            , Attr.attribute "data-astro-cid-jwiz4kkf" ""
            ]
            [ path
                [ SvgAttr.d "M117.436 207.036V154.604L118.529 153.51H129.452L130.545 154.604V207.036L129.452 208.13H118.529L117.436 207.036Z"
                , SvgAttr.class "spark"
                , Attr.attribute "data-astro-cid-jwiz4kkf" ""
                ]
                []
            , path
                [ SvgAttr.d "M117.436 53.5225V1.09339L118.529 0H129.452L130.545 1.09339V53.5225L129.452 54.6159H118.529L117.436 53.5225Z"
                , SvgAttr.class "spark"
                , Attr.attribute "data-astro-cid-jwiz4kkf" ""
                ]
                []
            , path
                [ SvgAttr.d "M69.9539 169.238H68.4094L60.6869 161.512V159.967L78.7201 141.938L86.8976 141.942L87.9948 143.031V151.209L69.9539 169.238Z"
                , SvgAttr.class "spark"
                , Attr.attribute "data-astro-cid-jwiz4kkf" ""
                ]
                []
            , path
                [ SvgAttr.d "M69.9462 38.8917H68.4017L60.6792 46.6181V48.1626L78.7124 66.192L86.8899 66.1882L87.9871 65.0986V56.9212L69.9462 38.8917Z"
                , SvgAttr.class "spark"
                , Attr.attribute "data-astro-cid-jwiz4kkf" ""
                ]
                []
            , path
                [ SvgAttr.d "M1.09339 97.5104H75.3711L76.4645 98.6038V109.526L75.3711 110.62H1.09339L0 109.526V98.6038L1.09339 97.5104Z"
                , SvgAttr.class "spark"
                , Attr.attribute "data-astro-cid-jwiz4kkf" ""
                ]
                []
            , path
                [ SvgAttr.d "M440.999 97.5104H510.91L512.004 98.6038V109.526L510.91 110.62H436.633L435.539 109.526L439.905 98.6038L440.999 97.5104Z"
                , SvgAttr.class "spark"
                , Attr.attribute "data-astro-cid-jwiz4kkf" ""
                ]
                []
            , path
                [ SvgAttr.d "M212.056 108.727L210.963 109.821H177.079L175.986 110.914C175.986 113.101 178.173 119.657 186.916 119.657C190.196 119.657 193.472 118.564 194.566 116.377L195.659 115.284H208.776L209.869 116.377C208.776 122.934 203.313 132.774 186.916 132.774C168.336 132.774 159.589 119.657 159.589 104.357C159.589 89.0576 168.332 75.9408 185.822 75.9408C203.313 75.9408 212.056 89.0576 212.056 104.357V108.731V108.727ZM195.659 97.7971C195.659 96.7037 194.566 89.0538 185.822 89.0538C177.079 89.0538 175.986 96.7037 175.986 97.7971L177.079 98.8905H194.566L195.659 97.7971Z"
                , SvgAttr.class "text"
                , Attr.attribute "data-astro-cid-jwiz4kkf" ""
                ]
                []
            , path
                [ SvgAttr.d "M242.66 115.284C242.66 117.47 243.753 118.564 245.94 118.564H255.776L256.87 119.657V130.587L255.776 131.681H245.94C236.103 131.681 227.36 127.307 227.36 115.284V91.2368L226.266 90.1434H218.617L217.523 89.05V78.1199L218.617 77.0265H226.266L227.36 75.9332V66.0965L228.453 65.0031H241.57L242.663 66.0965V75.9332L243.757 77.0265H255.78L256.874 78.1199V89.05L255.78 90.1434H243.757L242.663 91.2368V115.284H242.66Z"
                , SvgAttr.class "text"
                , Attr.attribute "data-astro-cid-jwiz4kkf" ""
                ]
                []
            , path
                [ SvgAttr.d "M283.1 131.681H269.983L268.889 130.587V56.2636L269.983 55.1702H283.1L284.193 56.2636V130.587L283.1 131.681Z"
                , SvgAttr.class "text"
                , Attr.attribute "data-astro-cid-jwiz4kkf" ""
                ]
                []
            , path
                [ SvgAttr.d "M312.61 68.2871H299.493L298.399 67.1937V56.2636L299.493 55.1702H312.61L313.703 56.2636V67.1937L312.61 68.2871ZM312.61 131.681H299.493L298.399 130.587V78.1237L299.493 77.0304H312.61L313.703 78.1237V130.587L312.61 131.681Z"
                , SvgAttr.class "text"
                , Attr.attribute "data-astro-cid-jwiz4kkf" ""
                ]
                []
            , path
                [ SvgAttr.d "M363.98 56.2636V67.1937L362.886 68.2871H353.05C350.863 68.2871 349.769 69.3805 349.769 71.5672V75.9408L350.863 77.0342H361.793L362.886 78.1276V89.0576L361.793 90.151H350.863L349.769 91.2444V130.591L348.676 131.684H335.559L334.466 130.591V91.2444L333.372 90.151H325.723L324.629 89.0576V78.1276L325.723 77.0342H333.372L334.466 75.9408V71.5672C334.466 59.5438 343.209 55.1702 353.046 55.1702H362.882L363.976 56.2636H363.98Z"
                , SvgAttr.class "text"
                , Attr.attribute "data-astro-cid-jwiz4kkf" ""
                ]
                []
            , path
                [ SvgAttr.d "M404.42 132.774C400.046 143.704 395.677 150.261 380.373 150.261H374.906L373.813 149.167V138.237L374.906 137.144H380.373C385.836 137.144 386.929 136.05 388.023 132.77V131.677L370.536 89.05V78.1199L371.63 77.0265H381.466L382.56 78.1199L395.677 115.284H396.77L409.887 78.1199L410.98 77.0265H420.817L421.91 78.1199V89.05L404.424 132.77L404.42 132.774Z"
                , SvgAttr.class "text"
                , Attr.attribute "data-astro-cid-jwiz4kkf" ""
                ]
                []
            , path
                [ SvgAttr.d "M135.454 131.681L134.361 130.587L134.368 98.9172C134.368 93.4541 132.22 89.2182 125.625 89.0806C122.234 88.9926 118.354 89.0729 114.209 89.2488L113.59 89.8834L113.598 130.587L112.504 131.681H99.3913L98.2979 130.587V77.5388L99.3913 76.4454L128.901 76.1778C143.685 76.1778 149.668 86.3356 149.668 97.8009V130.587L148.575 131.681H135.454Z"
                , SvgAttr.class "text"
                , Attr.attribute "data-astro-cid-jwiz4kkf" ""
                ]
                []
            ]
        , Svg.defs
            [ Attr.attribute "data-astro-cid-jwiz4kkf" ""
            ]
            [ Svg.clipPath
                [ SvgAttr.id "clip0_235_8"
                , Attr.attribute "data-astro-cid-jwiz4kkf" ""
                ]
                [ Svg.rect
                    [ SvgAttr.width "512"
                    , SvgAttr.height "208.126"
                    , SvgAttr.fill "white"
                    , Attr.attribute "data-astro-cid-jwiz4kkf" ""
                    ]
                    []
                ]
            ]
        ]


theTMDBorg : List (Svg.Attribute msg) -> Html msg
theTMDBorg attrs =
    svg
        (SvgAttr.viewBox "0 0 273.42 35.52" :: attrs)
        [ Svg.defs []
            [ Svg.style []
                [ text ".cls-1{fill:url(#linear-gradient);}" ]
            , Svg.linearGradient
                [ SvgAttr.id "linear-gradient"
                , SvgAttr.y1 "17.76"
                , SvgAttr.x2 "273.42"
                , SvgAttr.y2 "17.76"
                , SvgAttr.gradientUnits "userSpaceOnUse"
                ]
                [ Svg.stop
                    [ SvgAttr.offset "0"
                    , SvgAttr.stopColor "#90cea1"
                    ]
                    []
                , Svg.stop
                    [ SvgAttr.offset "0.56"
                    , SvgAttr.stopColor "#3cbec9"
                    ]
                    []
                , Svg.stop
                    [ SvgAttr.offset "1"
                    , SvgAttr.stopColor "#00b3e5"
                    ]
                    []
                ]
            ]
        , Svg.title []
            [ text "Asset 3" ]
        , Svg.g
            [ SvgAttr.id "Layer_2"
            , Attr.attribute "data-name" "Layer 2"
            ]
            [ Svg.g
                [ SvgAttr.id "Layer_1-2"
                , Attr.attribute "data-name" "Layer 1"
                ]
                [ path
                    [ SvgAttr.class "cls-1"
                    , SvgAttr.d "M191.85,35.37h63.9A17.67,17.67,0,0,0,273.42,17.7h0A17.67,17.67,0,0,0,255.75,0h-63.9A17.67,17.67,0,0,0,174.18,17.7h0A17.67,17.67,0,0,0,191.85,35.37ZM10.1,35.42h7.8V6.92H28V0H0v6.9H10.1Zm28.1,0H46V8.25h.1L55.05,35.4h6L70.3,8.25h.1V35.4h7.8V0H66.45l-8.2,23.1h-.1L50,0H38.2ZM89.14.12h11.7a33.56,33.56,0,0,1,8.08,1,18.52,18.52,0,0,1,6.67,3.08,15.09,15.09,0,0,1,4.53,5.52,18.5,18.5,0,0,1,1.67,8.25,16.91,16.91,0,0,1-1.62,7.58,16.3,16.3,0,0,1-4.38,5.5,19.24,19.24,0,0,1-6.35,3.37,24.53,24.53,0,0,1-7.55,1.15H89.14Zm7.8,28.2h4a21.66,21.66,0,0,0,5-.55A10.58,10.58,0,0,0,110,26a8.73,8.73,0,0,0,2.68-3.35,11.9,11.9,0,0,0,1-5.08,9.87,9.87,0,0,0-1-4.52,9.17,9.17,0,0,0-2.63-3.18A11.61,11.61,0,0,0,106.22,8a17.06,17.06,0,0,0-4.68-.63h-4.6ZM133.09.12h13.2a32.87,32.87,0,0,1,4.63.33,12.66,12.66,0,0,1,4.17,1.3,7.94,7.94,0,0,1,3,2.72,8.34,8.34,0,0,1,1.15,4.65,7.48,7.48,0,0,1-1.67,5,9.13,9.13,0,0,1-4.43,2.82V17a10.28,10.28,0,0,1,3.18,1,8.51,8.51,0,0,1,2.45,1.85,7.79,7.79,0,0,1,1.57,2.62,9.16,9.16,0,0,1,.55,3.2,8.52,8.52,0,0,1-1.2,4.68,9.32,9.32,0,0,1-3.1,3A13.38,13.38,0,0,1,152.32,35a22.5,22.5,0,0,1-4.73.5h-14.5Zm7.8,14.15h5.65a7.65,7.65,0,0,0,1.78-.2,4.78,4.78,0,0,0,1.57-.65,3.43,3.43,0,0,0,1.13-1.2,3.63,3.63,0,0,0,.42-1.8A3.3,3.3,0,0,0,151,8.6a3.42,3.42,0,0,0-1.23-1.13A6.07,6.07,0,0,0,148,6.9a9.9,9.9,0,0,0-1.85-.18h-5.3Zm0,14.65h7a8.27,8.27,0,0,0,1.83-.2,4.67,4.67,0,0,0,1.67-.7,3.93,3.93,0,0,0,1.23-1.3,3.8,3.8,0,0,0,.47-1.95,3.16,3.16,0,0,0-.62-2,4,4,0,0,0-1.58-1.18,8.23,8.23,0,0,0-2-.55,15.12,15.12,0,0,0-2.05-.15h-5.9Z"
                    ]
                    []
                ]
            ]
        ]
