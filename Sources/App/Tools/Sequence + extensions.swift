//
//  Sequence + extensions.swift
//  
//
//  Created by Yesset Murat on 5/8/22.
//

import Foundation

extension Sequence where Element: Hashable {

    var unique: [Element] {
        var set = Set<Element>()
        return filter { set.insert($0).inserted }
    }
}
