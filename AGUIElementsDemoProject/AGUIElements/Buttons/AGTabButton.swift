//
//  AGTabButton.swift
//  AGUIElementsDemoProject
//
//  Created by Артем Григорян on 29.11.2020.
//

import UIKit

class AGTabButton: AGButton {

    // MARK: - Initializing
    
    init(buttonTitleKey: String!, isButtonSelected: Bool!, font: UIFont? = AGFontsManager.baseButtonSF) {
        // Размеры кнопки.
        let width: CGFloat = UIScreen.main.bounds.size.width / 2 - 22
        let height: CGFloat = 58
        // Вызовем конструктор родительского класса.
        super.init(buttonTitleKey: buttonTitleKey, font: font, width: width, height: height)
        translatesAutoresizingMaskIntoConstraints = false
        // Установим констрейнты высоты и ширины для кнопки.
        heightAnchor.constraint(equalToConstant: 58).isActive = true
        widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.width / 2 - 22).isActive = true
        // Настроим для кнопки внешний вид.
        layer.cornerRadius = 4
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowOpacity = 0.1
        layer.shadowRadius = 4
        layer.shadowColor = AGThemeManager.shadowColor.cgColor
        // Кнопка должна поменять свой вид, в зависимости от того, выбрана ли она по умолчанию.
        if isButtonSelected {
            selectButton()
        } else {
            deselectButton()
        }
        // Подпишемся на уведомления об изменении темы приложения.
        NotificationCenter.default.addObserver(self, selector: #selector(updateColors), name: .updateColors, object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public functions
    
    /* Этот метод нужно вызвать во вью контроллере, если пользователь нажал на кнопку */
    func selectButton() {
        isSelected = true
        layer.shadowOpacity = 0
        backgroundColor = AGThemeManager.halfPickerButtonImageTintColor
        setTitleColor(AGThemeManager.tabButtonSelectedStateTitleColor, for: .normal)
    }

    /* Этот метод нужно вызвать во вью контроллере, если пользователь нажал на другую кнопку */
    func deselectButton() {
        isSelected = false
        layer.shadowOpacity = 0.1
        backgroundColor = AGThemeManager.elementsBackgroundColor
        setTitleColor(AGThemeManager.textFieldHintColor, for: .normal)
    }
    
    // MARK: - Notification functions
    
    /* Метод обновит цвета согласно выбранной пользователем темы */
    @objc func updateColors() {
        if isSelected {
            backgroundColor = AGThemeManager.halfPickerButtonImageTintColor
        } else {
            backgroundColor = AGThemeManager.elementsBackgroundColor
        }
    }
}
