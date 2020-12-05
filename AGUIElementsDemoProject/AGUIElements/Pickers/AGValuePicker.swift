//
//  AGValuePicker.swift
//  AGUIElementsDemoProject
//
//  Created by Артем Григорян on 29.11.2020.
//

import UIKit

class AGValuePicker: AGTextField {

    // MARK: - Variables
    
    private var separator = ""
    private var firstString = ""
    private var secondString = ""
    private var firstStringKey = ""
    private var secondStringKey = ""
    private let pickerFirstDataArray: [String]!
    private let pickerSecondDataArray: [String]!

    /* Сам пикер значений */
    private let valuePicker: UIPickerView = {
        let valuePicker = UIPickerView()
        valuePicker.backgroundColor = AGThemeManager.viewBackgroundColor

        return valuePicker
    }()
    
    // MARK: - Initializing

    init(isDetached: Bool, hintLabelTextTranslationKey: String!, pickerFirstDataArray: [String]!, defaultIndexForFirstArray: Int!, pickerSecondDataArray: [String] = [], defaultIndexForSecondArray: Int = 0, separator: String = "") {
        // Проинициализируем массивы с данными для пикера значений теми значениями, которые пришли из конструктора.
        self.pickerFirstDataArray = pickerFirstDataArray
        self.pickerSecondDataArray = pickerSecondDataArray
        // Сохраним ключ из первого массива, так как он понадобится в методе changeLanguage.
        firstStringKey = pickerFirstDataArray[defaultIndexForFirstArray]
        // Установим разделитель между массивами (например, точка, запятая, двоеточие).
        self.separator = separator
        // Сформируем строку, которая по умолчанию будет записана в текстовое поле пикера значений.
        let defaultValue: String!
        // Если второй массив не пустой,
        if !pickerSecondDataArray.isEmpty {
            // то сохраним первую строку по умолчанию для пикера в переменную, которая будет использоваться в didSelectRow,
            firstString = pickerFirstDataArray[defaultIndexForFirstArray]
            // сохраним вторую строку по умолчанию для пикера в переменную, которая будет использоваться в didSelectRow.
            secondString = pickerSecondDataArray[defaultIndexForSecondArray]
            // Сохраним ключ из второго массива, так как он понадобится в методе changeLanguage.
            secondStringKey = pickerSecondDataArray[defaultIndexForSecondArray]
            // и, таким образом, строка по умолчанию будет состоять из обоих переданных строк по умолчанию.
            if separator == "" {
                defaultValue = firstString.localize() + " " + secondString.localize()
            } else {
                defaultValue = firstString.localize() + separator + secondString.localize()
            }
        } else {
            // сохраним первую строку по умолчанию для пикера в переменную, которая будет использоваться в didSelectRow,
            firstString = pickerFirstDataArray[defaultIndexForFirstArray]
            // и, таким образом, строка по умолчанию будет состоять только из одной строки, полученной от первого массива с данными.
            defaultValue = firstString.localize()
        }
        // Вызовем конструктор базового класса - EMMATextField.
        super.init(isDetached: isDetached, textFieldText: defaultValue, fieldType: .pickerField)
        // У родительского класса установим ключ подсказки.
        super.hintLabelTextTranslationKey = hintLabelTextTranslationKey
        // У родительского класса установим текст подсказки.
        super.hintLabel.text = hintLabelTextTranslationKey.localize() + ":"
        // Создадим тулбар, чтобы иметь возможность закрывать клавиатуру после выбора значений.
        let toolbar = AGToolbar(type: .picker(hintLabelTextTranslationKey))
        // Станем делегатом тулбара, чтобы вызывать метод hideToolbar.
        toolbar.toolbarPickerDelegate = self
        // Укажем, что этот класс будет делегатом пикера значений.
        valuePicker.delegate = self
        // Укажем, что этот класс будет источником данных для пикера значений.
        valuePicker.dataSource = self
        // Поместим панель управления в текстовое поле.
        textField.inputAccessoryView = toolbar
        // Поместим пикер значений в текстовое поле.
        textField.inputView = valuePicker
        // Установим выбранные по умолчанию значения при нажатии на пикер значений.
        if !pickerSecondDataArray.isEmpty {
            // При выборе пикера для первого массива данных по умолчанию будет выбрано то значение, индекс которого был передано в конструктор.
            valuePicker.selectRow(defaultIndexForFirstArray, inComponent: 0, animated: false)
            // При выборе пикера для второго массива данных по умолчанию будет выбрано то значение, индекс которого был передано в конструктор.
            valuePicker.selectRow(defaultIndexForSecondArray, inComponent: 1, animated: false)
        } else {
            // При выборе пикера для первого массива данных по умолчанию будет выбрано то значение, индекс которого был передано в конструктор.
            valuePicker.selectRow(defaultIndexForFirstArray, inComponent: 0, animated: false)
        }
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
        valuePicker.backgroundColor = AGThemeManager.viewBackgroundColor
    }
    
    /* Метод обновит язык компонента */
    @objc override func changeLanguage() {
        super.changeLanguage()
        firstString = firstStringKey.localize()
        secondString = secondStringKey.localize()

        if separator == "" {
            textField.text = firstString + " " + secondString
        } else {
            textField.text = firstString + separator + secondString
        }
    }
}

// MARK: - Extensions

extension AGValuePicker: UIPickerViewDelegate, UIPickerViewDataSource {
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        if component == 0 {
            return NSAttributedString(string: pickerFirstDataArray[row].localize(), attributes: [NSAttributedString.Key.foregroundColor : AGThemeManager.textFieldTextColor])
        } else if component == 1 && separator != "" {
            return NSAttributedString(string: separator, attributes: [NSAttributedString.Key.foregroundColor : AGThemeManager.textFieldTextColor])
        }
    
        return NSAttributedString(string: pickerSecondDataArray[row].localize(), attributes: [NSAttributedString.Key.foregroundColor : AGThemeManager.textFieldTextColor])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 && separator != "" {
            firstStringKey = pickerFirstDataArray[row]
            firstString = pickerFirstDataArray[row].localize()
            textField.text = String(format: "%@%@%@", firstString, separator, secondString)
        } else if component == 0 && separator == "" {
            firstStringKey = pickerFirstDataArray[row]
            firstString = pickerFirstDataArray[row].localize()
            textField.text = String(format: "%@ %@", firstString, secondString)
        } else if component == 1 && separator == "" {
            secondStringKey = pickerSecondDataArray[row]
            secondString = pickerSecondDataArray[row].localize()
            textField.text = String(format: "%@ %@", firstString.localize(), secondString)
        } else {
            secondStringKey = pickerSecondDataArray[row]
            secondString = pickerSecondDataArray[row].localize()
            textField.text = String(format: "%@%@%@", firstString.localize(), separator, secondString)
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return pickerFirstDataArray.count
        } else if component == 1 && separator != "" {
            return 1
        }
        
        return pickerSecondDataArray.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if pickerSecondDataArray.isEmpty {
            return 1
        } else if separator == "" {
            return 2
        }
    
        return 3
    }
}

extension AGValuePicker: ToolbarPickerProtocol {
    func submitToolbarButtonTouched() {
        endEditing(true)
    }
    
    func cancelToolbarButtonTouched() {
        endEditing(true)
    }
}
