//
//  SceneDelegate.swift
//  Remind me
//
//  Created by Andrey Versta on 16.05.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let viewModel = MainPageViewModel()
        let mainPageVC = MainPageViewController(viewModel: viewModel)
        window?.rootViewController =  UINavigationController(rootViewController: mainPageVC)
        window?.windowScene = windowScene
        window?.makeKeyAndVisible()
        
        let notificationSevice = NotificationService()
        notificationSevice.askUserForNotifications()
    }
}
