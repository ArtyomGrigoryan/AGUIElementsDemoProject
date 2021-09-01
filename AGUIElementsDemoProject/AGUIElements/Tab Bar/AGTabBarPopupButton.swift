//
//  AGTabBarPopupButton.swift
//  AGUIElementsDemoProject
//
//  Created by Артем Григорян on 19.05.2021.
//

import UIKit

class AGTabBarPopupButton: AGButton {
    
    // MARK: - Variables
    
    private let delegate: PopupMenuClosing
    private let viewController: UIViewController
    
    // MARK: - Initializing
    
    init(width: CGFloat, height: CGFloat, buttonTitleKey: String, icon: String, viewController: UIViewController, delegate: PopupMenuClosing, font: UIFont? = AGFontsManager.littleSF) {
        // Этот вью-контроллер будет запускаться при нажатии на кнопку.
        self.viewController = viewController
        // Будем закрывать меню при нажатии на кнопку.
        self.delegate = delegate
        // Вызовем конструктор родительского класса - AGButton.
        super.init(buttonTitleKey: buttonTitleKey, font: font, width: width, height: height, icon: icon)
        // Округлим углы у кнопки.
        layer.cornerRadius = 8
        // Слова будут переноситься на следующую строку.
        titleLabel!.lineBreakMode = .byWordWrapping
        // Текст у кнопки будет по центру фрейма.
        titleLabel!.textAlignment = .center
        // Оцентрируем иконку и текст кнопки.
        centerVertically()
        // Установим цвета кнопки.
        updateColors()
        // Зарегистрируем для кнопки обработчик событий.
        addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        // Подпишемся на уведомления об изменении темы приложения.
        NotificationCenter.default.addObserver(self, selector: #selector(updateColors), name: .updateColors, object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    /* При нажатии на кнопку отобразим соответствующий кнопке вью-контроллер */
    @objc func buttonAction(sender: UIButton!) {
        delegate.closeCurrentMenuView()
        window!.rootViewController!.present(viewController, animated: true)
    }

    /* Метод обновит цвета согласно выбранной пользователем темы */
    @objc func updateColors() {
        backgroundColor = AGThemeManager.viewBackgroundColor
        setTitleColor(AGThemeManager.textFieldTextColor, for: .normal)
    }
    
    /* При смене языка нужно обновить фреймы и отступы у контента кнопки */
    override func changeLanguage() {
        super.changeLanguage()
        centerVertically()
    }
    
    // MARK: - Private functions
    
    /* Метод центрирует иконку и текст у кнопки */
    private func centerVertically() {
        var titleSize = CGSize.zero
        let imageSize = imageView!.frame.size
        let textSize = textSize(text: titleLabel!.text!, font: titleLabel!.font)
        
        if textSize.width < frame.size.width {
            titleSize = textSize
        } else {
            titleSize = titleLabel!.frame.size
        }
        
        let totalHeight = imageSize.height + titleSize.height
 
        imageEdgeInsets = UIEdgeInsets(top: -(totalHeight - imageSize.height), left: 0, bottom: 0, right: -titleSize.width)
        titleEdgeInsets = UIEdgeInsets(top: 0, left: -imageSize.width, bottom: -(totalHeight - titleSize.height), right: 0)
    }
    
    /* Метод находит размеры текста */
    private func textSize(text: String, font: UIFont?) -> CGSize {
        let attributes = font != nil ? [NSAttributedString.Key.font: font] : [:]
        return text.size(withAttributes: attributes as [NSAttributedString.Key : Any])
    }
}
