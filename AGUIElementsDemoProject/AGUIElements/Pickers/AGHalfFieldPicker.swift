//
//  AGHalfFieldPicker.swift
//  AGUIElementsDemoProject
//
//  Created by Артем Григорян on 29.11.2020.
//

import UIKit

class AGHalfFieldPicker: AGTextField {
    
    // MARK: - Variables
    
    var counter = 0

    /* View, куда будут помещены пикер даты и вью количества */
    private let mainView: UIView = {
        let mainView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 266))
        mainView.translatesAutoresizingMaskIntoConstraints = false
        mainView.backgroundColor = AGThemeManager.viewBackgroundColor
        
        return mainView
    }()
    
    /* View количества */
    private let countsView: UIView = {
        let countsView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 50))
        countsView.translatesAutoresizingMaskIntoConstraints = false
        countsView.backgroundColor = AGThemeManager.viewBackgroundColor
        
        return countsView
    }()
    
    /* Кнопка уменьшения количества */
    private let minusButton: UIButton = {
        let minusButton = UIButton()
        minusButton.addTarget(self, action: #selector(changeCounterValue(_:)), for: .touchUpInside)
        minusButton.setImage(UIImage(named: "minusIcon.png")?.withTintColor(AGThemeManager.halfPickerButtonImageTintColor), for: .normal)
        minusButton.translatesAutoresizingMaskIntoConstraints = false
        
        return minusButton
    }()
    
    /* Кнопка увеличения количества */
    private let plusButton: UIButton = {
        let plusButton = UIButton()
        plusButton.addTarget(self, action: #selector(changeCounterValue(_:)), for: .touchUpInside)
        plusButton.setImage(UIImage(named: "plusIcon.png")?.withTintColor(AGThemeManager.halfPickerButtonImageTintColor), for: .normal)
        plusButton.translatesAutoresizingMaskIntoConstraints = false

        return plusButton
    }()
    
    /* Лейбл количества, который появляется при вызове пикера */
    private let countLabel: UILabel = {
        let countLabel = UILabel()
        countLabel.textColor = AGThemeManager.halfPickerHintCountLabelColor
        countLabel.font = AGFontsManager.bigSF
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return countLabel
    }()
    
    /* Лейбл количества рядом с лейблом-подсказкой "Количество" */
    private let hintCountLabel: UILabel = {
        let hintCountLabel = UILabel()
        hintCountLabel.textColor = AGThemeManager.halfPickerHintCountLabelColor
        hintCountLabel.font = AGFontsManager.littleSF
        hintCountLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return hintCountLabel
    }()
    
    /* Пикер даты */
    private let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.backgroundColor = AGThemeManager.viewBackgroundColor
        datePicker.maximumDate = Date() // Изменить это
        datePicker.datePickerMode = .time
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.setValue(AGThemeManager.textFieldTextColor, forKeyPath: "textColor")
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        // Если в региональных настройках iPhone выбран регион, где применяют AM и PM,
        if !AGTimeFormatManager.is24HourTimeFormat {
            // то в пикерах нужно будет их показывать.
            datePicker.locale = Locale(identifier: AGConstants.Languages.english.rawValue)
        } else {
            // Иначе, покажем 24-ой формат времени.
            datePicker.locale = Locale(identifier: "en_GB")
        }
         
        return datePicker
    }()
     
    /* Форматтер даты */
    private let formatter: DateFormatter = {
        let formatter = DateFormatter()
        
        if AGTimeFormatManager.is24HourTimeFormat {
            formatter.dateFormat = "HH:mm"
        } else {
            formatter.dateFormat = "h:mm a"
        }

        return formatter
    }()

    // MARK: - Initializers

    init(isDetached: Bool, datePickerMode: UIDatePicker.Mode, hintLabelTextTranslationKey: String!, counterValue: Int = 1) {
        // Узнаем текущее время, чтобы отправить в конструктор родительского класса.
        let currentTime = formatter.string(from: Date())
        // Вызовем конструктор базового класса - EMMATextField.
        super.init(isDetached: isDetached, textFieldText: currentTime, fieldType: .pickerField, width: UIScreen.main.bounds.size.width / 2 - 26, height: 62)
        // У родительского класса установим ключ подсказки.
        super.hintLabelTextTranslationKey = hintLabelTextTranslationKey
        // У родительского класса установим текст подсказки.
        super.hintLabel.text = hintLabelTextTranslationKey.localize() + ":"
        // Установим счётчик количества на переданное значение.
        counter = counterValue
        // Создадим тулбар, чтобы иметь возможность закрывать клавиатуру после выбора значений.
        let toolbar = AGToolbar(type: .picker(hintLabelTextTranslationKey))
        // Станем делегатом тулбара, чтобы вызывать метод hideToolbar.
        toolbar.toolbarPickerDelegate = self
        // Поместим панель управления в текстовое поле.
        textField.inputAccessoryView = toolbar
        // Добавим лейбл-подсказку количества.
        addSubview(hintCountLabel)
        // Присвоим лейблу-подсказке количества само количество.
        hintCountLabel.text = String(counter)
        // Установим для лейбла-подсказки количества констрейнты.
        hintCountLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        hintCountLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -32).isActive = true
        hintCountLabel.leadingAnchor.constraint(equalTo: hintLabel.trailingAnchor, constant: 2).isActive = true
        // Добавим в главное вью пикер даты.
        mainView.addSubview(datePicker)
        // Установим констрейнты для пикера даты.
        setupConstraints(from: datePicker, to: mainView, width: UIScreen.main.bounds.size.width, topConstant: 0, bottomConstant: -50, leadingConstant: 0, trailingConstant: 0)
        // Добавим в главное вью вью с кнопками изменения количества.
        mainView.addSubview(countsView)
        // Установим констрейнты для вью количества.
        countsView.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 0).isActive = true
        countsView.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: 0).isActive = true
        countsView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 0).isActive = true
        countsView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: 0).isActive = true
        // Добавим кнопку "-" на соответствующее вью.
        countsView.addSubview(minusButton)
        // Установим констрейнты для кнопки "-".
        setupConstraints(from: minusButton, to: countsView, width: 32, topConstant: 3, bottomConstant: -15, leadingConstant: 16, trailingConstant:  -(UIScreen.main.bounds.size.width - 48))
        // Добавим кнопку "+" на соответствующее вью.
        countsView.addSubview(plusButton)
        // Установим констрейнты для кнопки "+".
        setupConstraints(from: plusButton, to: countsView, width: 32, topConstant: 3, bottomConstant: -15, leadingConstant: (UIScreen.main.bounds.size.width - 48), trailingConstant: -16)
        // Добавим лейбл с количеством.
        countsView.addSubview(countLabel)
        // Присвоим лейблу количества само количество.
        countLabel.text = String(counter)
        // Установим констрейнты для лейбла с количеством.
        countLabel.centerXAnchor.constraint(equalTo: countsView.centerXAnchor).isActive = true
        countLabel.topAnchor.constraint(equalTo: countsView.topAnchor, constant: 3).isActive = true
        // Поместим вью с пикером даты и выбором количества в текстовое поле.
        textField.inputView = mainView
        // Подпишемся на уведомления об изменении темы приложения.
        NotificationCenter.default.addObserver(self, selector: #selector(updateColors), name: .updateColors, object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private functions
    
    /* Метод расставляет констрейнты */
    private func setupConstraints(from view: UIView, to: UIView, width: CGFloat, topConstant: CGFloat, bottomConstant: CGFloat, leadingConstant: CGFloat, trailingConstant: CGFloat) {
        view.widthAnchor.constraint(equalToConstant: width).isActive = true
        view.topAnchor.constraint(equalTo: to.topAnchor, constant: topConstant).isActive = true
        view.bottomAnchor.constraint(equalTo: to.bottomAnchor, constant: bottomConstant).isActive = true
        view.leadingAnchor.constraint(equalTo: to.leadingAnchor, constant: leadingConstant).isActive = true
        view.trailingAnchor.constraint(equalTo: to.trailingAnchor, constant: trailingConstant).isActive = true
    }
    
    /* Метод уменьшает или увеличивает счетчик количества и обновляет соответствующие лейблы этим значением */
    @objc private func changeCounterValue(_ sender: UIButton) {
        // Произведем операции декремента или инкремента счетчика, в зависимости от нажатой кнопки.
        if sender == minusButton {
            counter -= 1;
            if counter < 1 {
                counter = 1
                return
            }
        } else {
            counter += 1;
        }
        // Обновим значения лейблов количества.
        hintCountLabel.text = String(counter)
        countLabel.text = String(counter)
    }
    
    // MARK: - Notification functions

    /* Метод обновит цвета согласно выбранной пользователем темы */
    @objc override func updateColors() {
        super.updateColors()
        textField.tintColor = .clear
        mainView.backgroundColor = AGThemeManager.viewBackgroundColor
        countsView.backgroundColor = AGThemeManager.viewBackgroundColor
        datePicker.backgroundColor = AGThemeManager.viewBackgroundColor
        countLabel.textColor = AGThemeManager.halfPickerHintCountLabelColor
        hintCountLabel.textColor = AGThemeManager.halfPickerHintCountLabelColor
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
            // Иначе, покажем 24-ой формат времени.
            datePicker.locale = Locale(identifier: "en_GB")
        }
        // У форматтера тоже нужно менять, чтобы при выборе даты в текстовое поле записывалась дата в нужном (текущем) языке.
        formatter.locale = Locale(identifier: AGLanguageManager.currentLanguage.rawValue)
        // Обновим запись в текстовом поле.
        textField.text = formatter.string(from: currentDate!)
    }
}

// MARK: - Extensions

extension AGHalfFieldPicker: ToolbarPickerProtocol {
    /* Этот метод закрывает пикер даты при нажатии на кнопку "Подтвердить" на тулбаре и сохраняет выбранную дату в текстовое поле */
    func submitToolbarButtonTouched() {
        // Установим выбранную дату в текстовое поле, предварительно отформатировав её.
        textField.text = formatter.string(from: datePicker.date)
        // Закроем пикер даты.
        endEditing(true)    }
    
    /* Этот метод просто закрывает пикер даты без сохранения даты в текстовое поле */
    func cancelToolbarButtonTouched() {
        endEditing(true)
    }
}
