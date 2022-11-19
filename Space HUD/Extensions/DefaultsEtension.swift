//
//  DefaultsEtension.swift
//  Space HUD
//
//  Created by Pavel Makhov on 2022-11-18.
//

import Foundation
import Defaults
import KeychainAccess

extension Defaults.Keys {
 
    static let orgName = Key<String>("orgName", default: "")
    static let token = Key<String>("token", default: "")
    static let projectId = Key<String>("projectId", default: "")
}

extension KeychainKeys {
    static let token: KeychainAccessKey = KeychainAccessKey(key: "token")
}
