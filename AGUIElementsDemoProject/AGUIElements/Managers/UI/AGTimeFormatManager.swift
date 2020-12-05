//
//  AGTimeFormatManager.swift
//  AGUIElementsDemoProject
//
//  Created by Артем Григорян on 05.12.2020.
//

import Foundation

struct AGTimeFormatManager {
    static var is24HourTimeFormat: Bool {
        // Узнаем текущий регион из региональных настроек iPhone.
        let countryCode = Locale.current.regionCode
        // Определим нужно ли использовать 24-ти часовой тип времени.
        switch countryCode {
        case AGConstants.CountryCodes.USA:
            return false
        case AGConstants.CountryCodes.Canada:
            return false
        case AGConstants.CountryCodes.Australia:
            return false
        case AGConstants.CountryCodes.NewZeland:
            return false
        case AGConstants.CountryCodes.Philippines:
            return false
        default:
            return true
        }
    }
}
