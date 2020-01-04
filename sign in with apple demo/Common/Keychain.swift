//
//  Keychain.swift
//  Sign in with apple demo
//
//  Created by Piotrek on 13/10/2019.
//  Copyright © 2019 Miquido. All rights reserved.
//

import Foundation
import Security

private let service: String = "pl.smajekpiotr.signinwithappledemo"

enum Keychain {

    static func exists(account: String) throws -> Bool {
        let status = SecItemCopyMatching([
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: account,
            kSecAttrService: service,
            kSecReturnData: false,
            ] as NSDictionary, nil)
        if status == errSecSuccess {
            return true
        } else if status == errSecItemNotFound {
            return false
        } else {
            throw Errors.keychainError
        }
    }

    private static func add(value: Data, account: String) throws {
        let status = SecItemAdd([
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: account,
            kSecAttrService: service,
            kSecAttrAccessible: kSecAttrAccessibleAfterFirstUnlock,
            kSecValueData: value,
            ] as NSDictionary, nil)
        guard status == errSecSuccess else { throw Errors.keychainError }
    }

    private static func update(value: Data, account: String) throws {
        let status = SecItemUpdate([
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: account,
            kSecAttrService: service,
            ] as NSDictionary, [
            kSecValueData: value,
            ] as NSDictionary)
        guard status == errSecSuccess else { throw Errors.keychainError }
    }

    static func set(value: Data, account: String) throws {
        if try exists(account: account) {
            try update(value: value, account: account)
        } else {
            try add(value: value, account: account)
        }
    }

    static func get(account: String) throws -> Data? {
        var result: AnyObject?
        let status = SecItemCopyMatching([
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: account,
            kSecAttrService: service,
            kSecReturnData: true,
            ] as NSDictionary, &result)
        if status == errSecSuccess {
            return result as? Data
        } else if status == errSecItemNotFound {
            return nil
        } else {
            throw Errors.keychainError
        }
    }

    static func delete(account: String) throws {
        let status = SecItemDelete([
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: account,
            kSecAttrService: service,
            ] as NSDictionary)
        guard status == errSecSuccess else { throw Errors.keychainError }
    }

    static func deleteAll() throws {
        let status = SecItemDelete([
            kSecClass: kSecClassGenericPassword,
            ] as NSDictionary)
        guard status == errSecSuccess else { throw Errors.keychainError }
    }

    enum Errors: Error {
        case keychainError
    }
}
