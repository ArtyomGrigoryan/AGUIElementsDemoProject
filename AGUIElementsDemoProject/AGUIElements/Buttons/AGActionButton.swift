//
//  AGActionButton.swift
//  AGUIElementsDemoProject
//
//  Created by Артем Григорян on 29.11.2020.
//

import UIKit

enum AGActionButtonType {
    case submit
    case delete
    case cancel
    case clear
    case withImage(String)
    case transparent
}

class AGActionButton: AGButton {
    
    // MARK: - Initializing
    
    init(actionButtonType: AGActionButtonType = .submit, titleKey: String!, font: UIFont? = AGFontsManager.baseButtonSF) {
        // Вызовем конструктор базового класса, и передадим в него данные.
        super.init(buttonTitleKey: titleKey, font: font, width: UIScreen.main.bounds.size.width - 32, height: 50)
        // Закруглим углы у кнопки.
        layer.cornerRadius = 25
        // В зависимоти от желаемого типа кнопки, настроим её внешний вид.
        switch actionButtonType {
        case .submit:
            setTitleColor(AGThemeManager.tabButtonSelectedStateTitleColor, for: .normal)
            backgroundColor = AGThemeManager.submitButtonDisabledStateColor
        case .cancel:
            setTitleColor(AGThemeManager.halfPickerButtonImageTintColor, for: .normal)
            backgroundColor = AGThemeManager.tabButtonSelectedStateTitleColor
            layer.borderColor = AGThemeManager.halfPickerButtonImageTintColor.cgColor
            layer.borderWidth = 1.0
        case .delete:
            setTitleColor(AGThemeManager.tabButtonSelectedStateTitleColor, for: .normal)
            backgroundColor = AGThemeManager.errorColor
        case .transparent:
            setTitleColor(AGThemeManager.halfPickerButtonImageTintColor, for: .normal)
            backgroundColor = .clear
            layer.borderWidth = 1.0
            layer.borderColor = AGThemeManager.halfPickerButtonImageTintColor.cgColor
        case .clear:
            setTitleColor(AGThemeManager.halfPickerButtonImageTintColor, for: .normal)
            backgroundColor = .clear
        case .withImage(let imageName):
            setTitleColor(AGThemeManager.halfPickerButtonImageTintColor, for: .normal)
            backgroundColor = .clear
            setImage(UIImage(named: imageName)?.withTintColor(AGThemeManager.halfPickerButtonImageTintColor), for: .normal)
            titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
            imageEdgeInsets = UIEdgeInsets(top: 15, left: 4, bottom: 15, right: frame.size.width - 24)
            contentHorizontalAlignment = .left
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public functions
    
    func setEnabled() {
        isEnabled = true
        backgroundColor = AGThemeManager.halfPickerButtonImageTintColor
    }
    
    func setDisabled() {
        isEnabled = false
        backgroundColor = AGThemeManager.submitButtonDisabledStateColor
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animate(withDuration: 0.17, animations: { [weak self] in
            self?.alpha = 0.5
        }) { [weak self] (bool) in
            self?.alpha = 1
        }
        super.touchesBegan(touches, with: event)
    }
}
