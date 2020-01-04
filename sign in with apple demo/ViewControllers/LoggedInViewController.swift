//
//  LoggedInViewController.swift
//  Sign in with apple demo
//
//  Created by Piotrek on 13/10/2019.
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

    var credentials: Credentials?
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
        userIdentifierLabel.text = credentials?.userIdentifier
        firstNameLabel.text = credentials?.firstName
        lastNameLabel.text = credentials?.lastName
        emailLabel.text = credentials?.email
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
        try! Keychain.deleteAll()
        DispatchQueue.main.async {
            guard let viewController = UIStoryboard.instantiateVC(Scene.login) as? LoginViewController else { return }
            viewController.isFromLogout = true
            UIApplication.shared.set(rootViewController: viewController)
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: notificationName, object: nil)
    }
}
