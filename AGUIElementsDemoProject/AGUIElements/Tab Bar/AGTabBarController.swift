//
//  AGTabBarController.swift
//  AGUIElementsDemoProject
//
//  Created by Артем Григорян on 13.05.2021.
//

import UIKit

protocol PopupMenuClosing {
    func closeCurrentMenuView()
}

class AGTabBarController: UITabBarController, UITabBarControllerDelegate, PopupMenuClosing {
    
    // MARK: - Variables
    
    var tabBarIconsArray: [String]
    var tabBarViewControllersArray: [UIViewController]
   
    private var lastButtonIndex: Int?
    private var middleButtonIndex: Int!
    private var currentSelectedTabBarItem: Int!
    private var tabBarItemsImageViewArray = [UIImageView]()
    private var isTheMenuForLastButtonCurrentlyDisplayed = false
    private var isTheMenuForCenterButtonCurrentlyDisplayed = false
    private var popupMenuViewForLastButton: AGTabBarPopupMenuView?
    private var popupMenuViewForCenterButton: AGTabBarPopupMenuView?
    private let screenSize = UIScreen.main.bounds.size
    
    // MARK: - Initializing

    init(tabBarIconsArray: [String], tabBarViewControllersArray: [UIViewController], popupMenuIconsArray: [String], popupMenuTextsArray: [String], popupMenuViewControllersArray: [UIViewController], rightPopupMenuIconsArray: [String] = [], rightPopupMenuTextsArray: [String] = [], rightPopupMenuViewControllersArray: [UIViewController] = []) {
        self.currentSelectedTabBarItem = 0
        self.tabBarIconsArray = tabBarIconsArray
        self.tabBarViewControllersArray = tabBarViewControllersArray
        super.init(nibName: nil, bundle: nil)
        // Проинициализируем popupView тут, так как раньше не будет доступен self для делегата.
        initPopupMenuViews(popupMenuIconsArray: popupMenuIconsArray, popupMenuTextsArray: popupMenuTextsArray, popupMenuViewControllersArray: popupMenuViewControllersArray, rightPopupMenuIconsArray: rightPopupMenuIconsArray, rightPopupMenuTextsArray: rightPopupMenuTextsArray, rightPopupMenuViewControllersArray: rightPopupMenuViewControllersArray)
    }

