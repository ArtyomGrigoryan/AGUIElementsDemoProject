//
//  SecondViewController.swift
//  AGUIElementsDemoProject
//
//  Created by Артем Григорян on 29.11.2020.
//

import UIKit

class SecondViewController: UIViewController {

    private var textField1: AGTextField!
    private var lightButton: AGTabButton!
    private var darkButton: AGTabButton!
    private var ruButton: AGTabButton!
    private var enButton: AGTabButton!
    private var buttonsStackView: AGButtonsStackView!
    private var buttonsStackView2: AGButtonsStackView!

    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(updateColors), name: .updateColors, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(changeLanguage), name: .changeLanguage, object: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Текстовое поле для демонстрации изменения цветов AG элементов при переключении темы.
        textField1 = AGTextField(isDetached: true, textFieldText: "", placeholderTextTranslationKey: "Email", fieldType: .textField)
        view.addSubview(textField1)
        
        textField1.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        textField1.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        textField1.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        
        // Кнопки-переключатели.
        lightButton = AGTabButton(buttonTitleKey: "Light", isButtonSelected: true)
        darkButton = AGTabButton(buttonTitleKey: "Dark", isButtonSelected: false)
        lightButton.addTarget(self, action: #selector(lightThemeActionButtonTouched(_:)), for: .touchUpInside)
        darkButton.addTarget(self, action: #selector(darkThemeActionButtonTouched(_:)), for: .touchUpInside)
        
        // Кнопки-переключатели.
        ruButton = AGTabButton(buttonTitleKey: "Russian", isButtonSelected: true)
        enButton = AGTabButton(buttonTitleKey: "English", isButtonSelected: false)
        ruButton.addTarget(self, action: #selector(ruLanguageActionButtonTouched(_:)), for: .touchUpInside)
        enButton.addTarget(self, action: #selector(enLanguageActionButtonTouched(_:)), for: .touchUpInside)
        
        let actionButtonsArray: [AGButton] = [lightButton, darkButton]
        buttonsStackView = AGButtonsStackView(buttonsArray: actionButtonsArray, axis: .horizontal, spacing: 12)
        view.addSubview(buttonsStackView)
        
        let buttonsStackViewTopAnchor = buttonsStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 300)
        let buttonsStackViewLeadingAnchor = buttonsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        let buttonsStackViewTrailingAnchor = buttonsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        buttonsStackViewTrailingAnchor.priority = UILayoutPriority(999)

        NSLayoutConstraint.activate([buttonsStackViewTopAnchor, buttonsStackViewLeadingAnchor, buttonsStackViewTrailingAnchor])
        
        let actionButtonsArray2: [AGButton] = [ruButton, enButton]
        buttonsStackView2 = AGButtonsStackView(buttonsArray: actionButtonsArray2, axis: .horizontal, spacing: 12)
        view.addSubview(buttonsStackView2)
        
        let buttonsStackView2TopAnchor = buttonsStackView2.topAnchor.constraint(equalTo: buttonsStackView.bottomAnchor, constant: 12)
        let buttonsStackView2LeadingAnchor = buttonsStackView2.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        let buttonsStackView2TrailingAnchor = buttonsStackView2.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        buttonsStackView2TrailingAnchor.priority = UILayoutPriority(999)

        NSLayoutConstraint.activate([buttonsStackView2TopAnchor, buttonsStackView2LeadingAnchor, buttonsStackView2TrailingAnchor])
        // Установим переключатель в нужное положение, исходя из текущей темы.
        checkCurrentTheme()
        // Установим переключатель в нужное положение, исходя из текущего языка приложения.
        checkCurrentLanguage()
        // Установим цвета, исходя из текущей темы.
        updateColors()
        // Установим язык.
        changeLanguage()
    }
    
    @objc private func lightThemeActionButtonTouched(_ sender: UIButton) {
        AGThemeManager.CurrentTheme.isLight = true
        NotificationCenter.default.post(name: NSNotification.Name.updateColors, object: nil)

        darkButton.deselectButton()
        lightButton.selectButton()
    }
    
    @objc private func darkThemeActionButtonTouched(_ sender: UIButton) {
        AGThemeManager.CurrentTheme.isLight = false
        NotificationCenter.default.post(name: NSNotification.Name.updateColors, object: nil)

        lightButton.deselectButton()
        darkButton.selectButton()
    }
    
    @objc private func ruLanguageActionButtonTouched(_ sender: UIButton) {
        AGLanguageManager.currentLanguage = AGConstants.Languages.russian
        NotificationCenter.default.post(name: .changeLanguage, object: nil)

        enButton.deselectButton()
        ruButton.selectButton()
    }
    
    @objc private func enLanguageActionButtonTouched(_ sender: UIButton) {
        AGLanguageManager.currentLanguage = AGConstants.Languages.english
        NotificationCenter.default.post(name: .changeLanguage, object: nil)

        ruButton.deselectButton()
        enButton.selectButton()
    }
    
    private func checkCurrentTheme() {
        if AGThemeManager.CurrentTheme.isLight {
            darkButton.deselectButton()
            lightButton.selectButton()
        } else {
            lightButton.deselectButton()
            darkButton.selectButton()
        }
    }
    
    private func checkCurrentLanguage() {
        if AGLanguageManager.currentLanguage == AGConstants.Languages.russian {
            enButton.deselectButton()
            ruButton.selectButton()
        } else {
            ruButton.deselectButton()
            enButton.selectButton()
        }
    }
    
    /* Когда пользователь сменит тему, то вызовется эта функция */
    @objc func updateColors() {
        // Изменим цвет фона экрана.
        view.backgroundColor = AGThemeManager.viewBackgroundColor
        // Изменим цвет букв для статус-бара.
        navigationController?.navigationBar.barStyle = AGThemeManager.navigationBarStyle
        // Изменим цвет навигейшн контроллера.
        navigationController?.navigationBar.barTintColor = AGThemeManager.viewBackgroundColor
        // Изменим цвет заголовков в навигейшн контроллере.
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:AGThemeManager.halfPickerHintCountLabelColor]
    }
    
    /* Когда пользователь сменит язык, то вызовется эта функция */
    @objc func changeLanguage() {
        navigationItem.title = "Settings".localize()
    }
}
