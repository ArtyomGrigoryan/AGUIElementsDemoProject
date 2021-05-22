//
//  AGTabBarController.swift
//  AGUIElementsDemoProject
//
//  Created by Артем Григорян on 13.05.2021.
//

import UIKit

class AGTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    // MARK: - Variables
    
    var tabBarIconsArray: [String]
    var tabBarViewControllersArray: [UIViewController]
   
    private var middleButtonIndex: Int!
    private var isTheMenuCurrentlyDisplayed = false
    private var popupMenuView: AGTabBarPopupMenuView
    private var tabBarItemsImageViewArray = [UIImageView]()
    private let screenSize = UIScreen.main.bounds.size
    
    // MARK: - Initializing

    init(tabBarIconsArray: [String], tabBarViewControllersArray: [UIViewController], popupMenuIconsArray: [String], popupMenuTextsArray: [String], popupMenuViewControllersArray: [UIViewController]) {
        self.tabBarIconsArray = tabBarIconsArray
        self.tabBarViewControllersArray = tabBarViewControllersArray
        self.popupMenuView = AGTabBarPopupMenuView(textsArray: popupMenuTextsArray, iconsArray: popupMenuIconsArray,
                                                   viewControllersArray: popupMenuViewControllersArray)
        super.init(nibName: nil, bundle: nil)
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
        // Установим цвет для таб-бара.
        updateColors()
        // Уберем для него полупрозрачность.
        tabBar.isTranslucent = false
        // Подпишемся на уведомления о смене темы приложения.
        NotificationCenter.default.addObserver(self, selector: #selector(updateColors), name: .updateColors, object: nil)
    }
    
    // MARK: - Delegate function
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        // Получим индекс текущей нажатой кнопки на таб-баре.
        let touchedVCIndex = tabBarController.viewControllers!.firstIndex(of: viewController)!
        // Если индекс текущей нажатой кнопки - это срединная кнопка,
        if touchedVCIndex == middleButtonIndex {
            // то получим вьюшку вью контроллера, который принадлежит срединной кнопке,
            var currentView = tabBarController.selectedViewController!.view!
            // и если меню ранее не было вызвано,
            if !isTheMenuCurrentlyDisplayed {
                // то вызовем вью-меню, куда будем помещать кнопки.
                showPopupMenuView(superView: &currentView)
            // А если меню уже отображено на экране,
            } else {
                // то тогда спрячем меню.
                hidePopupMenuView()
            }
            // Изменим состояние переключателя, чтобы при следующем нажатии показать соответствующую анимацию.
            isTheMenuCurrentlyDisplayed.toggle()
            // Запустим анимацию поворота иконки на 45 градусов.
            rotateAnimation(for: tabBarItemsImageViewArray[middleButtonIndex])
            // Запустим анимацию изменения прозрачности остальных иконок на таб-баре.
            changeTabBarItemsTransparency()
            // Укажем, что не будем переключаться на этот вью-контроллер.
            return false
        }
        // иначе - просто отобразим нужный вью-контроллер.
        return true
    }
    
    // MARK: - Private functions
    
    private func showPopupMenuView(superView: inout UIView) {
        superView.addSubview(popupMenuView)
        
        UIView.animate(withDuration: 0.3, animations: {
            self.popupMenuView.frame = CGRect(x: 0, y: self.screenSize.height - self.popupMenuView.frame.height - self.tabBar.frame.height,
                                              width: self.screenSize.width, height: self.popupMenuView.frame.height)
        })
    }
    
    private func hidePopupMenuView() {
        UIView.animate(withDuration: 0.3, animations: {
            self.popupMenuView.frame = CGRect(x: 0, y: self.screenSize.height, width: self.screenSize.width, height: self.popupMenuView.frame.height)
        }) { _ in
            self.popupMenuView.removeFromSuperview()
        }
    }

    private func changeTabBarItemsTransparency() {
        for (index, element) in tabBarItemsImageViewArray.enumerated() {
            if index != middleButtonIndex {
                var alpha: CGFloat = 0;
                
                switch isTheMenuCurrentlyDisplayed {
                case false:
                    alpha = 1
                case true:
                    alpha = 0
                }
             
                UIView.animate(withDuration: 0.25, animations: {
                    element.alpha = alpha
                })
                // Сделаем нажатия на них доступными/недоступными.
                tabBar.items?[index].isEnabled.toggle()
            }
        }
    }
    
    private func rotateAnimation(for imageView: UIImageView) {
        var affineTransform: CGAffineTransform;
        
        switch isTheMenuCurrentlyDisplayed {
        case true:
            affineTransform = CGAffineTransform(rotationAngle: .pi / 4)
        case false:
            affineTransform = CGAffineTransform(rotationAngle: 0)
        }
        
        UIView.animate(withDuration: 0.25, animations: {
            imageView.transform = affineTransform
        })
    }
    
    /* Метод обновит цвета согласно выбранной пользователем темы */
    @objc func updateColors() {
        tabBar.barTintColor = AGThemeManager.elementsBackgroundColor
    }
}
