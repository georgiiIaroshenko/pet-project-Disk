//
//  GoogleModel.swift
//  Disk
//
//  Created by Георгий on 25.07.2024.
//

import Foundation

//struct GoogleUpdateUserToken {
//    let client_id: String
//    let client_secret: String
//    let code: String
//    let grant_type: String
//    let redirect_uri: String
//}

struct GoogleNewUserToken: Decodable {
    let access_token: String
    let expires_in: Int
    let scope: String
    let token_type: String
    let id_token: String
}
struct GoogleTokenInfo: Decodable {
    let issued_to: String
    let audience: String
    let user_id: String
//    let scope: String
    let expires_in: Int
    let access_type: String
}
