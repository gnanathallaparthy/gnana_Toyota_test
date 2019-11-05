//
//  SuperHerosModel.swift
//  Toyota
//
//  Created by Gnana Thallaparthy on 03/11/19.
//  Copyright © 2019 Epam. All rights reserved.
//

import Foundation

let superHeroDefaultModel: [String: Any] = [Keys.Name: "", Keys.Heroes: "", Keys.Score: 0]

struct SuperHerosModel: Codable, SuperHerosModelProtocol {
    var Name: String
    var Picture: String
    var Score: Int
}
