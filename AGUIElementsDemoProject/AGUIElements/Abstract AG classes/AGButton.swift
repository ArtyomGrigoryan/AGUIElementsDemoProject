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

    init(buttonTitleKey: String!, font: UIFont!, width: CGFloat, height: CGFloat, icon: String? = nil) {
        // Вызовем конструктор базового класса - UIButton.
        super.init(frame: CGRect(x: 0, y: 0, width: width, height: height))
        // Если у кнопки должна быть иконка,
        if let icon = icon {
            // то установим её.
            setImage(UIImage(named: icon), for: .normal)
        }
        // Ключ тайтла кнопки пригодится при смене языка (метод changeLanguage).
        titleKey = buttonTitleKey
        // Установим шрифты для кнопки.
        titleLabel!.font = font
        // Установим текст для кнопки, который был получен из конструктора.
        setTitle(titleKey.localize(), for: .normal)
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
