//
//  AGTextField.swift
//  AGUIElementsDemoProject
//
//  Created by Артем Григорян on 29.11.2020.
//

import UIKit

protocol AGTextFieldDelegate {
    func textFieldBeginEditing(_ textField: AGTextField)
    func textFieldEndEditing(_ textField: AGTextField)
}

enum AGTextFieldType: Equatable {
    case textField
    case emailField
    case phoneField
    case pickerField
    case passwordField(withRegex: AGTextFieldRegex)
}

enum AGTextFieldRegex: Equatable {
    case defaultRegex
    case customRegex(String)
}

private enum AGTextFieldVisualStyle {
    case normal
    case wrong
}

private enum AGTextFieldState {
    case inactive
    case active
}

class AGTextField: AGView {
    
    // MARK: - Variables
    
    private var textFieldActiveStateTopConstraint = NSLayoutConstraint()
    private var textFieldNotActiveStateTopConstraint = NSLayoutConstraint()
    private var textFieldActiveStateBottomConstraint = NSLayoutConstraint()
    private var textFieldNotActiveStateBottomConstraint = NSLayoutConstraint()
    private var placeholderTextTranslationKey: String!
    private var placeholderText: String!
    private var fieldType: AGTextFieldType!
    private lazy var passwordRegex = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{6,}$"
    private let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    private let phoneRegex = try! NSRegularExpression(pattern: "[\\+\\s-\\(\\)]", options: .caseInsensitive)

    var hintLabelTextTranslationKey: String!
    var delegate: AGTextFieldDelegate?

    /* Лейбл подсказка, которое появляется сверху от текстового поля */
    let hintLabel: UILabel = {
        let hintLabel = UILabel()
        hintLabel.textColor = AGThemeManager.textFieldHintColor
        hintLabel.font = AGFontsManager.littleSF
        hintLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return hintLabel
    }()

