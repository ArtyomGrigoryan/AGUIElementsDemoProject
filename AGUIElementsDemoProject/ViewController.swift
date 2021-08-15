//
//  ViewController.swift
//  AGUIElementsDemoProject
//
//  Created by Артем Григорян on 29.11.2020.
//

import UIKit

class ViewController: UIViewController {

    private var textField1: AGTextField!
    private var textField2: AGValuePicker!
    private var textField3: AGDatePicker!
    private var textField4: AGTextField!
    private var textField5: AGTextField!
    private var textField7: AGTextField!
    private var textField8: AGDatePicker!
    private var textField9: AGValuePicker!
    private var textField10: AGTextField!
    private var textField11: AGTextField!
    private var textField12: AGTextField!
    private var textField13: AGTextField!
    private var textField14: AGTextField!

    private var halfPicker: AGHalfFieldPicker!
    private var halfPicker2: AGHalfFieldPicker!
    
    private var blockView: AGTextFieldsStackView!
    private var buttonsStackView: AGButtonsStackView!
    private var buttonsStackView2: AGButtonsStackView!

    private var letfButton: AGTabButton!
    private var rightButton: AGTabButton!
    
    private var doctorNametextView: AGTextView!
    
    private var submitActionButton: AGActionButton!
    private var cancelActionButton: AGActionButton!
    private var deleteActionButton: AGActionButton!
    private var clearActionButton: AGActionButton!
    private var withImageActionButton: AGActionButton!
    private var transparentActionButton: AGActionButton!

    private weak var activeField: AGTextField?
    private weak var activeTextView: AGTextView?

