//
//  ProfileResponse.swift
//  
//
//  Created by Yesset Murat on 5/8/22.
//

import Vapor

struct ProfileResponse: Content {

    let id: UUID
    let email: String
    let firstName: String?
    let lastName: String?
}
