//
//  SceneDelegate.swift
//  sign in with apple demo
//
//  Created by Piotr Smajek on 12/10/2019.
//  Copyright © 2019 Miquido. All rights reserved.
//

import UIKit
import AuthenticationServices

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        let appleIDProvider = ASAuthorizationAppleIDProvider()

        guard let data = try? Keychain.get(account: KeyChainKeys.userId) else { return }
        let userId = String(decoding: data, as: UTF8.self)

        appleIDProvider.getCredentialState(forUserID: userId) { credentialState, error in
            switch credentialState {
            case .authorized:
                // The Apple ID credential is valid.
                DispatchQueue.main.async { [weak self] in
                    guard let viewController = UIStoryboard.instantiateVC(Scene.loggedIn) as? LoggedInViewController else { return }
                    let credentials = Credentials(userIdentifier: userId)
                    let viewModel = LoggedInViewModel(with: credentials)
                    viewController.viewModel = viewModel
                    self?.window?.rootViewController = viewController
                }
                break
            case .revoked:
                // The Apple ID credential is revoked, log out.
                do {
                    try Keychain.deleteAll()
                } catch {
                    // handle error
                    print(error)
                    return
                }
                DispatchQueue.main.async { [weak self] in
                    let viewController = UIStoryboard.instantiateVC(Scene.login) 
                    self?.window?.rootViewController = viewController
                }
                break
            case .notFound:
                // No credential was found, so show the sign-in UI.
                DispatchQueue.main.async { [weak self] in
                    let viewController = UIStoryboard.instantiateVC(Scene.login)
                    viewController.modalPresentationStyle = .formSheet
                    viewController.isModalInPresentation = true
                    self?.window?.rootViewController?.present(viewController,
                                                              animated: true,
                                                              completion: nil)
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

}

