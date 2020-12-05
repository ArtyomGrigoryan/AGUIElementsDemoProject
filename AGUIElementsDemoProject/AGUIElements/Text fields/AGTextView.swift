//
//  AGTextView.swift
//  AGUIElementsDemoProject
//
//  Created by Артем Григорян on 29.11.2020.
//

import UIKit

protocol AGTextViewDelegate {
    func textViewBeginEditing(_ textView: AGTextView)
    func textViewEndEditing(_ textView: AGTextView)
}

class AGTextView: AGView {

    // MARK: - Variables
    
    var delegate: AGTextViewDelegate?
    
    private let height: CGFloat = 62
    private var placeholderText: String!
    private var maxCountOfCharacters: Int = 0
    private var placeholderTextTranslationKey: String!
    private let textViewFont = AGFontsManager.mediumSF
    private let width = UIScreen.main.bounds.size.width - 32
    private var textViewCurrentTextHeight: CGFloat = 19.09375
    private var textViewOldHeightConstraint = NSLayoutConstraint()
    private var textViewActiveStateTopConstraint = NSLayoutConstraint()
    private var textViewNotActiveStateTopConstraint = NSLayoutConstraint()
    private var textViewActiveStateBottomConstraint = NSLayoutConstraint()
    private var textViewNotActiveStateBottomConstraint = NSLayoutConstraint()
    private var textViewActiveStateWithCharacterCounterBottomConstraint = NSLayoutConstraint()
    private let textViewSize = CGSize(width: UIScreen.main.bounds.size.width - 64, height: CGFloat.greatestFiniteMagnitude)

    /* Лейбл подсказка, которое появляется сверху от текстового поля */
    private let hintLabel: UILabel = {
        let hintLabel = UILabel()
        hintLabel.font = AGFontsManager.littleSF
        hintLabel.textColor = AGThemeManager.textFieldHintColor
        hintLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return hintLabel
    }()
    
    /* Лейбл счётчик введённых символов */
    private lazy var counterOfCharacters: UILabel = {
        let counterOfCharacters = UILabel()
        counterOfCharacters.font = AGFontsManager.littleSF
        counterOfCharacters.textColor = AGThemeManager.textFieldHintColor
        counterOfCharacters.translatesAutoresizingMaskIntoConstraints = false

        return counterOfCharacters
    }()
    
    /* Само поле */
    let textView: UITextView = {
        let textView = UITextView()
        textView.isScrollEnabled = false
        textView.autocorrectionType = .no
        textView.textContainerInset = .zero
        textView.font = AGFontsManager.mediumSF
        textView.textContainer.lineFragmentPadding = 0
        textView.textColor = AGThemeManager.textFieldTextColor
        textView.tintColor = AGThemeManager.textFieldHintColor
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = AGThemeManager.elementsBackgroundColor

        return textView
    }()
    
    // MARK: - Initializing

