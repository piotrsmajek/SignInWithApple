//
//  LoggedInViewController.swift
//  Sign in with apple demo
//
//  Created by Piotr Smajek on 13/10/2019.
//  Copyright © 2019 Miquido. All rights reserved.
//

import Foundation
import UIKit
import AuthenticationServices

class LoggedInViewController: UIViewController {

    @IBOutlet weak var userIdentifierLabel: UILabel!
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!

    var viewModel: LoggedInViewModel?

    private let notificationName = ASAuthorizationAppleIDProvider.credentialRevokedNotification

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    private func setup() {
        setupNotification()
        setupLabels()
    }

    private func setupLabels() {
        userIdentifierLabel.text = viewModel?.credentials.userIdentifier
        firstNameLabel.text = viewModel?.credentials.firstName
        lastNameLabel.text = viewModel?.credentials.lastName
        emailLabel.text = viewModel?.credentials.email
    }

    private func setupNotification() {
        NotificationCenter.default.addObserver(forName: notificationName, object: nil, queue: nil) { [weak self] notification in
            self?.signOut()
        }
    }

    @IBAction func signOutButtonClicked(_ sender: Any) {
        signOut()
    }

    private func signOut() {
        do {
            try Keychain.deleteAll()
        } catch {
            // handle error
            print(error)
            return
        }

        DispatchQueue.main.async {
            guard let viewController = UIStoryboard.instantiateVC(Scene.login) as? LoginViewController else { return }
            let viewModel = LoginViewModel(isFromLogout: true)
            viewController.viewModel = viewModel
            UIApplication.shared.set(rootViewController: viewController)
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: notificationName, object: nil)
    }
}
