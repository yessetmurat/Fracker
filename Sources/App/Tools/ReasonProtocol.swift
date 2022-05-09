//
//  ReasonProtocol.swift
//  
//
//  Created by Yesset Murat on 5/9/22.
//

import Vapor

protocol ReasonProtocol {

    func description(for request: Request) -> String
}
