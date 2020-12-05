//
//  String+localize.swift
//  AGUIElementsDemoProject
//
//  Created by Артем Григорян on 01.12.2020.
//

import Foundation

extension String {
    func localize() -> String {
        let path = Bundle.main.path(forResource: AGLanguageManager.currentLanguage, ofType: "lproj")
        let bundle = Bundle(path: path!)
        
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
    }
}
