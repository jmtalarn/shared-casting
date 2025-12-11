module ContentRating exposing (contentRatingImagePath)

import VitePluginHelper


contentRatingImagePath : ( String, String ) -> Maybe String
contentRatingImagePath ( countryCode, rating ) =
    let
        normalizedCountryCode =
            if countryCode == "" then
                "US"

            else
                countryCode

        key =
            normalizedCountryCode ++ "_" ++ rating
    in
    case key of
        -- Australia (AU)
        "AU_E" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/AU_E.png")

        "AU_G" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/AU_G.png")

        "AU_M" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/AU_M.png")

        "AU_MA" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/AU_MA.png")

        "AU_MA 15+" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/AU_MA15+.png")

        "AU_PG" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/AU_PG.png")

        "AU_R" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/AU_R.png")

        "AU_R 18+" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/AU_R18+.png")

        "AU_TV-AV" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/AU_TV-AV.png")

        "AU_TV-C" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/AU_TV-C.png")

        "AU_TV-G" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/AU_TV-G.png")

        "AU_TV-M" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/AU_TV-M.png")

        "AU_TV-MA" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/AU_TV-MA.png")

        "AU_TV-MA 15+" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/AU_TV-MA15+.png")

        "AU_TV-P" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/AU_TV-P.png")

        "AU_TV-PG" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/AU_TV-PG.png")

        "AU_X" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/AU_X.png")

        "AU_X18+" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/AU_X18+.png")

        -- Brazil (BR)
        "BR_10" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/BR_10.png")

        "BR_12" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/BR_12.png")

        "BR_14" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/BR_14.png")

        "BR_16" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/BR_16.png")

        "BR_18" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/BR_18.png")

        "BR_Livre" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/BR_Livre.png")

        -- Canada (CA)
        "CA_14A" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/CA_14A.png")

        "CA_18A" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/CA_18A.png")

        "CA_G" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/CA_G.png")

        "CA_PG" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/CA_PG.png")

        "CA_R" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/CA_R.png")

        "CA_TV-14" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/CA_TV-14.png")

        "CA_TV-18" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/CA_TV-18.png")

        "CA_TV-C" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/CA_TV-C.png")

        "CA_TV-C8" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/CA_TV-C8.png")

        "CA_TV-G" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/CA_TV-G.png")

        "CA_TV-PG" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/CA_TV-PG.png")

        -- Switzerland (CH) - Note: ratings have spaces
        "CH_FSK 0" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/CH_FSK 0.png")

        "CH_FSK 6" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/CH_FSK 6.png")

        "CH_FSK 12" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/CH_FSK 12.png")

        "CH_FSK 16" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/CH_FSK 16.png")

        "CH_FSK 18" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/CH_FSK 18.png")

        "CH_0" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/CH_FSK 0.png")

        "CH_6" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/CH_FSK 6.png")

        "CH_12" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/CH_FSK 12.png")

        "CH_16" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/CH_FSK 16.png")

        "CH_18" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/CH_FSK 18.png")

        -- Germany (DE) - Note: ratings have spaces
        "DE_FSK 0" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/DE_FSK 0.png")

        "DE_FSK 6" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/DE_FSK 6.png")

        "DE_FSK 12" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/DE_FSK 12.png")

        "DE_FSK 16" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/DE_FSK 16.png")

        "DE_FSK 18" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/DE_FSK 18.png")

        "DE_0" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/DE_FSK 0.png")

        "DE_6" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/DE_FSK 6.png")

        "DE_12" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/DE_FSK 12.png")

        "DE_16" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/DE_FSK 16.png")

        "DE_18" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/DE_FSK 18.png")

        -- Denmark (DK)
        "DK_7" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/DK_7.png")

        "DK_11" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/DK_11.png")

        "DK_15" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/DK_15.png")

        "DK_A" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/DK_A.png")

        "DK_F" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/DK_F.png")

        -- Spain (ES)
        "ES_7" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/ES_7.png")

        "ES_12" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/ES_12.png")

        "ES_16" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/ES_16.png")

        "ES_18" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/ES_18.png")

        "ES_A" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/ES_A.png")

        "ES_X" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/ES_X.png")

        -- Finland (FI)
        "FI_7" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/FI_7.png")

        "FI_12" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/FI_12.png")

        "FI_16" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/FI_16.png")

        "FI_18" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/FI_18.png")

        "FI_S" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/FI_S.png")

        -- France (FR)
        "FR_TV-U" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/FR_TV-U.png")

        "FR_TV-10" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/FR_TV-10.png")

        "FR_TV-12" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/FR_TV-12.png")

        "FR_TV-16" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/FR_TV-16.png")

        "FR_TV-18" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/FR_TV-18.png")

        -- United Kingdom (GB)
        "GB_U" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/GB_U.png")

        "GB_UC" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/GB_UC.png")

        "GB_PG" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/GB_PG.png")

        "GB_12" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/GB_12.png")

        "GB_12A" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/GB_12A.png")

        "GB_15" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/GB_15.png")

        "GB_18" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/GB_18.png")

        "GB_R18" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/GB_R18.png")

        -- Hong Kong (HK)
        "HK_1" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/HK_1.png")

        "HK_2" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/HK_2.png")

        "HK_2a" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/HK_2a.png")

        "HK_2b" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/HK_2b.png")

        "HK_3" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/HK_3.png")

        -- Hungary (HU)
        "HU_0" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/HU_0.png")

        "HU_6" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/HU_6.png")

        "HU_12" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/HU_12.png")

        "HU_16" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/HU_16.png")

        "HU_18" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/HU_18.png")

        "HU_X" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/HU_X.png")

        "HU_TV-0" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/HU_TV-0.png")

        "HU_TV-6" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/HU_TV-6.png")

        "HU_TV-12" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/HU_TV-12.png")

        "HU_TV-16" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/HU_TV-16.png")

        "HU_TV-18" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/HU_TV-18.png")

        -- India (IN)
        "IN_U" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/IN_U.png")

        "IN_UA" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/IN_UA.png")

        "IN_A" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/IN_A.png")

        "IN_S" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/IN_S.png")

        -- Ireland (IE)
        "IE_G" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/IE_G.png")

        "IE_PG" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/IE_PG.png")

        "IE_12A" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/IE_12A.png")

        "IE_15A" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/IE_15A.png")

        "IE_16" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/IE_16.png")

        "IE_18" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/IE_18.png")

        -- Italy (IT)
        "IT_T" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/IT_T.png")

        "IT_VM14" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/IT_VM14.png")

        "IT_VM18" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/IT_VM18.png")

        -- Japan (JP)
        "JP_G" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/JP_G.png")

        "JP_PG12" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/JP_PG12.png")

        "JP_R15+" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/JP_R15+.png")

        "JP_R18+" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/JP_R18+.png")

        -- Korea (KR)
        "KR_All" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/KR_All.png")

        "KR_12" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/KR_12.png")

        "KR_15" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/KR_15.png")

        "KR_R" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/KR_R.png")

        "KR_Restricted" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/KR_Restricted.png")

        "KR_TV-7" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/KR_TV-7.png")

        "KR_TV-12" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/KR_TV-12.png")

        "KR_TV-15" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/KR_TV-15.png")

        "KR_TV-19" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/KR_TV-19.png")

        "KR_TV-All" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/KR_TV-All.png")

        -- Netherlands (NL)
        "NL_6" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/NL_6.png")

        "NL_9" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/NL_9.png")

        "NL_12" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/NL_12.png")

        "NL_16" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/NL_16.png")

        "NL_AL" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/NL_AL.png")

        -- Norway (NO)
        "NO_6" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/NO_6.png")

        "NO_9" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/NO_9.png")

        "NO_12" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/NO_12.png")

        "NO_15" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/NO_15.png")

        "NO_18" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/NO_18.png")

        "NO_A" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/NO_A.png")

        -- New Zealand (NZ)
        "NZ_G" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/NZ_G.png")

        "NZ_M" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/NZ_M.png")

        "NZ_PG" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/NZ_PG.png")

        "NZ_R" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/NZ_R.png")

        "NZ_R13" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/NZ_R13.png")

        "NZ_R15" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/NZ_R15.png")

        "NZ_R16" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/NZ_R16.png")

        "NZ_RP13" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/NZ_RP13.png")

        "NZ_RP16" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/NZ_RP16.png")

        -- Portugal (PT)
        "PT_A" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/PT_A.png")

        "PT_M3" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/PT_M3.png")

        "PT_M6" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/PT_M6.png")

        "PT_M12" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/PT_M12.png")

        "PT_M14" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/PT_M14.png")

        "PT_M16" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/PT_M16.png")

        "PT_M18" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/PT_M18.png")

        -- Russia (RU)
        "RU_0+" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/RU_0+.png")

        "RU_6+" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/RU_6+.png")

        "RU_12+" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/RU_12+.png")

        "RU_16+" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/RU_16+.png")

        "RU_18+" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/RU_18+.png")

        -- Taiwan (TW)
        "TW_0+" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/TW_0+.png")

        "TW_6+" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/TW_6+.png")

        "TW_12+" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/TW_12+.png")

        "TW_15+" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/TW_15+.png")

        "TW_18+" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/TW_18+.png")

        -- United States (US)
        "US_G" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/US_G.png")

        "US_PG" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/US_PG.png")

        "US_PG-13" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/US_PG-13.png")

        "US_R" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/US_R.png")

        "US_NC-17" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/US_NC-17.png")

        "US_TV-Y" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/US_TV-Y.png")

        "US_TV-Y7" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/US_TV-Y7.png")

        "US_TV-G" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/US_TV-G.png")

        "US_TV-PG" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/US_TV-PG.png")

        "US_TV-14" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/US_TV-14.png")

        "US_TV-MA" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/US_TV-MA.png")

        -- Vietnam (VN)
        "VN_P" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/VN_P.png")

        "VN_C13" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/VN_C13.png")

        "VN_C16" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/VN_C16.png")

        "VN_C18" ->
            Just (VitePluginHelper.asset "/src/assets/content-ratings/VN_C18.png")

        _ ->
            Nothing
