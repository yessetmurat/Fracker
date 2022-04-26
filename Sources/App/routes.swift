//
//  routes.swift
//
//
//  Created by Yesset Murat on 4/19/22.
//

import Vapor

func routes(_ app: Application) throws {

    try UserController().boot(routes: app.routes)

    try AppleSignInController().boot(routes: app.routes)

    try CategoriesController().boot(routes: app.routes)

    try RecordsContorller().boot(routes: app.routes)
}
