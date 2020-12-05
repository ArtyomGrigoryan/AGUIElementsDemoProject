//
//  AGTimeFormatManager.swift
//  AGUIElementsDemoProject
//
//  Created by Артем Григорян on 05.12.2020.
//

import Foundation

struct AGTimeFormatManager {
    static var is24HourTimeFormat: Bool {
        let dateFormat = DateFormatter.dateFormat(fromTemplate: "j", options: 0, locale: Locale.current)!

        return dateFormat.firstIndex(of: "a") == nil
    }
}