    private let scrollView = UIScrollView()
    
    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(kbWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(kbWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(changeLanguage), name: .changeLanguage, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateColors), name: .updateColors, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    override func viewDidLayoutSubviews() {
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.size.width, height: buttonsStackView2.frame.maxY + 24)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(scrollView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false;
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        drawInterface()
        changeLanguage()
        updateColors()
    }
    
    private func drawInterface() {
        // Обычное текстовое поле.
        textField1 = AGTextField(isDetached: true, textFieldText: "", placeholderTextTranslationKey: "FirstName", keyboardType: .default)
        textField1.delegate = self
        scrollView.addSubview(textField1)
        
        // Текстовое поле, заточеное под ввод телефонного номера. Форматирует ввод в формат телефонного номера.
        textField10 = AGTextField(isDetached: true, textFieldText: "", placeholderTextTranslationKey: "Phone", keyboardType: .numberPad, fieldType: .phoneField)
        textField10.delegate = self
        scrollView.addSubview(textField10)
        
        // Текстовое поле, заточеное под ввод почты. Содержит почтовый валидатор.
        textField11 = AGTextField(isDetached: true, textFieldText: "", placeholderTextTranslationKey: "Email", fieldType: .emailField)
        textField11.delegate = self
        scrollView.addSubview(textField11)
        
        // Текстовое поле, заточеное под ввод пароля.
        textField13 = AGTextField(isDetached: true, textFieldText: "", placeholderTextTranslationKey: "Password",
                                  keyboardType: .default, fieldType: .passwordField(withRegex: .defaultRegex))
        textField13.delegate = self
        scrollView.addSubview(textField13)

        // Текстовое поле, содержащее пикер значений. Ниже - массивы для первой и второй части. Опционально - отправить в конструктор разделитель.
        let pickerFirstDataArray = ["FirstValue", "SecondValue", "ThirdValue", "FourthValue", "FifthValue", "SixthValue"]
        let pickerSecondDataArray = ["1", "2", "3"]
        
        textField2 = AGValuePicker(isDetached: true, hintLabelTextTranslationKey: "PickerWithSeparator", pickerFirstDataArray: pickerFirstDataArray, defaultIndexForFirstArray: 1, pickerSecondDataArray: pickerSecondDataArray, defaultIndexForSecondArray: 0, separator: ":")
        textField2.delegate = self
        scrollView.addSubview(textField2)

        // Текстовое поле, содержащее пикер с выбором даты.
        textField3 = AGDatePicker(isDetached: true, datePickerMode: .dateAndTime, hintLabelTextTranslationKey: "DateAndTime")
        textField3.delegate = self
        scrollView.addSubview(textField3)

        // Кнопки-переключатели.
        letfButton = AGTabButton(buttonTitleKey: "Male", isButtonSelected: true)
        rightButton = AGTabButton(buttonTitleKey: "Female", isButtonSelected: false)
        letfButton.addTarget(self, action: #selector(maleButtonSelected(_:)), for: .touchUpInside)
        rightButton.addTarget(self, action: #selector(femaleButtonSelected(_:)), for: .touchUpInside)

        // EMMAButtonsStackView - поместим кнопки-переключатели в стеквью, указав горизонтальное расположение на экране.
        let tabButtonsArray: [AGButton] = [letfButton, rightButton]
        buttonsStackView = AGButtonsStackView(buttonsArray: tabButtonsArray, axis: .horizontal, spacing: 12)
        scrollView.addSubview(buttonsStackView)
        
        // Обычное текстовое поле.
        textField14 = AGTextField(isDetached: true, textFieldText: "", placeholderTextTranslationKey: "FirstName", keyboardType: .default)
        textField14.delegate = self
        scrollView.addSubview(textField14)
        
        // Обычное текстовое поле.
        textField4 = AGTextField(isDetached: false, textFieldText: "", placeholderTextTranslationKey: "FirstName", keyboardType: .default)
        textField4.delegate = self

        // Текстовое поле, содержащее пикер с выбором даты.
        textField8 = AGDatePicker(isDetached: false, datePickerMode: .date, hintLabelTextTranslationKey: "Date")
        textField8.delegate = self

        // Текстовое поле, содержащее пикер значений.
        textField9 = AGValuePicker(isDetached: false, hintLabelTextTranslationKey: "PickerWithoutSeparator", pickerFirstDataArray: pickerFirstDataArray, defaultIndexForFirstArray: 1, pickerSecondDataArray: pickerSecondDataArray, defaultIndexForSecondArray: 0)
        textField9.delegate = self

        // EMMATextFieldsStackView - стеквью, которое автоматически формирует "большой блок" с текстовыми полями.
        let textFieldsArray: [AGTextField] = [textField4, textField8, textField9]
        blockView = AGTextFieldsStackView(textFieldsArray: textFieldsArray)
        scrollView.addSubview(blockView)
        
        // Пикер в Назначениях.
        halfPicker = AGHalfFieldPicker(isDetached: true, datePickerMode: .time, hintLabelTextTranslationKey: "Count")
        halfPicker.delegate = self
        scrollView.addSubview(halfPicker)

        // Пикер в Назначениях.
        halfPicker2 = AGHalfFieldPicker(isDetached: true, datePickerMode: .time, hintLabelTextTranslationKey: "Count", counterValue: 4)
        halfPicker2.delegate = self
        scrollView.addSubview(halfPicker2)

        // TextView, для которого есть возможность выбора макс. кол-ва символов.
        doctorNametextView = AGTextView(textViewText: "", placeholderTextTranslationKey: "TextViewWithSymbolsCounter", maxCountOfCharacters: 120)
        doctorNametextView.delegate = self
        scrollView.addSubview(doctorNametextView)
        
        // Обычное текстовое поле.
        textField12 = AGTextField(isDetached: true, textFieldText: "", placeholderTextTranslationKey: "FirstName", keyboardType: .default)
        textField12.delegate = self
        scrollView.addSubview(textField12)

        // Ниже - кнопки. В конструктор передается enum, и исходя от него решается какого типа кнопку нужно отобразить.
        submitActionButton = AGActionButton(actionButtonType: .submit, titleKey: "Settings")
        submitActionButton.addTarget(self, action: #selector(showSecondVC(_:)), for: .touchUpInside)
        submitActionButton.setEnabled()

        cancelActionButton = AGActionButton(actionButtonType: .cancel, titleKey: "Cancel")
        deleteActionButton = AGActionButton(actionButtonType: .delete, titleKey: "Delete")
        transparentActionButton = AGActionButton(actionButtonType: .transparent, titleKey: "Add")
        clearActionButton = AGActionButton(actionButtonType: .clear, titleKey: "Later")
        // Можно указать, что кнопка должна содержать картинку!
        withImageActionButton = AGActionButton(actionButtonType: .withImage("paperClip.png"), titleKey: "AddImage")

        // EMMAButtonsStackView - кнопки "Мужчина" "Женщина" уже помещались в этот стеквью, но в данном случае используется вертикальная группировка.
        let actionButtonsArray: [AGButton] = [submitActionButton, cancelActionButton, deleteActionButton, transparentActionButton, clearActionButton, withImageActionButton]
        buttonsStackView2 = AGButtonsStackView(buttonsArray: actionButtonsArray, axis: .vertical, spacing: 12)
        scrollView.addSubview(buttonsStackView2)
        
        setupConstraints()
    }
    
    /* Когда пользователь сменит тему, то вызовется эта функция */
    @objc func updateColors() {
        // Изменим цвет фона экрана.
        view.backgroundColor = AGThemeManager.viewBackgroundColor
    }
    
    /* Когда пользователь сменит язык, то вызовется эта функция */
    @objc func changeLanguage() {
        tabBarController?.navigationItem.title = "Main".localize()
    }
    
    /* Покажем второй контроллер (Настройки) */
    @objc private func showSecondVC(_ sender: UIButton) {
        // Запустим второй контроллер.
        navigationController?.pushViewController(SecondViewController(), animated: true)
    }
    
    /* Узнать какая кнопка выбрана, поможет свойство isSelected, которое устанавливается в методах selectButton и deselectButton */
    @objc private func maleButtonSelected(_ sender: UIButton) {
        rightButton.deselectButton()
        letfButton.selectButton()
    }
    
    @objc private func femaleButtonSelected(_ sender: UIButton) {
        letfButton.deselectButton()
        rightButton.selectButton()
    }
    
    // Эту функцию можно спокойно копировать-вставить из проекта в проект.
    @objc private func kbWillShow(notification: Notification) {
        // Получим размеры клавиатуры.
        guard let kbFrameSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        // Тут будем хранить новые координаты для scrollView.
        let contentInsets: UIEdgeInsets
        // Координата верхней части клавиатуры.
        let topOfKeyboard = scrollView.frame.size.height - kbFrameSize.height
        // Переменная, в которой будет храниться координата нижней части выбранного объекта.
        var bottomOfTextField: CGFloat = 0
        // Если есть таб-бар, то нужно учитывать его высоту.
        var additionalOffsetFromTabBar: CGFloat = 0
        // Получим высоту таб-бара,
        if let tabBarControllerFrameHeight = tabBarController?.tabBar.frame.size.height {
            // и присвоим её вышесозданной переменной.
            additionalOffsetFromTabBar = tabBarControllerFrameHeight
        }
        // Если нажатие произошло по textField,
        if let activeField = activeField {
            bottomOfTextField = activeField.convert(activeField.bounds, to: view).maxY
            // то ничего дополнительного прибавлять к переменной координат для scrollView не нужно.
            contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: kbFrameSize.height - additionalOffsetFromTabBar, right: 0)
        // Если нажатие произошло по textView,
        } else if let activeTextView = activeTextView {
            bottomOfTextField = activeTextView.convert(activeTextView.bounds, to: view).maxY + 15
            // то scrollView нужно поднять повыше (+15), чтобы пользователь увидел счетчик введенных символов в этот textView.
            contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: kbFrameSize.height - additionalOffsetFromTabBar + 15, right: 0)
        } else {
            contentInsets = .zero
        }
        // Таким образом, предотвращается поднятие scrollView когда это не нужно.
        if bottomOfTextField > topOfKeyboard {
            // Поднимем scrollView.
            scrollView.contentInset = contentInsets
        }
    }
    
    // И эту функцию тоже, разумеется.
    @objc private func kbWillHide(notification: Notification) {
        scrollView.contentInset = .zero
    }
    
    private func setupConstraints() {
        textField1.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20).isActive = true
        textField1.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16).isActive = true
        textField1.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16).isActive = true
        
