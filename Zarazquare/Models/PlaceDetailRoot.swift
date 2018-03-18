//
//  PlaceDetailRoot.swift
//  Zarazquare
//
//  Created by Charlin Agramonte on 12/17/17.
//  Copyright © 2017 Universidad San Jorge. All rights reserved.
//

import Foundation

struct PlaceDetailRoot : Codable {
    let html_attributions : [String]?
    let result : Place?
    let status : String?
    
    enum CodingKeys: String, CodingKey {
        
        case html_attributions = "html_attributions"
        case result
        case status = "status"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        html_attributions = try values.decodeIfPresent([String].self, forKey: .html_attributions)
        result = try values.decodeIfPresent(Place.self, forKey: .result)
        status = try values.decodeIfPresent(String.self, forKey: .status)
    }
    
}