    /* Само текстовое поле, куда будет осуществляться ввод данных пользователем */
    let textField: UITextField = {
        let textField = UITextField()
        textField.textColor = AGThemeManager.textFieldTextColor
        textField.tintColor = AGThemeManager.textFieldHintColor
        textField.font = AGFontsManager.mediumSF
        textField.autocorrectionType = .no
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    // MARK: - Initializing
    
    /* Конструктор инициализирует текстовое поле и лейбл-подсказку данными, и настраивает их визуальные атрибуты */
    init(isDetached: Bool, textFieldText: String!, placeholderTextTranslationKey: String = "", keyboardType: UIKeyboardType = .default, fieldType: AGTextFieldType = .textField, width: CGFloat = UIScreen.main.bounds.size.width - 32, height: CGFloat = 62) {
        // Вызовем конструктор базового класса - AGView.
        super.init(width: width, height: height)
        // Запомним тип поля, так как его придется проверять в textFieldDidEndEditing.
        self.fieldType = fieldType
        // Сохраним ключ, так как он будет использоваться в методе changeLanguage.
        self.placeholderTextTranslationKey = placeholderTextTranslationKey
        // Для подсказок будет использован ключ плейсхолдера (эта строка нужна для классов-наследников).
        self.hintLabelTextTranslationKey = placeholderTextTranslationKey
        // Нужно сохранить текст плейсхолдера, так как он будет стираться при нажатии на текстовое поле.
        self.placeholderText = placeholderTextTranslationKey.localize()
        // Установим тип клавиатуры для поля.
        textField.keyboardType = keyboardType
        // Если текстовое поле не находится в блоке с другими текстовыми полями,
        if isDetached {
            // то к нему нужно добавить тени и закругление углов.
            layer.cornerRadius = 4
            layer.shadowPath = UIBezierPath(rect: bounds).cgPath
            layer.shadowOffset = CGSize(width: 0, height: 1)
            layer.shadowOpacity = 0.1
            layer.shadowRadius = 4
            layer.shadowColor = AGThemeManager.shadowColor.cgColor
        }
        // Определим с полем какого типа нужно работать.
        switch fieldType {
        // Если это поле должно быть предназначено для ввода почты,
        case .emailField:
            // то изменим тип клавиатуры.
            textField.keyboardType = .emailAddress
            break
        // Если это поле должно быть предназначено для ввода пароля,
        case .passwordField(let whatRegex):
            // то определим какой регекс нужно использовать.
            switch whatRegex {
            // Если не дефолтный регекс,
            case .customRegex(let passwordRegex):
                // то его нужно использовать вместо дефолтного регекса.
                self.passwordRegex = passwordRegex
            default:
                break
            }
            // Укажем, что при вводе символов они должны заменяться на точки на экране.
            textField.isSecureTextEntry = true
            break
        // Если это поле должно быть предназначено для пикеров,
        case .pickerField:
            // то создадим иконку стрелки,
            let rightArrowImageView = UIImageView(image: UIImage(named: "arrowRightIcon.png"))
            // и добавим её на EMMATextField.
            addSubview(rightArrowImageView)
            // Расставим констрейнты.
            rightArrowImageView.translatesAutoresizingMaskIntoConstraints = false
            rightArrowImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            rightArrowImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
            // Скроем курсор ввода текста, так как текст берется из пикеров.
            textField.tintColor = .clear
            break
        default:
            break
        }
        // Создадим тулбар, чтобы иметь возможность закрывать клавиатуру после ввода текста.
        let toolbar = AGToolbar(type: .textField)
        // Станем делегатом тулбара, чтобы вызывать метод hideToolbar.
        toolbar.toolbarTextFieldDelegate = self
        // Проинициализируем текстовое поле переданными данными.
        textField.text = textFieldText.localize()
        textField.inputAccessoryView = toolbar
        textField.placeholder = placeholderText
        textField.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: [NSAttributedString.Key.foregroundColor: AGThemeManager.textFieldHintColor, NSAttributedString.Key.font: AGFontsManager.mediumSF])
        // Будем делегатом, чтобы пользоваться методами UITextFieldDelegate.
        textField.delegate = self
        // Добавим текстовое поле на вью-контейнер.
        addSubview(textField)
        // Установим левые и правые констрейнты для текстового поля. Они константа.
        textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        textField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        // Установим констрейнты для текстового поля, если оно не активно.
        textFieldNotActiveStateTopConstraint = textField.topAnchor.constraint(equalTo: topAnchor, constant: 20)
        textFieldNotActiveStateBottomConstraint = textField.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -22)
        // Установим констрейнты для текстового поля, если оно активно.
        textFieldActiveStateTopConstraint = textField.topAnchor.constraint(equalTo: topAnchor, constant: 30)
        textFieldActiveStateBottomConstraint = textField.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12)
        // Проинициализируем лейбл-подсказку переданными данными.
        hintLabel.text = placeholderText + ":"
        // Добавим лейбл-подсказку на вью-контейнер.
        addSubview(hintLabel)
        // Установим констрейнты для лейбла-подсказки к вью-контейнеру.
        hintLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        hintLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        hintLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -32).isActive = true
        // Если для текстового поля нет заранее подготовленного текста,
        if textFieldText.count == 0 {
            // то отобразим текстовое поле как неактивное (как-будто пользователь не нажимал на текстовое поле),
            changeTextFieldState(to: .inactive)
        } else {
            // иначе - покажем его активным (как-будто пользователь нажал на текстовое поле).
            changeTextFieldState(to: .active)
        }
        // Подпишемся на уведомления об изменении темы приложения.
        NotificationCenter.default.addObserver(self, selector: #selector(updateColors), name: .updateColors, object: nil)
        // Подпишемся на уведомления об изменении языка приложения.
        NotificationCenter.default.addObserver(self, selector: #selector(changeLanguage), name: .changeLanguage, object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    // MARK: - Private functions
    
    /* Этот метод вызывается, если нужно изменить состояние текстового поля */
    private func changeTextFieldState(to state: AGTextFieldState) {
        switch state {
        // Если пользователь не нажал на текстовое поле,
        case .inactive:
            // то установим констрейнты для текстового поля к вью-контейнеру, если пользователь нажал на другое место на экране.
            NSLayoutConstraint.deactivate([textFieldActiveStateTopConstraint, textFieldActiveStateBottomConstraint])
            NSLayoutConstraint.activate([textFieldNotActiveStateTopConstraint, textFieldNotActiveStateBottomConstraint])
            // Изменим данные текстового поля.
            changeTextFieldData(hintLabelAlpha: 0, placeholderText: placeholderTextTranslationKey.localize())
        // Если пользователь нажал на текстовое поле,
        case .active:
            // то установим констрейнты для текстового поля к вью-контейнеру, если пользователь нажал на текстовое поле.
            NSLayoutConstraint.deactivate([textFieldNotActiveStateTopConstraint, textFieldNotActiveStateBottomConstraint])
            NSLayoutConstraint.activate([textFieldActiveStateTopConstraint, textFieldActiveStateBottomConstraint])
            // Изменим данные текстового поля.
            changeTextFieldData(hintLabelAlpha: 1)
        }
    }
    
    /* Этот метод меняет отображение данных на текстовом поле */
    private func changeTextFieldData(hintLabelAlpha: CGFloat, placeholderText: String = "") {
        // Скроем или покажем подсказку (в зависимости от передаваемой альфы).
        hintLabel.alpha = hintLabelAlpha
        // Установим текст в плейсхолдер текстового поля.
        textField.placeholder = placeholderText
    }
    
    /* Этот метод проверяет пришедшую строку на принадлежность к почтовому типу */
    private func checkEmailValidation(with email: String) {
        // Проверим пришедшую почту на принадлежность к корректному почтовому типу.
        if email.range(of: emailRegex, options: .regularExpression, range: nil, locale: nil) != nil {
            // Если почта валидна, то придадим текстовому полю внешний вид по умолчанию.
            changeTextFieldBorderAndHintStyle(textFieldVisualStyle: .normal)
        } else {
            // Если нет, то внешний вид поля будет сигнализировать ошибку.
            changeTextFieldBorderAndHintStyle(textFieldVisualStyle: .wrong)
        }
    }
    
    /* Этот метод проверяет пришедшую строку с паролем на принадлежность к паролевому регексу */
    private func checkPasswordValidation(password: String) {
        // Если введенный пароль совпадает с паролевым регексом,
        if password.range(of: passwordRegex, options: .regularExpression, range: nil, locale: nil) != nil {
            // то придадим текстовому полю внешний вид по умолчанию.
            changeTextFieldBorderAndHintStyle(textFieldVisualStyle: .normal)
        } else {
            // Если нет, то внешний вид поля будет сигнализировать ошибку.
            changeTextFieldBorderAndHintStyle(textFieldVisualStyle: .wrong)
        }
    }
    
    /* Этот метод форматирует строку в формат телефонного номера */
    private func format(phoneNumber: String, shouldRemoveLastDigit: Bool) -> String {
        guard !(shouldRemoveLastDigit && phoneNumber.count <= 2) else { return "+" }
        let maxNumberCount = 11
        let range = NSString(string: phoneNumber).range(of: phoneNumber)
        var number = phoneRegex.stringByReplacingMatches(in: phoneNumber, options: [], range: range, withTemplate: "")
        
        if number.count > maxNumberCount {
            let maxIndex = number.index(number.startIndex, offsetBy: maxNumberCount)
            number = String(number[number.startIndex..<maxIndex])
        }
        
        if shouldRemoveLastDigit {
            let maxIndex = number.index(number.startIndex, offsetBy: number.count - 1)
            number = String(number[number.startIndex..<maxIndex])
        }
        
        let maxIndex = number.index(number.startIndex, offsetBy: number.count)
        let regRange = number.startIndex..<maxIndex
        
        if number.count < 7 {
            let pattern = "(\\d)(\\d{3})(\\d+)"
            number = number.replacingOccurrences(of: pattern, with: "$1 ($2) $3", options: .regularExpression, range: regRange)
        } else {
            let pattern = "(\\d)(\\d{3})(\\d{3})(\\d{2})(\\d+)"
            number = number.replacingOccurrences(of: pattern, with: "$1 ($2) $3-$4-$5", options: .regularExpression, range: regRange)
        }
        
        return "+" + number
    }
    
    /* Этот метод перекрашивает границы и подсказку текстового поля в цвета, сигнализирующие о корректности или некорректности данных в нём */
    private func changeTextFieldBorderAndHintStyle(textFieldVisualStyle: AGTextFieldVisualStyle) {
        switch textFieldVisualStyle {
        case .normal:
            hintLabel.textColor = AGThemeManager.textFieldHintColor
            layer.borderWidth = 0
            layer.borderColor = UIColor.clear.cgColor
        case .wrong:
            hintLabel.textColor = AGThemeManager.errorColor
            layer.borderWidth = 1
            layer.borderColor = AGThemeManager.errorColor.cgColor
        }
    }
    
    // MARK: - Notification functions

    /* Метод обновит цвета согласно выбранной пользователем темы */
    @objc override func updateColors() {
        super.updateColors()
        hintLabel.textColor = AGThemeManager.textFieldHintColor
        textField.textColor = AGThemeManager.textFieldTextColor
        textField.tintColor = AGThemeManager.textFieldHintColor
        textField.keyboardAppearance = AGThemeManager.keyboardAppearance
    }
    
    /* Метод обновит язык компонента */
    @objc func changeLanguage() {
        textField.placeholder = placeholderTextTranslationKey.localize()
        hintLabel.text = hintLabelTextTranslationKey.localize() + ":"
    }
}

// MARK: - Extensions

extension AGTextField: UITextFieldDelegate {
    /* Вызывается, если пользователь нажал на поле */
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Переведем поле в активное состояние,
        changeTextFieldState(to: .active)
        // и скажем это делегату.
        delegate?.textFieldBeginEditing(self)
    }
   
    /* Вызывается, если пользователь ушёл с поля */
    func textFieldDidEndEditing(_ textField: UITextField) {
        // Если количество введенного текста равно 0,
        if textField.text!.count == 0 {
            // то переведем поле в неактивное состояние.
            changeTextFieldState(to: .inactive)
        }
        // Узнаем с каким типом поля на данный момент велась работа.
        switch fieldType {
        // Если это поле было для почты,
        case .emailField:
            // то проверим текущий текст на принадлежность к почтовому типу.
            checkEmailValidation(with: textField.text!)
        // Если это поле было для пароля,
        case .passwordField( _):
            // то проверим текущий текст на принадлежность к паролевому регексу.
            checkPasswordValidation(password: textField.text!)
        default:
            break
        }
        // Скажем делегату, что с этим полем взаимодействие больше не происходит.
        delegate?.textFieldEndEditing(self)
    }
    
    /* Вызывается, если пользователь что-то вводит в поле */
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Если это поле должно быть для ввода телефонного номера,
        if fieldType == .phoneField {
            // то осуществим форматирование вводимых символов в формат телефонного номера.
            let fullString = (textField.text ?? "") + string
            textField.text = format(phoneNumber: fullString, shouldRemoveLastDigit: range.length == 1)
            
            return false
        }
        
        return true
    }
}

extension AGTextField: ToolbarTextFieldProtocol {
    /* Этот метод закрывает клавиатуру при нажатии на кнопку "Закрыть" на тулбаре */
    @objc func hideToolbar() {
        endEditing(true)
    }
}
