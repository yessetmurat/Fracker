//
//  routes.swift
//
//
//  Created by Yesset Murat on 4/19/22.
//

import Vapor

func routes(_ app: Application) throws {

    // MARK: - User
    let userService = UserService()
    let userController = UserController(service: userService)
    try userController.boot(routes: app.routes)

    // MARK: - Categories
    let categoriesService = CategoriesService()
    let categoriesController = CategoriesController(service: categoriesService)
    try categoriesController.boot(routes: app.routes)

    // MARK: - Records
    let recordsService = RecordsService()
    let recordsController = RecordsContorller(service: recordsService)
    try recordsController.boot(routes: app.routes)
}
