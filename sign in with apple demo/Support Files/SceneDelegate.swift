//
//  SceneDelegate.swift
//  sign in with apple demo
//
//  Created by Piotrek on 12/10/2019.
//  Copyright © 2019 Miquido. All rights reserved.
//

import UIKit
import AuthenticationServices

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        let appleIDProvider = ASAuthorizationAppleIDProvider()

        guard let data = try! Keychain.get(account: KeyChainKeys.userId) else { return }
        let userId = String(decoding: data, as: UTF8.self)

        appleIDProvider.getCredentialState(forUserID: userId) { credentialState, error in
            switch credentialState {
            case .authorized:
                // The Apple ID credential is valid.
                DispatchQueue.main.async {
                    guard let viewController = UIStoryboard.instantiateVC(Scene.loggedIn) as? LoggedInViewController else { return }
                    viewController.credentials = Credentials(userIdentifier: userId)
                    self.window?.rootViewController = viewController
                }
                break
            case .revoked:
                // The Apple ID credential is revoked, log out.
                try! Keychain.deleteAll()
                DispatchQueue.main.async {
                    let viewController = UIStoryboard.instantiateVC(Scene.login) 
                    self.window?.rootViewController = viewController
                }
                break
            case .notFound:
                // No credential was found, so show the sign-in UI.
                DispatchQueue.main.async {
                    let viewController = UIStoryboard.instantiateVC(Scene.login)
                    viewController.modalPresentationStyle = .formSheet
                    viewController.isModalInPresentation = true
                    self.window?.rootViewController?.present(viewController, animated: true, completion: nil)
                }
            default:
                break
            }
        }
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
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

