//
//  Name.swift
//  
//
//  Created by Yesset Murat on 5/8/22.
//

import Foundation

struct Name {

    private static var names: [String] {
        return [
            "Dark Sackrider",
            "Lil Hooperbag",
            "Chesterfield MBembo",
            "Huggy Olivetti",
            "Chesterfield Butterbaugh",
            "Worms Henderson",
            "Worms Rosenthal",
            "Greasy Hootkins",
            "Chad Henderson",
            "Worms Moonshine",
            "Buttermilk Outerbridge",
            "Oinks Clovenhoof",
            "Schlomo Peterson",
            "Lunch Money Bigmeat",
            "Boxelder Vinaigrette",
            "Foncy Snuggleshine",
            "Winston Sugar-Gold",
            "Baby Hoosenater",
            "Lunch Jingley-Schmidt",
            "Huckleberry Listenbee",
            "Oil-Can Clovenhoof",
            "Mergatroid Wigglesworth",
            "Chigger Kingfish",
            "Mergatroid Noseworthy"
        ]
    }

    static var random: String {
        let index = Int.random(in: 0...Self.names.count - 1)
        return Self.names[index]
    }
}
