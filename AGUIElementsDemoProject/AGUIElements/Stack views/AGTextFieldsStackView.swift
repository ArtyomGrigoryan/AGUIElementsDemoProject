//
//  AGTextFieldsStackView.swift
//  AGUIElementsDemoProject
//
//  Created by Артем Григорян on 29.11.2020.
//

import UIKit

private enum AGLineViewPosition {
    case top
    case bottom
}

class AGTextFieldsStackView: AGView {
    
    // MARK: - Variables

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 0
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()

    // MARK: - Initializing
    
    init(textFieldsArray: [AGTextField]) {
        // Установим в переменную textFieldsArrayCount количество переданных текстовых полей.
        let textFieldsArrayCount = textFieldsArray.count
        // Посчитаем высоту стека, которая должна быть, чтобы все переданные текстовые поля в ней поместились.
        let stackViewHeight = CGFloat(CGFloat(textFieldsArrayCount) * textFieldsArray.first!.frame.size.height)
        // Установим ширину стека.
        let stackViewWidth = textFieldsArray.first!.frame.size.width
        // Вызовем конструктор родительского класса, установим ширину и высоту стека с текстовыми полями.
        super.init(width: stackViewWidth, height: stackViewHeight)
        // Настроим внешний вид стека с текстовыми полями.
        layer.cornerRadius = 4
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowOpacity = 0.1
        layer.shadowRadius = 4
        layer.shadowColor = AGThemeManager.shadowColor.cgColor
        // Пройдемся по массиву с текстовыми полями,
        for (index, textField) in textFieldsArray.enumerated() {
            // и добавим их на UIStackView.
            stackView.addArrangedSubview(textField)
            // Если текущий в цикле элемент - первый,
            if index == 0 {
                // закруглим верхние края текстового поля,
                textField.layer.cornerRadius = 4
                textField.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
                // добавим к нижней части текстового поля полоску.
                createLineView(for: textField, position: .bottom)
            // Если текущий в цикле элемент - последний,
            } else if index == textFieldsArrayCount - 1 {
                // закруглим нижние края текстового поля,
                textField.layer.cornerRadius = 4
                textField.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
                // добавим к верхней части текстового поля полоску.
                createLineView(for: textField, position: .top)
            // Если текущий элемент не последний и не первый,
            } else {
                // добавим к верхней части текстового поля полоску,
                createLineView(for: textField, position: .top)
                // и добавим к нижней части текстового поля полоску.
                createLineView(for: textField, position: .bottom)
            }
        }
        // Добавим UIStackView на стек.
        addSubview(stackView)
        // Расставим для него констрейнты относительно стека.
        setupConstraints(from: stackView, to: self, height: stackViewHeight, width: stackViewWidth, topConstant: 0, bottomConstant: 0, leadingConstant: 0, trailingConstant: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private functions
    
    /* Метод делает тонкую полоску, которая будет прикреплена к верхней или нижней части текстового поля */
    private func createLineView(for textField: AGTextField, position: AGLineViewPosition) {
        let lineView = UIView()
        lineView.backgroundColor = AGThemeManager.textFieldStackViewLineColor
        lineView.translatesAutoresizingMaskIntoConstraints = false
        // Добавим полоску к текстовому полю.
        textField.addSubview(lineView)
        // Укажем соответствующие констрейнты для полоски, в зависимости от желаемого положения полоски на текстовом поле.
        switch position {
        case .top:
            setupConstraints(from: lineView, to: textField, height: 0.5, width: textField.frame.size.width - 16, topConstant: 0, bottomConstant: 0.5 - textField.frame.size.height, leadingConstant: 16, trailingConstant: 0)
        case .bottom:
            setupConstraints(from: lineView, to: textField, height: 0.5, width: textField.frame.size.width - 16, topConstant: textField.frame.size.height - 0.5, bottomConstant: 0, leadingConstant: 16, trailingConstant: 0)
        }
    }

    /* Метод расставляет констрейнты */
    private func setupConstraints(from view: UIView, to: UIView, height: CGFloat, width: CGFloat, topConstant: CGFloat, bottomConstant: CGFloat, leadingConstant: CGFloat, trailingConstant: CGFloat) {
        view.heightAnchor.constraint(equalToConstant: height).isActive = true
        view.widthAnchor.constraint(equalToConstant: width).isActive = true
        view.leadingAnchor.constraint(equalTo: to.leadingAnchor, constant: leadingConstant).isActive = true
        view.trailingAnchor.constraint(equalTo: to.trailingAnchor, constant: trailingConstant).isActive = true
        view.topAnchor.constraint(equalTo: to.topAnchor, constant: topConstant).isActive = true
        view.bottomAnchor.constraint(equalTo: to.bottomAnchor, constant: bottomConstant).isActive = true
    }
}
