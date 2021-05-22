//
//  AGThemeManager.swift
//  AGUIElementsDemoProject
//
//  Created by Артем Григорян on 29.11.2020.
//

import UIKit

struct AGThemeManager {
    static var navigationBarStyle: UIBarStyle {
        if AGThemeManager.CurrentTheme.isLight {
            return .default
        }
        return .black
    }
    
    static var keyboardAppearance: UIKeyboardAppearance {
        if AGThemeManager.CurrentTheme.isLight {
            return .light
        }
        return .dark
    }
    
    static var halfPickerHintCountLabelColor: UIColor {
        if AGThemeManager.CurrentTheme.isLight {
            return AGConstants.Colors.DynamicColors.Light.halfPickerHintCountLabelColor
        }
        return AGConstants.Colors.DynamicColors.Dark.halfPickerHintCountLabelColor
    }
    
    static var elementsBackgroundColor: UIColor {
        if AGThemeManager.CurrentTheme.isLight {
            return AGConstants.Colors.DynamicColors.Light.elementsBackgroundColor
        }
        return AGConstants.Colors.DynamicColors.Dark.elementsBackgroundColor
    }
    
    static var textFieldTextColor: UIColor {
        if AGThemeManager.CurrentTheme.isLight {
            return AGConstants.Colors.DynamicColors.Light.textFieldTextColor
        }
        return AGConstants.Colors.DynamicColors.Dark.textFieldTextColor
    }
    
    static var viewBackgroundColor: UIColor {
        if AGThemeManager.CurrentTheme.isLight {
            return AGConstants.Colors.DynamicColors.Light.viewBackgroundColor
        }
        return AGConstants.Colors.DynamicColors.Dark.viewBackgroundColor
    }
    
    static var textFieldStackViewLineColor: UIColor {
        return AGConstants.Colors.StaticColors.textFieldStackViewLineColor
    }
    
    static var tabButtonSelectedStateTitleColor: UIColor {
        return AGConstants.Colors.StaticColors.tabButtonSelectedStateTitleColor
    }
    
    static var textFieldHintColor: UIColor {
        return AGConstants.Colors.StaticColors.textFieldHintColor
    }
    
    static var halfPickerButtonImageTintColor: UIColor {
        return AGConstants.Colors.StaticColors.halfPickerButtonImageTintColor
    }
    
    static var errorColor: UIColor {
        return AGConstants.Colors.StaticColors.errorColor
    }
    
    static var shadowColor: UIColor {
        return AGConstants.Colors.StaticColors.shadowColor
    }
    
    static var submitButtonDisabledStateColor: UIColor {
        return AGConstants.Colors.StaticColors.submitButtonDisabledStateColor
    }
    
    struct CurrentTheme {
        static var isLight = true
    }
}
