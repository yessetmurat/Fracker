//
//  routes.swift
//
//
//  Created by Yesset Murat on 4/19/22.
//

import Vapor

func routes(_ app: Application) throws {

    // MARK: - User
    try UserController().boot(routes: app.routes)

    // MARK: - Categories
    try CategoriesController().boot(routes: app.routes)

    // MARK: - Records
    try RecordsContorller().boot(routes: app.routes)
}