    private func initPopupMenuViews(popupMenuIconsArray: [String], popupMenuTextsArray: [String], popupMenuViewControllersArray: [UIViewController], rightPopupMenuIconsArray: [String] = [], rightPopupMenuTextsArray: [String] = [], rightPopupMenuViewControllersArray: [UIViewController] = []) {
        self.popupMenuViewForCenterButton = AGTabBarPopupMenuView(textsArray: popupMenuTextsArray,
                                                                  iconsArray: popupMenuIconsArray,
                                                                  viewControllersArray: popupMenuViewControllersArray,
                                                                  delegate: self)
        if !rightPopupMenuViewControllersArray.isEmpty {
            self.popupMenuViewForLastButton = AGTabBarPopupMenuView(textsArray: rightPopupMenuTextsArray,
                                                                    iconsArray: rightPopupMenuIconsArray,
                                                                    viewControllersArray: rightPopupMenuViewControllersArray,
                                                                    delegate: self)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - ViewController life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        // Нам понадобится метод tabBarController shouldSelect viewController.
        delegate = self
        // Установим переданные из SceneDelegate вью-контроллеры в таб-бар.
        setViewControllers(tabBarViewControllersArray, animated: false)
        // Уберем для таб-бара полупрозрачность.
        tabBar.isTranslucent = false
        // Установим цвет для таб-бара.
        updateColors()
        // Вычислим индекс центральной кнопки на таб-баре.
        middleButtonIndex = tabBarViewControllersArray.count / 2
        // Установим иконки вью-контроллеров в таб-баре.
        for (index, element) in tabBarIconsArray.enumerated() {
            if index == middleButtonIndex {
                tabBar.items?[middleButtonIndex].image = UIImage(named: element)?.withRenderingMode(.alwaysOriginal)
                tabBar.items?[middleButtonIndex].imageInsets = UIEdgeInsets(top: 7, left: 0, bottom: 0, right: 0)
            } else {
                tabBar.items?[index].image = UIImage(named: element)
            }
        }
        // Второй цикл необходим, так как в первом цикле для первого индекса будет возвращаться nil. Пичаль.
        for (index, _) in tabBarIconsArray.enumerated() {
            // Добавим в массив все UIImageView, чтобы их анимировать при нажатии на центральную кнопку на таб-баре.
            tabBarItemsImageViewArray.append(tabBar.subviews[index].subviews.first as! UIImageView)
            // Без этой установки иконка будет уменьшаться в размере при анимации поворота на 45 градусов.
            tabBarItemsImageViewArray[index].contentMode = .center
        }
        // Подпишемся на уведомления о смене темы приложения.
        NotificationCenter.default.addObserver(self, selector: #selector(updateColors), name: .updateColors, object: nil)
    }
    
    // MARK: - Delegate function
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        // Получим индекс текущей нажатой кнопки на таб-баре.
        let touchedVCIndex = tabBarController.viewControllers!.firstIndex(of: viewController)!
        // Если индекс текущей нажатой кнопки - это срединная кнопка.
        if touchedVCIndex == middleButtonIndex {
            // Если правое меню сейчас отображается на экране,
            if isTheMenuForLastButtonCurrentlyDisplayed {
                // то спрячем его.
                closeCurrentMenuView()
            }
            // Получим вьюшку вью контроллера, который принадлежит срединной кнопке,
            var currentView = tabBarController.selectedViewController!.view!
            //tabBarController.selectedViewController!.tabBarItem.isEnabled = true
            // и если меню ранее не было вызвано,
            if !isTheMenuForCenterButtonCurrentlyDisplayed {
                // то вызовем вью-меню, куда будем помещать кнопки.
                showPopupMenuView(superView: &currentView, popupMenuView: popupMenuViewForCenterButton!)
                // Изменим состояние переключателя, чтобы при следующем нажатии показать соответствующую анимацию.
                isTheMenuForCenterButtonCurrentlyDisplayed.toggle()
                // Запустим анимацию поворота иконки на 45 градусов.
                rotateAnimation(for: tabBarItemsImageViewArray[middleButtonIndex], state: isTheMenuForCenterButtonCurrentlyDisplayed, angle: .pi / 4)
                // Запустим анимацию изменения прозрачности остальных иконок на таб-баре.
                changeTabBarItemsTransparency()
            // А если меню уже отображено на экране,
            } else {
                // то тогда спрячем меню.
                closeCurrentMenuView()
            }
            // Укажем, что не будем переключаться на этот вью-контроллер.
            return false
        // Если индекс текущей нажатой кнопки - это последняя кнопка (и для неё нужно меню),
        } else if ((touchedVCIndex == (tabBarViewControllersArray.count - 1)) && (popupMenuViewForLastButton != nil)) {
            // то получим вьюшку вью контроллера, который принадлежит последней кнопке,
            var currentView = tabBarController.selectedViewController!.view!
            // и если меню ранее не было вызвано,
            if !isTheMenuForLastButtonCurrentlyDisplayed {
                // то вызовем вью-меню, куда будем помещать кнопки.
                showPopupMenuView(superView: &currentView, popupMenuView: popupMenuViewForLastButton!)
                // Изменим состояние переключателя, чтобы при следующем нажатии показать соответствующую анимацию.
                isTheMenuForLastButtonCurrentlyDisplayed.toggle()
                // Повернём кнопку на 90 градусов.
                rotateAnimation(for: tabBarItemsImageViewArray[tabBarViewControllersArray.count-1], state: isTheMenuForLastButtonCurrentlyDisplayed, angle: .pi / 2)
            // А если меню уже отображено на экране,
            } else {
                // то тогда спрячем меню.
                closeCurrentMenuView()
            }
            // Укажем, что не будем переключаться на этот вью-контроллер.
            return false
        // Если индекс текущей нажатой кнопки - это какая-то другая кнопка,
        } else {
            // и если правое меню сейчас отображается на экране,
            if isTheMenuForLastButtonCurrentlyDisplayed {
                // то спрячем его.
                closeCurrentMenuView()
            }
            // Запомним индекс выбранного айтема, чтобы при повторном его появлении (alpha = 1) он был закрашен синим.
            currentSelectedTabBarItem = touchedVCIndex
            // Отобразим выбранный вью-контроллер на экране.
            return true
        }
    }
    
    func closeCurrentMenuView() {
        // В эту переменную запишем текущую отображаемую на экране меню.
        var currentPopupMenuView: AGTabBarPopupMenuView
        // Если сейчас на экране отображается центральное меню,
        if isTheMenuForCenterButtonCurrentlyDisplayed {
            // то в анимации закрывать будем его.
            currentPopupMenuView = popupMenuViewForCenterButton!
            // Изменим состояние переключателя, чтобы при следующем нажатии показать соответствующую анимацию.
            isTheMenuForCenterButtonCurrentlyDisplayed.toggle()
            // Запустим анимацию поворота иконки на 45 градусов.
            rotateAnimation(for: tabBarItemsImageViewArray[middleButtonIndex], state: isTheMenuForCenterButtonCurrentlyDisplayed, angle: .pi / 4)
            // Запустим анимацию изменения прозрачности остальных иконок на таб-баре.
            changeTabBarItemsTransparency()
        // А если правое меню,
        } else {
            // то в анимации закрывать будем его.
            currentPopupMenuView = popupMenuViewForLastButton!
            // Изменим состояние переключателя, чтобы при следующем нажатии показать соответствующую анимацию.
            isTheMenuForLastButtonCurrentlyDisplayed.toggle()
            // Запустим анимацию поворота иконки на 90 градусов.
            rotateAnimation(for: tabBarItemsImageViewArray[tabBarViewControllersArray.count-1], state: isTheMenuForLastButtonCurrentlyDisplayed, angle: .pi / 2)
        }
        // Анимация закрытия меню.
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            guard let self = self else { return }
            currentPopupMenuView.frame = CGRect(x: 0, y: self.screenSize.height,
                                                width: self.screenSize.width, height: currentPopupMenuView.frame.height)
        })
    }
    
    // MARK: - Private functions
    
    private func showPopupMenuView(superView: inout UIView, popupMenuView: AGTabBarPopupMenuView) {
        superView.addSubview(popupMenuView)

        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            guard let self = self else { return }
            popupMenuView.frame = CGRect(x: 0, y: self.screenSize.height - popupMenuView.frame.height - self.tabBar.frame.height,
                                         width: self.screenSize.width, height: popupMenuView.frame.height)
        })
    }

    private func changeTabBarItemsTransparency() {
        for (index, element) in tabBarItemsImageViewArray.enumerated() {
            if index != middleButtonIndex {
                var alpha: CGFloat = 0
                
                switch isTheMenuForCenterButtonCurrentlyDisplayed {
                case false:
                    alpha = 1
                case true:
                    alpha = 0
                }
             
                UIView.animate(withDuration: 0.3, animations: {
                    element.alpha = alpha
                })
                // Это нужно, чтобы после повторного показа (alpha = 1) текущего выбранного айтема он был селектнут (закрашен синим).
                if index != currentSelectedTabBarItem {
                    // Сделаем нажатия на них доступными/недоступными.
                    tabBar.items![index].isEnabled.toggle()
                }
            }
        }
    }
    
    private func rotateAnimation(for imageView: UIImageView, state: Bool, angle: CGFloat) {
        var affineTransform: CGAffineTransform
        
        switch state {
        case true:
            affineTransform = CGAffineTransform(rotationAngle: angle)
        case false:
            affineTransform = CGAffineTransform(rotationAngle: 0)
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            imageView.transform = affineTransform
        })
    }
    
    /* Метод обновит цвета согласно выбранной пользователем темы */
    @objc func updateColors() {
        tabBar.barTintColor = AGThemeManager.elementsBackgroundColor
    }
}
