//
//  Category.swift
//  Zarazquare
//
//  Created by Charlin Agramonte on 12/17/17.
//  Copyright © 2017 Universidad San Jorge. All rights reserved.
//

import Foundation
struct Category : Codable {
    let id : String?
    let name : String?
    let image : String?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case image = "image"
    }
    
    init(id: String, name: String, image: String) {
        self.id = id
        self.name = name
        self.image = image
    }
}
