//
//  CategoriesRouter.swift
//  
//
//  Created by Yesset Murat on 4/19/22.
//

import Vapor

struct CategoriesRouter: RouteCollection {

    func boot(routes: RoutesBuilder) throws {
        let controller = CategoriesController()
        let categoriesRoutes = routes.grouped("api", "categories")

        categoriesRoutes.get(use: controller.all)
        categoriesRoutes.post(use: controller.create)
    }
}
