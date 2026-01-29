//
//  SceneDelegate.swift
//  Cookbook Template
//
//  Created by Renchi Liu on 1/28/26.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = scene as? UIWindowScene else { return }
        
        let window = UIWindow(windowScene: windowScene)
        let root = CookbookHomeViewController()
        window.rootViewController = UINavigationController(rootViewController: root)
        window.makeKeyAndVisible()
        
        self.window = window
    }
}
