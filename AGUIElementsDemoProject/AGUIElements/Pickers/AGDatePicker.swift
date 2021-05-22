//
//  AGDatePicker.swift
//  AGUIElementsDemoProject
//
//  Created by Артем Григорян on 29.11.2020.
//

import UIKit

class AGDatePicker: AGTextField {
    
    /* Пикер даты */
    private let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.maximumDate = Date()
        datePicker.datePickerMode = .dateAndTime
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.setValue(false, forKey: "highlightsToday")
        datePicker.backgroundColor = AGThemeManager.viewBackgroundColor
        datePicker.setValue(AGThemeManager.textFieldTextColor, forKeyPath: "textColor")
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        // Если в региональных настройках iPhone выбран регион, где применяют AM и PM,
        if !AGTimeFormatManager.is24HourTimeFormat {
            // то в пикерах нужно будет их показывать.
            datePicker.locale = Locale(identifier: AGConstants.Languages.english.rawValue)
        } else {
            // Иначе, просто поменяем язык у пикера.
            if AGLanguageManager.currentLanguage == AGConstants.Languages.english {
                // Если оставить просто en, то будут AM и PM, что при русском регионе в Настройках iPhone не нужно.
                datePicker.locale = Locale(identifier: "en_GB")
            } else {
                // Пока только два языка, поэтому такая запись допустима.
                datePicker.locale = Locale(identifier: AGLanguageManager.currentLanguage.rawValue)
            }
        }
        
        return datePicker
    }()
    
    /* Форматтер даты */
    private let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: AGLanguageManager.currentLanguage.rawValue)

        return formatter
    }()
    
    // MARK: - Initializing

    init(isDetached: Bool, datePickerMode: UIDatePicker.Mode, hintLabelTextTranslationKey: String!) {
        // Получим текущее время.
        let date = Date()
        // В зависимоти от требуемого мода времени, установим соответствующие форматы.
        switch datePickerMode {
        case .dateAndTime:
            if AGTimeFormatManager.is24HourTimeFormat {
                formatter.dateFormat = "dd MMM yyyy HH:mm"
            } else {
                formatter.dateFormat = "dd MMM yyyy h:mm a"
            }
        case .date:
            formatter.dateFormat = "dd MMM yyyy"
        default:
            break;
        }
        // Перегоним текущую дату в строку, используя вышевыбранный формат времени.
        let currentDate = formatter.string(from: date)
        // Вызовем конструктор базового класса - EMMATextField.
        super.init(isDetached: isDetached, textFieldText: currentDate, fieldType: .pickerField)
        // У родительского класса установим ключ подсказки.
        super.hintLabelTextTranslationKey = hintLabelTextTranslationKey
        // У родительского класса установим текст подсказки.
        super.hintLabel.text = hintLabelTextTranslationKey.localize() + ":"
        // Создадим тулбар, чтобы иметь возможность закрывать клавиатуру после выбора даты.
        let toolbar = AGToolbar(type: .picker(hintLabelTextTranslationKey))
        // Станем делегатом тулбара, чтобы вызывать метод hideToolbar.
        toolbar.toolbarPickerDelegate = self
        // Поместим панель управления в текстовое поле.
        textField.inputAccessoryView = toolbar
        // Настроим пикер даты, в соответствие с переданными параметрами.
        datePicker.datePickerMode = datePickerMode
        // Поместим пикер даты в текстовое поле.
        textField.inputView = datePicker
        // Подпишемся на уведомления об изменении темы приложения.
        NotificationCenter.default.addObserver(self, selector: #selector(updateColors), name: .updateColors, object: nil)
        // Подпишемся на уведомления об изменении языка приложения.
        NotificationCenter.default.addObserver(self, selector: #selector(changeLanguage), name: .changeLanguage, object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Notification functions

    /* Метод обновит цвета согласно выбранной пользователем темы */
    @objc override func updateColors() {
        super.updateColors()
        textField.tintColor = .clear
        datePicker.backgroundColor = AGThemeManager.viewBackgroundColor
        datePicker.setValue(AGThemeManager.textFieldTextColor, forKeyPath: "textColor")
    }
    
    /* Метод обновит язык компонента */
    @objc override func changeLanguage() {
        super.changeLanguage()
        // Получим текущую дату из текстового поля.
        let currentDate = formatter.date(from: textField.text!)
        // Если в региональных настройках iPhone выбран регион, где применяют AM и PM,
        if !AGTimeFormatManager.is24HourTimeFormat {
            // то в пикерах нужно будет их показывать.
            datePicker.locale = Locale(identifier: AGConstants.Languages.english.rawValue)
        } else {
            // Иначе, просто поменяем язык у пикера.
            if AGLanguageManager.currentLanguage == AGConstants.Languages.english {
                // Если оставить просто en, то будут AM и PM, что при русском регионе в Настройках iPhone не нужно.
                datePicker.locale = Locale(identifier: "en_GB")
            } else {
                // Пока только два языка, поэтому такая запись допустима.
                datePicker.locale = Locale(identifier: AGLanguageManager.currentLanguage.rawValue)
            }
        }
        // У форматтера тоже нужно менять, чтобы при выборе даты в текстовое поле записывалась дата в нужном (текущем) языке.
        formatter.locale = Locale(identifier: AGLanguageManager.currentLanguage.rawValue)
        // Обновим запись в текстовом поле.
        textField.text = formatter.string(from: currentDate!)
    }
}

// MARK: - Extensions

extension AGDatePicker: ToolbarPickerProtocol {
    /* Этот метод закрывает пикер даты при нажатии на кнопку "Подтвердить" на тулбаре и сохраняет выбранную дату в текстовое поле */
    func submitToolbarButtonTouched() {
        // Установим выбранную дату в текстовое поле, предварительно отформатировав её.
        textField.text = formatter.string(from: datePicker.date)
        // Закроем пикер даты.
        endEditing(true)
    }
    
    /* Этот метод просто закрывает пикер даты без сохранения даты в текстовое поле */
    func cancelToolbarButtonTouched() {
        endEditing(true)
    }
}
