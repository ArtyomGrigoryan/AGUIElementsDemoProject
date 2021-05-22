//
//  AGButtonsStackView.swift
//  AGUIElementsDemoProject
//
//  Created by Артем Григорян on 29.11.2020.
//

import UIKit

class AGButtonsStackView: UIStackView {

    // MARK: - Initializing
    
    init(buttonsArray: [AGButton], axis: NSLayoutConstraint.Axis, spacing: CGFloat, width: CGFloat = UIScreen.main.bounds.size.width - 32) {
        // Установим в переменную buttonsArrayCount количество переданных текстовых полей.
        let buttonsArrayCount = buttonsArray.count
        // Переменная для хранения высоты стека.
        var stackViewHeight: CGFloat!
        // В зависимости от переданной оси, проведем расчеты высоты стека.
        switch axis {
        case .horizontal:
            stackViewHeight = buttonsArray.first!.frame.size.height
        case .vertical:
            stackViewHeight = CGFloat(integerLiteral: buttonsArrayCount) * buttonsArray.first!.frame.size.height + CGFloat(integerLiteral: ((buttonsArrayCount - 1) * 12))
        @unknown default:
            fatalError("В будущих версиях Apple поменяла оси :D")
        }
        // Вызовем конструктор родительского класса, установим ширину и высоту стека с кнопками.
        super.init(frame: CGRect(x: 0, y: 0, width: width, height: stackViewHeight))
        // Произведем настройки
        super.spacing = spacing
        super.axis = axis
        distribution = .fillEqually
        alignment = .fill
        translatesAutoresizingMaskIntoConstraints = false
        // Пройдемся по массиву с кнопками,
        for button in buttonsArray {
            // и добавим их на UIStackView.
            addArrangedSubview(button)
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
