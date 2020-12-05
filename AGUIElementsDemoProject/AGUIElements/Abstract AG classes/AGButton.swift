//
//  AGButton.swift
//  AGUIElementsDemoProject
//
//  Created by Артем Григорян on 29.11.2020.
//

import UIKit

class AGButton: UIButton {
    
    // MARK: - Variables
    
    private var titleKey: String!

    // MARK: - Initializing

    init(buttonTitleKey: String!, font: UIFont!, width: CGFloat, height: CGFloat) {
        super.init(frame: CGRect(x: 0, y: 0, width: width, height: height))
        // Сделаем предварительные настройки у кнопки, они будут у всех кнопок-наследников.
        contentVerticalAlignment = .center
        contentHorizontalAlignment = .center
        translatesAutoresizingMaskIntoConstraints = false
        // Ключ тайтла кнопки пригодится при смене языка (метод changeLanguage).
        titleKey = buttonTitleKey
        // Установим текст для кнопки, который был получен из конструктора.
        setTitle(buttonTitleKey.localize(), for: .normal)
        // Установим шрифты для кнопки.
        titleLabel!.font = font
        // Установим констрейнты высоты и ширины для кнопки.
        heightAnchor.constraint(equalToConstant: height).isActive = true
        widthAnchor.constraint(equalToConstant: width).isActive = true
        // Подпишемся на уведомления об изменении языка приложения.
        NotificationCenter.default.addObserver(self, selector: #selector(changeLanguage), name: .changeLanguage, object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Notification functions
    
    /* Метод обновит язык */
    @objc func changeLanguage() {
        setTitle(titleKey.localize(), for: .normal)
    }
}
