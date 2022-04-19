//
//  RecordsRouter.swift
//  
//
//  Created by Yesset Murat on 4/19/22.
//

import Vapor

struct RecordsRouter: RouteCollection {

    func boot(routes: RoutesBuilder) throws {
        let controller = RecordsContorller()
        let recordsRoutes = routes.grouped("api", "records")

        recordsRoutes.get(use: controller.all)
        recordsRoutes.post(use: controller.create)
    }
}
