//
//  SceneDelegate.swift
//  AGUIElementsDemoProject
//
//  Created by Артем Григорян on 29.11.2020.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        // Узнаем текущий язык в настройках iPhone.
        let iPhoneLanguage = Locale.current.languageCode
        // Установим язык приложения при старте.
        if iPhoneLanguage == AGConstants.Languages.russian.rawValue {
            AGLanguageManager.currentLanguage = AGConstants.Languages.russian
        } else {
            AGLanguageManager.currentLanguage = AGConstants.Languages.english
        }
        // Контроллеры, которые будут в таб-баре.
        let tabBarControllersArray = [ViewController(), SecondMenuViewController(),
                                      CenterViewController(), FourthMenuViewController(), RightViewController()]
        // Массив иконок, которые будут в таб-баре.
        let tabBarIconsArray = ["graphIcon", "msrmIcon", "expandMenuIcon", "pillsIcon", "menuOtherIcon"]
        // Контроллеры, которые будут запускаться при нажатии на кнопку в popup кнопке-меню таб-бара (для центральной кнопки в таб-баре).
        let menuVCArray = [FirstMenuViewController(), SecondMenuViewController(),
                           ThirdMenuViewController(), FourthMenuViewController(), FifthMenuViewController()]
        // Массив иконок, которые будут в popup кнопке-меню таб-бара (для центральной кнопки в таб-баре).
        let popupMenuIconsArray = ["settingsMenuIcon", "pillsIcon", "msrmIcon", "graphIcon", "testIcon"]
        // Массив подписей к иконкам, которые будут в popup кнопке-меню таб-бара (для центральной кнопки в таб-баре).
        let popupMenuTextsArray = ["Main", "Email", "Backup", "Password", "Delete"]
        // Контроллеры, которые будут запускаться при нажатии на кнопку в popup кнопке-меню таб-бара (для правой кнопки в таб-баре).
        let rightMenuVCArray = [FirstMenuViewController(), SecondMenuViewController(), ThirdMenuViewController(), FourthMenuViewController()]
        // Массив иконок, которые будут в popup кнопке-меню таб-бара (для правой кнопки в таб-баре).
        let rightPopupMenuIconsArray = ["settingsMenuIcon", "pillsIcon", "msrmIcon", "graphIcon"]
        // Массив подписей к иконкам, которые будут в popup кнопке-меню таб-бара (для правой кнопки в таб-баре).
        let rightPopupMenuTextsArray = ["Main", "Email", "Backup", "Password"]
        // Проинициализируем AGTabBarController ранее созданными контроллерами, иконками, и подписями к иконкам.
        let tabBarController = AGTabBarController(tabBarIconsArray: tabBarIconsArray,
                                                  tabBarViewControllersArray: tabBarControllersArray,
                                                  popupMenuIconsArray: popupMenuIconsArray,
                                                  popupMenuTextsArray: popupMenuTextsArray,
                                                  popupMenuViewControllersArray: menuVCArray,
                                                  rightPopupMenuIconsArray: rightPopupMenuIconsArray,
                                                  rightPopupMenuTextsArray: rightPopupMenuTextsArray,
                                                  rightPopupMenuViewControllersArray: rightMenuVCArray)
        // Начнём подготовку к отображению всех контроллеров.
        let myWindow = UIWindow(windowScene: windowScene)
        let navigationController = UINavigationController()
        navigationController.viewControllers = [tabBarController]
        myWindow.rootViewController = navigationController
        myWindow.makeKeyAndVisible()
        window = myWindow
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
}
