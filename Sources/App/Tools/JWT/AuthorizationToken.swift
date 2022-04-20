//
//  AuthorizationToken.swift
//  
//
//  Created by Yesset Murat on 4/20/22.
//

import Vapor
import JWTKit

final class AuthorizationToken: Content, Authenticatable, JWTPayload {

    var expiration: ExpirationClaim
    var userId: UUID

    init(userId: UUID) {
        self.userId = userId
        self.expiration = ExpirationClaim(value: .distantFuture)
    }

    init(user: User) throws {
        self.userId = try user.requireID()
        self.expiration = ExpirationClaim(value: .distantFuture)
    }

    func verify(using signer: JWTSigner) throws {
        try expiration.verifyNotExpired()
    }
}
