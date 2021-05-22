//
//  AGTabBarPopupButton.swift
//  AGUIElementsDemoProject
//
//  Created by Артем Григорян on 19.05.2021.
//

import UIKit

class AGTabBarPopupButton: AGButton {
    
    // MARK: - Variables
    
    private let viewController: UIViewController
    
    // MARK: - Initializing
    
    init(width: CGFloat, height: CGFloat, buttonTitleKey: String, icon: String, viewController: UIViewController, font: UIFont? = AGFontsManager.littleSF) {
        // Этот вью-контроллер будет запускаться при нажатии на кнопку.
        self.viewController = viewController
        // Вызовем конструктор родительского класса - AGButton.
        super.init(buttonTitleKey: buttonTitleKey, font: font, width: width, height: height)
        // Установим цвета кнопки.
        updateColors()
        // Округлим углы у кнопки.
        layer.cornerRadius = 8
        // Установим изображение для кнопки.
        setImage(UIImage(named: icon), for: .normal)
        // Для простоты оцентровки текста и иконки по центру с вертикальным расположением оных друг к другу, сделаем Alignment по левому краю.
        contentHorizontalAlignment = .left
        // Слова будут переноситься на следующую строку.
        titleLabel!.lineBreakMode = .byWordWrapping
        // Текст у кнопки будет по центру фрейма.
        titleLabel!.textAlignment = .center
        // Сохраним в переменные значения, которые затем будут использоваться в оцентрове текста и иконки.
        let imageViewFrameWidth = imageView!.frame.size.width
        let titleLabelFrameWidth = titleLabel!.frame.size.width
        let btnCenter = (width / 2) - (imageViewFrameWidth / 2)
        let leftOffsetForTitleLabel = (width - titleLabelFrameWidth) / 2
        // Так как по умолчанию текст имеет отступ в 26 (из-за иконки, у которой ширина равна 26), то нужно вычесть эти самые 26.
        let resultLeftOffsetForTitleLabel = -imageViewFrameWidth + leftOffsetForTitleLabel
        // Применим все ранее вычисленные отступы для кнопки.
        imageEdgeInsets = UIEdgeInsets(top: -20, left: btnCenter, bottom: 0, right: 0)
        titleEdgeInsets = UIEdgeInsets(top: 30, left: resultLeftOffsetForTitleLabel, bottom: 0, right: 0)
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
        window!.rootViewController!.present(viewController, animated: true)
    }

    /* Метод обновит цвета согласно выбранной пользователем темы */
    @objc func updateColors() {
        backgroundColor = AGThemeManager.viewBackgroundColor
        setTitleColor(AGThemeManager.textFieldTextColor, for: .normal)
    }
}
