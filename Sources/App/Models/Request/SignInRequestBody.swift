//
//  SignInRequestBody.swift
//  
//
//  Created by Yesset Murat on 4/27/22.
//

import Foundation

struct SignInRequestBody: Decodable {

    let idToken: String
    let firstName: String?
    let lastName: String?
}
