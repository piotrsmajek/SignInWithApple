//
//  UIApplication+Root.swift
//  Sign in with apple demo
//
//  Created by Piotrek on 13/10/2019.
//  Copyright © 2019 Miquido. All rights reserved.
//

import Foundation
import UIKit

extension UIApplication {

    func set(rootViewController: UIViewController) {
        UIApplication.shared.windows.first { $0.isKeyWindow }?.rootViewController = rootViewController
    }

}
