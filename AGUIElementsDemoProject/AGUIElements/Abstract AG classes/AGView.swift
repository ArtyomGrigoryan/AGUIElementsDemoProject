//
//  AGView.swift
//  AGUIElementsDemoProject
//
//  Created by Артем Григорян on 29.11.2020.
//

import UIKit

class AGView: UIView {
    
    // MARK: - Initializing
    
    init(width: CGFloat, height: CGFloat) {
        super.init(frame: CGRect(x: 0, y: 0, width: width, height: height))
        backgroundColor = AGThemeManager.elementsBackgroundColor
        translatesAutoresizingMaskIntoConstraints = false
        // Подпишемся на уведомления об изменении темы приложения.
        NotificationCenter.default.addObserver(self, selector: #selector(updateColors), name: .updateColors, object: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Notification functions
    
    /* Метод обновит цвета согласно выбранной пользователем темы */
    @objc func updateColors() {
        backgroundColor = AGThemeManager.elementsBackgroundColor
    }
}
