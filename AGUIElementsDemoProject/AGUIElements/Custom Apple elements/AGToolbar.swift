//
//  AGToolbar.swift
//  AGUIElementsDemoProject
//
//  Created by Артем Григорян on 29.11.2020.
//

import UIKit
import Foundation

protocol ToolbarTextFieldProtocol {
    func hideToolbar()
}

protocol ToolbarPickerProtocol {
    func submitToolbarButtonTouched()
    func cancelToolbarButtonTouched()
}

enum ToolbarType {
    case textField
    case picker(String)
}

class AGToolbar: UIToolbar {
    
    // MARK: - Variables

    var toolbarTextFieldDelegate: ToolbarTextFieldProtocol?
    var toolbarPickerDelegate: ToolbarPickerProtocol?
    private var barTitleTextTranslationKey: String?
    private var doneButton: UIBarButtonItem?
    private var barTitle: UIBarButtonItem?
    
    // MARK: - Initializing

    init(type: ToolbarType) {
        super.init(frame: CGRect(origin: .zero, size: CGSize(width: UIScreen.main.bounds.size.width, height: 44.0)))
        
        switch type {
        case .textField:
            doneButton = UIBarButtonItem(title: "Close".localize(), style: .plain, target: self, action: #selector(closeKeyboardSelector(_ :)))
            let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
            
            setItems([spaceButton, doneButton!], animated: false)
        case .picker(let titleTranslationKey):
            barTitleTextTranslationKey = titleTranslationKey
            let doneButton = UIBarButtonItem(image: UIImage.init(named: "apply"), style: .plain, target: self, action: #selector(submitToolbarButtonTouched(_ :)))
            let cancelButton = UIBarButtonItem(image: UIImage.init(named: "closeIcon"), style: .plain, target: self, action: #selector(cancelToolbarButtonTouched(_ :)))
            barTitle = UIBarButtonItem(title: barTitleTextTranslationKey?.localize(), style: .done, target: nil, action: nil)
            let leftSpaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
            let rightSpaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)

            guard let barTitle = barTitle else { return }
            barTitle.tintColor = AGThemeManager.textFieldTextColor
            setItems([cancelButton, leftSpaceButton, barTitle, rightSpaceButton, doneButton], animated: false)
        }

        sizeToFit()
        barTintColor = AGThemeManager.elementsBackgroundColor
        backgroundColor = AGThemeManager.elementsBackgroundColor
        tintColor = AGThemeManager.halfPickerButtonImageTintColor

        // Подпишемся на уведомления об изменении темы приложения.
        NotificationCenter.default.addObserver(self, selector: #selector(updateColors), name: .updateColors, object: nil)
        // Подпишемся на уведомления об изменении языка приложения.
        NotificationCenter.default.addObserver(self, selector: #selector(changeLanguage), name: .changeLanguage, object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private functions

    @objc private func closeKeyboardSelector(_ sender: UIButton) {
        toolbarTextFieldDelegate?.hideToolbar()
    }
    
    @objc private func submitToolbarButtonTouched(_ sender: UIButton) {
        toolbarPickerDelegate?.submitToolbarButtonTouched()
    }
    
    @objc private func cancelToolbarButtonTouched(_ sender: UIButton) {
        toolbarPickerDelegate?.cancelToolbarButtonTouched()
    }
    
    // MARK: - Notification functions

    @objc func updateColors() {
        barTintColor = AGThemeManager.elementsBackgroundColor
        barTitle?.tintColor = AGThemeManager.textFieldTextColor
        backgroundColor = AGThemeManager.elementsBackgroundColor
        tintColor = AGThemeManager.halfPickerButtonImageTintColor
    }
    
    @objc func changeLanguage() {
        doneButton?.title = "Close".localize()
        barTitle?.title = barTitleTextTranslationKey?.localize()
    }
}
