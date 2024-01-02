//
//  Account.swift
//  SportScoresPro
//
//  Created by Kolby Boesel on 1/2/24.
//

import Foundation
import SwiftUI

struct LoginCredentials {
    var username: String
    var password: String
}

struct DocumentsModel: Codable {
    var documents: [User]
}

struct User: Codable {
    var loginId: String
    var passwordId: String
    var paidConfirm: String
    var firstName: String
    var lastName: String

    enum CodingKeys: String, CodingKey {
        case loginId = "LoginID"
        case passwordId = "PasswordID"
        case paidConfirm = "PaidConfirm"
        case firstName = "FirstName"
        case lastName = "LastName"

    }
}

struct LoginDataModel: Codable {
    var email: String
    var password: String
}
