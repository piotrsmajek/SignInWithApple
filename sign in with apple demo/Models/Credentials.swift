//
//  Credentials.swift
//  Sign in with apple demo
//
//  Created by Piotr Smajek on 13/10/2019.
//  Copyright © 2019 Miquido. All rights reserved.
//

import Foundation

struct Credentials {
    let userIdentifier: String?
    let firstName: String?
    let lastName: String?
    let email: String?

    init(userIdentifier: String? = nil,
         firstName: String? = nil,
         lastName: String? = nil,
         email: String? = nil) {
        self.userIdentifier = userIdentifier
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
    }
}
