//
//  routes.swift
//
//
//  Created by Yesset Murat on 4/19/22.
//

import Vapor

func routes(_ app: Application) throws {
    try RecordsRouter().boot(routes: app.routes)
    try CategoriesRouter().boot(routes: app.routes)
}
