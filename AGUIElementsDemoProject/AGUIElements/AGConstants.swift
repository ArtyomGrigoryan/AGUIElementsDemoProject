//
//  AGConstants.swift
//  AGUIElementsDemoProject
//
//  Created by Артем Григорян on 29.11.2020.
//

import UIKit
import Foundation

struct AGConstants {
    struct Colors {
        struct StaticColors {
            static let errorColor = #colorLiteral(red: 1, green: 0.231372549, blue: 0.1882352941, alpha: 1)
            static let shadowColor = #colorLiteral(red: 0.1490196078, green: 0.1490196078, blue: 0.1490196078, alpha: 1)
            static let textFieldHintColor = #colorLiteral(red: 0.6078431373, green: 0.6078431373, blue: 0.6078431373, alpha: 1)
            static let textFieldStackViewLineColor = #colorLiteral(red: 0.9019607843, green: 0.9137254902, blue: 0.9215686275, alpha: 1)
            static let halfPickerButtonImageTintColor = #colorLiteral(red: 0, green: 0.6745098039, blue: 0.8901960784, alpha: 1)
            static let submitButtonDisabledStateColor = #colorLiteral(red: 0.8078431373, green: 0.8274509804, blue: 0.8588235294, alpha: 1)
            static let tabButtonSelectedStateTitleColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
        
        struct DynamicColors {
            struct Light {
                static let textFieldTextColor = #colorLiteral(red: 0.2901960784, green: 0.2901960784, blue: 0.2901960784, alpha: 1)
                static let viewBackgroundColor = #colorLiteral(red: 0.9607843137, green: 0.968627451, blue: 0.9803921569, alpha: 1)
                static let elementsBackgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                static let halfPickerHintCountLabelColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            }
            
            struct Dark {
                static let textFieldTextColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                static let viewBackgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                static let elementsBackgroundColor = #colorLiteral(red: 0.1490196078, green: 0.1490196078, blue: 0.1490196078, alpha: 1)
                static let halfPickerHintCountLabelColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            }
        }
    }
    
    struct Fonts {
        struct Name {
            static let baseFont = "SFProText-Regular"
        }
        
        struct Size {
            static let baseButton: CGFloat = 17
            static let baseLittle: CGFloat = 12
            static let baseMedium: CGFloat = 16
            static let baseBig: CGFloat = 24
        }
    }
    
    struct Languages {
        static let russian = "ru"
        static let english = "en"
    }
    
    struct CountryCodes {
        static let USA = "US"
        static let Canada = "CA"
        static let Australia = "AU"
        static let NewZeland = "NZ"
        static let Philippines = "PH"
    }
}
