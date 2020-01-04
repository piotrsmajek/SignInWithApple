//
//  UIViewController+HideKeyboard.swift
//  Sign in with apple demo
//
//  Created by Piotr Smajek on 12/10/2019.
//  Copyright © 2019 Miquido. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {

    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(_:)))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard(_ gestureRecognizer: UIGestureRecognizer) {
        let location = gestureRecognizer.location(in: view)
        let hitTestView = view.hitTest(location, with: UIEvent())
        if hitTestView is UIButton { return }

        view.endEditing(true)
    }

}
