//
//  CategoryResponse.swift
//  
//
//  Created by Yesset Murat on 4/21/22.
//

import Vapor

struct CategoryResponse: Content {

    let id: UUID
    let emoji: String
    let name: String
}
