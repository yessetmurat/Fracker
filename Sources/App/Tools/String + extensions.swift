//
//  String + extensions.swift
//  
//
//  Created by Yesset Murat on 5/9/22.
//

import Vapor

extension String {

    func localized(for request: Request) -> String {
        let languageCode = request.headers.first(name: "Language") ?? "en"

        guard let path = Bundle.module.path(forResource: languageCode, ofType: "lproj"),
              let bundle = Bundle(path: path) else {
            return self
        }

        return NSLocalizedString(self, bundle: bundle, comment: "")
    }
}
