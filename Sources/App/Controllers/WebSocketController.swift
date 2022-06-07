//
//  WebSocketController.swift
//  
//
//  Created by Yesset Murat on 6/6/22.
//

import Vapor

struct WebSocketController {

    func webSocket(request: Request, socket: WebSocket) {
        socket.onText { _, text in socket.send(text) }
    }
}

extension WebSocketController: RouteCollection {

    func boot(routes: RoutesBuilder) throws {
        let group = routes.grouped("network11", "test").grouped(ApiKeyMiddleware())
        group.webSocket("send", onUpgrade: webSocket)
    }
}
