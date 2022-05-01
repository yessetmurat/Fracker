//
//  RecordResponse.swift
//  
//
//  Created by Yesset Murat on 4/21/22.
//

import Vapor

struct RecordResponse: Content {

    let id: UUID
    let createdAt: Date?
    let amount: Double
    let category: CategoryResponse
}
