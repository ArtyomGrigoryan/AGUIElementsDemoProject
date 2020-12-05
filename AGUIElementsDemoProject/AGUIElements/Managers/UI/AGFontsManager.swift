//
//  AGFontsManager.swift
//  AGUIElementsDemoProject
//
//  Created by Артем Григорян on 29.11.2020.
//

import UIKit
import Foundation

struct AGFontsManager {
    static var littleSF: UIFont {
        return UIFont(name: AGConstants.Fonts.Name.baseFont, size: AGConstants.Fonts.Size.baseLittle)!
    }
    
    static var mediumSF: UIFont {
        return UIFont(name: AGConstants.Fonts.Name.baseFont, size: AGConstants.Fonts.Size.baseMedium)!
    }
    
    static var bigSF: UIFont {
        return UIFont(name: AGConstants.Fonts.Name.baseFont, size: AGConstants.Fonts.Size.baseBig)!
    }
    
    static var baseButtonSF: UIFont {
        return UIFont(name: AGConstants.Fonts.Name.baseFont, size: AGConstants.Fonts.Size.baseButton)!
    }
}