    init(textViewText: String!, placeholderTextTranslationKey: String = "", maxCountOfCharacters: Int = 0) {
        super.init(width: width, height: height)
        // Эта переменная будет нужан в методе обновления текущего количества введенных символов.
        self.maxCountOfCharacters = maxCountOfCharacters
        // Если приходящий по-умолчанию текст не пуст,
        if textViewText != "" {
            // то изменим высоту вью-контейнера.
            let size = textViewText.boundingRect(with: textViewSize,
                                              options: [.usesLineFragmentOrigin, .usesFontLeading],
                                           attributes: [NSAttributedString.Key.font: textViewFont],
                                              context: nil).size
            // Обновим констрейнт высоты вью-контейнера, на котором находится текстовое поле.
            textViewOldHeightConstraint = heightAnchor.constraint(equalToConstant: height + size.height - textViewCurrentTextHeight)
            textViewCurrentTextHeight = size.height
        } else {
            // Иначе - высота вью-контейнера будет равна указанной выше константе.
            textViewOldHeightConstraint = heightAnchor.constraint(equalToConstant: height)
        }
        // Сделаем вышеуказанный констрейнт активным.
        textViewOldHeightConstraint.isActive = true
        // Сохраним ключ, так как он будет использоваться в методе changeLanguage.
        self.placeholderTextTranslationKey = placeholderTextTranslationKey
        // Нам нужно сохранить текст плейсхолдера, так как он будет стираться при нажатии на текстовое поле.
        self.placeholderText = placeholderTextTranslationKey.localize()
        // Добавим тени и закруглим края.
        layer.cornerRadius = 4
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowOpacity = 0.1
        layer.shadowRadius = 4
        layer.shadowColor = AGThemeManager.shadowColor.cgColor
        // Добавим текстовое поле на вью-контейнер.
        addSubview(textView)
        // Создадим тулбар, чтобы иметь возможность закрывать клавиатуру после ввода текста.
        let toolbar = AGToolbar(type: .textField)
        // Станем делегатом тулбара, чтобы вызывать метод hideToolbar.
        toolbar.toolbarTextFieldDelegate = self
        // Установим тулбар для текстового поля.
        textView.inputAccessoryView = toolbar
        // Будем делегатом, чтобы пользоваться методами UITextViewDelegate.
        textView.delegate = self
        // Установим текст в текстовое поле.
        textView.text = textViewText
        // Установим левые и правые констрейнты для текстового поля. Они константа.
        textView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        textView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        // Установим остальные констрейнты для текстового поля.
        textViewNotActiveStateTopConstraint = textView.topAnchor.constraint(equalTo: topAnchor, constant: 20)
        textViewActiveStateTopConstraint = textView.topAnchor.constraint(equalTo: topAnchor, constant: 30)
        textViewNotActiveStateBottomConstraint = textView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -22)
        textViewActiveStateBottomConstraint = textView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12)
        textViewActiveStateWithCharacterCounterBottomConstraint = textView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -29)
        // Проинициализируем лейбл-подсказку переданными данными.
        hintLabel.text = placeholderText
        // Добавим лейбл-подсказку на вью-контейнер.
        addSubview(hintLabel)
        // Установим констрейнты для лейбла-подсказки к вью-контейнеру.
        hintLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        hintLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        hintLabel.bottomAnchor.constraint(equalTo: textView.topAnchor, constant: 0).isActive = true
        // Если для текстового поля нет заранее подготовленного текста,
        if textViewText.count == 0 {
            // то отобразим текстовое поле как неактивное (как-будто пользователь не нажимал на текстовое поле),
            setTextViewNotActiveState()
        } else {
            // иначе - покажем его активным (как-будто пользователь нажал на текстовое поле).
            setTextViewActiveState(isFromInit: true)
        }
        // В зависимости от количества текста в поле - установим плейсхолдер.
        changePlaceholder()
        // Подпишемся на уведомления об изменении темы приложения.
        NotificationCenter.default.addObserver(self, selector: #selector(updateColors), name: .updateColors, object: nil)
        // Подпишемся на уведомления об изменении языка приложения.
        NotificationCenter.default.addObserver(self, selector: #selector(changeLanguage), name: .changeLanguage, object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private functions
    
    /* Этот метод вызывается при нажатии на текстовое поле */
    private func setTextViewActiveState(isFromInit: Bool) {
        // Деактивируем констрейнты, которые предназначались для неактивного текстового поля.
        NSLayoutConstraint.deactivate([textViewNotActiveStateTopConstraint, textViewNotActiveStateBottomConstraint, textViewActiveStateBottomConstraint])
        // Если предусмотрено, что нужно показывать лейбл-счетчик,
        if maxCountOfCharacters > 0 {
            // и что попали сюда не через конструктор,
            if isFromInit == false {
                // и что лейбл не лежит на вью-контейнере,
                if super.subviews.contains(counterOfCharacters) == false {
                    // то увеличим высоту вью-контейнера, чтобы туда поместился лейбл.
                    textViewOldHeightConstraint.constant += 17
                    // Обновим его тени
                    updateShadows()
                    // Чтобы лейбл-счетчик поместился на вью-контейнер - активируем нужный констрейнт.
                    NSLayoutConstraint.activate([textViewActiveStateTopConstraint, textViewActiveStateWithCharacterCounterBottomConstraint])
                }
            } else {
                // Если попали сюда через конструктор, то лейбл-счетчик показывать не нужно, поэтому нижний констрейнт маленький.
                NSLayoutConstraint.activate([textViewActiveStateTopConstraint, textViewActiveStateBottomConstraint])
            }
        } else {
            // Если не предусмотрено, что нужно показывать лейбл-счетчик.
            NSLayoutConstraint.activate([textViewActiveStateTopConstraint, textViewActiveStateBottomConstraint])
        }
        // Покажем подсказку.
        hintLabel.alpha = 1
    }
    
    /* Этот метод вызывается при уходе из ранее выбранного текстового поля, и что в нем более нет текста */
    private func setTextViewNotActiveState() {
        // Если предусмотрено, что нужно показывать лейбл-счетчик,
        if maxCountOfCharacters > 0 {
            // и что он находится на экране в данный момент,
            if super.subviews.contains(counterOfCharacters) {
                // то удалим его.
                counterOfCharacters.removeFromSuperview()
                // Уменьшим высоту вью-контейнера, где находился этот лейбл.
                textViewOldHeightConstraint.constant -= 17
                // Обновим его тени.
                updateShadows()
                // Деактивируем старые констрейнты.
                NSLayoutConstraint.deactivate([textViewActiveStateTopConstraint, textViewActiveStateWithCharacterCounterBottomConstraint, textViewActiveStateBottomConstraint])
            }
        } else {
            // Для случая, если лейбл-счетчик показывать не нужно.
            NSLayoutConstraint.deactivate([textViewActiveStateTopConstraint, textViewActiveStateBottomConstraint])
        }
        // Установим констрейнты для текстового поля к вью-контейнеру, если пользователь нажал на другое место на экране.
        NSLayoutConstraint.activate([textViewNotActiveStateTopConstraint, textViewNotActiveStateBottomConstraint])
        // Скроем подсказку.
        hintLabel.alpha = 0
    }
    
    /* Этот метод обрабатывает событие, что в поле всё ещё есть текст и пользователь нажал на другое место */
    private func removeCounterOfCharactersLabel() {
        // Если лейбл количества введенных символов находится на экране,
        if super.subviews.contains(counterOfCharacters) {
            // то удалим его.
            counterOfCharacters.removeFromSuperview()
            // Уменьшим высоту вью-контейнера.
            textViewOldHeightConstraint.constant -= 17
            // Обновим его тени.
            updateShadows()
            // Деактивируем констрейнт, который делает большое пустое пространство между низом поля и низом вью-контейнера.
            NSLayoutConstraint.deactivate([textViewActiveStateWithCharacterCounterBottomConstraint])
        }
    }
   
    /* Этот метод решает: нужно ли показать плейсхолдер или нет */
    private func changePlaceholder() {
        // Если сейчас в текстовом поле есть текст, и он равен тексту плейсхолдера,
        if textView.text == placeholderText {
            // то очистим его,
            textView.text = ""
            // и устаноим стандартный цвет для основного шрифта.
            textView.textColor = AGThemeManager.textFieldTextColor
        } else if textView.text == "" {
            // то "покажем" плейсхолдер,
            textView.text = placeholderText
            // и устаноим такой цвет текста, которым обычно раскрашивают плейсхолдер.
            textView.textColor = AGThemeManager.textFieldHintColor
        }
    }
    
    /* Этот метод обновляет текст лейбла количества введенных на данный момент символов */
    private func updateCounterOfCharacters() {
        counterOfCharacters.text = "\(textView.text.count)/\(maxCountOfCharacters)"
    }
    
    /* Этот метод обновляет тени вокруг вью-контейнера */
    private func updateShadows() {
        var bounds = super.bounds
        bounds.size.height = textViewOldHeightConstraint.constant
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
    }
    
    // MARK: - Notification functions

    /* Метод обновит цвета согласно выбранной пользователем темы */
    @objc override func updateColors() {
        super.updateColors()
        if textView.text != placeholderText {
            textView.textColor = AGThemeManager.textFieldTextColor
        }
        textView.tintColor = AGThemeManager.textFieldHintColor
        textView.backgroundColor = AGThemeManager.elementsBackgroundColor
        textView.keyboardAppearance = AGThemeManager.keyboardAppearance
        hintLabel.textColor = AGThemeManager.textFieldHintColor
        counterOfCharacters.textColor = AGThemeManager.textFieldHintColor
    }
    
    /* Метод обновит язык компонента */
    @objc func changeLanguage() {
        hintLabel.text = placeholderTextTranslationKey.localize()
        placeholderText = hintLabel.text
        
        if textView.textColor == AGThemeManager.textFieldHintColor {
            textView.text = placeholderTextTranslationKey.localize()
        }
    }
}

// MARK: - Extensions

extension AGTextView: UITextViewDelegate {
    /* Метод меняет высоту вью-контейнера, в котором находится текстовое поле, исходя из его высоты */
    func textViewDidChange(_ textView: UITextView) {
        // Получим высоту текстового поля, исходя от текущего текста.
        let size = textView.text.boundingRect(with: textViewSize,
                                           options: [.usesLineFragmentOrigin, .usesFontLeading],
                                        attributes: [NSAttributedString.Key.font: textViewFont],
                                           context: nil).size
        // Если высота поля не равна предыдущему значению (высота изменилась),
        if size.height != textViewCurrentTextHeight {
            // то обновим констрейнт высоты вью-контейнера, на котором находится текстовое поле,
            textViewOldHeightConstraint.constant += size.height - textViewCurrentTextHeight
            textViewCurrentTextHeight = size.height
            // и обновим его тени.
            updateShadows()
        }
        // Отобразим текущее количество введенных символов в поле.
        counterOfCharacters.text = "\(textView.text.count)/\(maxCountOfCharacters)"
    }
    
    /* Вызывается, если пользователь нажал на поле */
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        // Переведем поле в активное состояние,
        setTextViewActiveState(isFromInit: false)
        // и скажем это делегату.
        delegate?.textViewBeginEditing(self)
        // Когда вводится какой-то текст, то плейсхолдер показывать не нужно.
        changePlaceholder()
        // Если нужно показать количество введенных символов,
        if maxCountOfCharacters > 0 {
            // и если этот лейбл не находится на вью,
            if super.subviews.contains(counterOfCharacters) == false {
                // то добавим этот лейбл.
                addSubview(counterOfCharacters)
                // Установим констрейнты для счетчика к вью-контейнеру.
                counterOfCharacters.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 0).isActive = true
                counterOfCharacters.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
                counterOfCharacters.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
                // Если текст в поле эквивалентен плейсхолдеру, или текста нет вообще,
                if textView.text == placeholderText || textView.text == "" {
                    // то количество введенных символов равно 0.
                    counterOfCharacters.text = "0/\(maxCountOfCharacters)"
                } else {
                    // Иначе - установим текущее количество символов в поле.
                    counterOfCharacters.text = "\(textView.text.count)/\(maxCountOfCharacters)"
                }
            }
        }
        return true
    }

    /* Вызывается, если пользователь ушёл с поля */
    func textViewDidEndEditing(_ textView: UITextView) {
        // Если текста нет,
        if textView.text == "" {
            // то переведем поле в неактивное состояние,
            setTextViewNotActiveState()
            // и скроем плейсхолдер.
            changePlaceholder()
        }
        // Если отображается количество введенных символов,
        if maxCountOfCharacters > 0 {
            // то нужно удалить лейбл-счетчик, и изменить констрейнты.
            removeCounterOfCharactersLabel()
        }
        // Скажем делегату, что с этим полем взаимодействие больше не происходит.
        delegate?.textViewEndEditing(self)
    }
    
    /* Метод предотвращает ввод символов, если был превышен лимит */
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        // Если текущее количество введенных символов равно или больше лимиту,
        if newText.count >= maxCountOfCharacters {
            // то закрасим счетчик в красный цвет.
            counterOfCharacters.textColor = AGThemeManager.errorColor
        } else {
            // Вернем старый цвет счетчику.
            counterOfCharacters.textColor = AGThemeManager.textFieldHintColor
        }
        // Если количество введенных символов меньше, или равно лимиту, то дальнейший ввод разрешён.
        return newText.count <= maxCountOfCharacters
    }
}

extension AGTextView: ToolbarTextFieldProtocol {
    /* Этот метод закрывает клавиатуру при нажатии на кнопку "Закрыть" на тулбаре */
    @objc func hideToolbar() {
        endEditing(true)
    }
}
