//
//  AGTabBarPopupMenuView.swift.swift
//  AGUIElementsDemoProject
//
//  Created by Артем Григорян on 13.05.2021.
//

import UIKit

class AGTabBarPopupMenuView: AGView {
    
    // MARK: - Variables
    
    private let popupMenuButtonWidth = UIScreen.main.bounds.size.width / 2.3
    private let popupMenuButtonHeight = UIScreen.main.bounds.size.height / 7.52

    // MARK: - Initializing

    init(textsArray: [String], iconsArray: [String], viewControllersArray: [UIViewController]) {
        // Эта переменная будет использоваться для вычисления 2-ух других переменных ниже.
        let variableForAnotherCalculatings = (CGFloat(textsArray.count) / 2).rounded(.up)
        // 12 - это отступы по вертикали блоков в меню друг от друга.
        let itemVerticalAdditionalSpacesTotalHeight = (variableForAnotherCalculatings - 1) * 12
        // Высота всех блоков по вертикальной линии.
        let allPopupMenuItemHeights = variableForAnotherCalculatings * popupMenuButtonHeight
        // Вычислим итоговую высоту всплывающего меню.
        let height: CGFloat = allPopupMenuItemHeights + itemVerticalAdditionalSpacesTotalHeight + 40
        // Вызовем конструктор базового класса - AGView.
        super.init(width: UIScreen.main.bounds.size.width, height: height, y: UIScreen.main.bounds.size.height)
        // В вертикальный UIStackView будем помещать горизонтальные UIStackView, которые содержат кнопки.
        let verticalStackView = UIStackView(frame: CGRect(x: 20, y: 20, width: frame.size.width - 40, height: frame.size.height - 40))
        verticalStackView.spacing = 12
        verticalStackView.axis = .vertical
        verticalStackView.distribution = .fillEqually
        addSubview(verticalStackView)
        // Сохраним количество кнопок, которые нужно отобразить в меню в переменную.
        let count = textsArray.count
        // Исходя из значения этой переменной будет решаться сколько кнопок (1 или 2 штуки) нужно добавить в UIStackView.
        var i = 0
        // Цикл, в котором произойдет заполнение UIStackView кнопками.
        while i < count {
            // В этот массив добавим кнопки (1 или 2 штуки), который затем добавим в UIStackView.
            var buttonsArray: [AGTabBarPopupButton] = []
            // Если количество недобавленных кнопок от 2 и более,
            if count - i >= 2 {
                // то добавим сразу 2 кнопки.
                let b1 = AGTabBarPopupButton(width: popupMenuButtonWidth, height: popupMenuButtonHeight,
                                             buttonTitleKey: textsArray[i], icon: iconsArray[i],
                                             viewController: viewControllersArray[i])
                let b2 = AGTabBarPopupButton(width: popupMenuButtonWidth, height: popupMenuButtonHeight,
                                             buttonTitleKey: textsArray[i+1], icon: iconsArray[i+1],
                                             viewController: viewControllersArray[i+1])
                buttonsArray.append(b1)
                buttonsArray.append(b2)
            // А если осталась всего-лишь 1 недобавленная кнопка,
            } else {
                // то создадим только 1 объект кнопки с шириной во весь verticalStackView.
                let b1 = AGTabBarPopupButton(width: verticalStackView.frame.size.width, height: popupMenuButtonHeight,
                                             buttonTitleKey: textsArray[i], icon: iconsArray[i],
                                             viewController: viewControllersArray[i])
                buttonsArray.append(b1)
            }
            // Добавим непустой массив кнопок в UIStackView.
            let st = AGButtonsStackView(buttonsArray: buttonsArray, axis: .horizontal, spacing: 9, width: verticalStackView.frame.size.width)
            verticalStackView.addArrangedSubview(st)
            // Так как в 1-ой линии в меню должны быть максимум 2 кнопки, то следующая итерация начнётся с 3-тьей кнопки.
            i += 2
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
