//
//  BaseTextField.swift
//  Sign in with apple demo
//
//  Created by Piotrek on 12/10/2019.
//  Copyright © 2019 Miquido. All rights reserved.
//

import Foundation
import UIKit

class BaseTextField: UITextField {

    private let padding = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)

    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

    private func setup() {
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 1.0
        layer.cornerRadius = 3.0
    }

    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

}