        textField10.topAnchor.constraint(equalTo: textField1.bottomAnchor, constant: 12).isActive = true
        textField10.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16).isActive = true
        textField10.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16).isActive = true
       
        textField11.topAnchor.constraint(equalTo: textField10.bottomAnchor, constant: 12).isActive = true
        textField11.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16).isActive = true
        textField11.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16).isActive = true
        
        textField13.topAnchor.constraint(equalTo: textField11.bottomAnchor, constant: 12).isActive = true
        textField13.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16).isActive = true
        textField13.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16).isActive = true
        
        textField2.topAnchor.constraint(equalTo: textField13.bottomAnchor, constant: 12).isActive = true
        textField2.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16).isActive = true
        textField2.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16).isActive = true
        
        textField3.topAnchor.constraint(equalTo: textField2.bottomAnchor, constant: 12).isActive = true
        textField3.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16).isActive = true
        textField3.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16).isActive = true
        
        textField14.topAnchor.constraint(equalTo: textField3.bottomAnchor, constant: 12).isActive = true
        textField14.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16).isActive = true
        textField14.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16).isActive = true
        
        buttonsStackView.topAnchor.constraint(equalTo: textField14.bottomAnchor, constant: 12).isActive = true
        buttonsStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16).isActive = true
        buttonsStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16).isActive = true
   
        blockView.topAnchor.constraint(equalTo: buttonsStackView.bottomAnchor, constant: 12).isActive = true
        blockView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16).isActive = true
        blockView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16).isActive = true
        
        halfPicker.topAnchor.constraint(equalTo: blockView.bottomAnchor, constant: 12).isActive = true
        halfPicker.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16).isActive = true
        halfPicker.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.width / 2 - 26).isActive = true
        
        halfPicker2.topAnchor.constraint(equalTo: blockView.bottomAnchor, constant: 12).isActive = true
        halfPicker2.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16).isActive = true
        halfPicker2.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.width / 2 - 26).isActive = true
        
        doctorNametextView.topAnchor.constraint(equalTo: halfPicker.bottomAnchor, constant: 12).isActive = true
        doctorNametextView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16).isActive = true
        doctorNametextView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16).isActive = true
        
        textField12.topAnchor.constraint(equalTo: doctorNametextView.bottomAnchor, constant: 12).isActive = true
        textField12.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16).isActive = true
        textField12.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16).isActive = true
        
        buttonsStackView2.topAnchor.constraint(equalTo: textField12.bottomAnchor, constant: 12).isActive = true
        buttonsStackView2.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16).isActive = true
    }
}

extension ViewController: AGTextFieldDelegate {
    func textFieldBeginEditing(_ textField: AGTextField) {
        activeField = textField
    }
    
    func textFieldEndEditing(_ textField: AGTextField) {
        activeField = nil;
    }
}

extension ViewController: AGTextViewDelegate {
    func textViewBeginEditing(_ textView: AGTextView) {
        activeTextView = textView
    }

    func textViewEndEditing(_ textView: AGTextView) {
        activeTextView = nil
    }
}
