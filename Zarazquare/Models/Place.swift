/*
 Copyright (c) 2017 Swift Models Generated from JSON powered by http://www.json4swift.com
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
 For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar
 
 */

import Foundation
class Place : Codable {
    var adr_address : String?
    var formatted_address : String?
    var formatted_phone_number : String?
    var geometry : Geometry?
    var icon : String?
    var id : String?
    var international_phone_number : String?
    var name : String?
    var opening_hours : Opening_hours?
    var place_id : String?
    var rating : Double?
    var reference : String?
    var photos : [Media]?
    var reviews : [Reviews]?
    var scope : String?
    var types : [String]?
    var url : String?
    var utc_offset : Int?
    var vicinity : String?
    var website : String?
    lazy var mainImage : String? = {
        return placeDetailPhotoUrl + (photos?.first?.photo_reference! ?? "")! + "&key=" + googleApiKey
    }()
    
    init(id: String?, name: String?, image: String?, adr_address: String?, formatted_address: String?, formatted_phone_number: String?, rating: Double?) {
        self.mainImage = image
        self.name = name
        self.adr_address = adr_address
        self.formatted_phone_number = formatted_phone_number
        self.formatted_address = formatted_address
        self.rating = rating
    }
    
}

struct Opening_hours : Codable {
    let open_now : Bool?
    let periods : [Periods]?
    let weekday_text : [String]?
    
    enum CodingKeys: String, CodingKey {
        
        case open_now = "open_now"
        case periods = "periods"
        case weekday_text = "weekday_text"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        open_now = try values.decodeIfPresent(Bool.self, forKey: .open_now)
        periods = try values.decodeIfPresent([Periods].self, forKey: .periods)
        weekday_text = try values.decodeIfPresent([String].self, forKey: .weekday_text)
    }
    
}

struct Periods : Codable {
    let close : Close?
    let open : Open?
    
    enum CodingKeys: String, CodingKey {
        
        case close
        case open
    }
    
    init(from decoder: Decoder) throws {
        _ = try decoder.container(keyedBy: CodingKeys.self)
        close = try Close(from: decoder)
        open = try Open(from: decoder)
    }
}

struct Reviews : Codable {
    let author_name : String?
    let author_url : String?
    let language : String?
    let profile_photo_url : String?
    let rating : Double?
    let relative_time_description : String?
    let text : String?
    let time : Int?
    
    enum CodingKeys: String, CodingKey {
        
        case author_name = "author_name"
        case author_url = "author_url"
        case language = "language"
        case profile_photo_url = "profile_photo_url"
        case rating = "rating"
        case relative_time_description = "relative_time_description"
        case text = "text"
        case time = "time"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        author_name = try values.decodeIfPresent(String.self, forKey: .author_name)
        author_url = try values.decodeIfPresent(String.self, forKey: .author_url)
        language = try values.decodeIfPresent(String.self, forKey: .language)
        profile_photo_url = try values.decodeIfPresent(String.self, forKey: .profile_photo_url)
        rating = try values.decodeIfPresent(Double.self, forKey: .rating)
        relative_time_description = try values.decodeIfPresent(String.self, forKey: .relative_time_description)
        text = try values.decodeIfPresent(String.self, forKey: .text)
        time = try values.decodeIfPresent(Int.self, forKey: .time)
    }
    
}

struct Open : Codable {
    let day : Int?
    let time : Int?
    
    enum CodingKeys: String, CodingKey {
        
        case day = "day"
        case time = "time"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        day = try values.decodeIfPresent(Int.self, forKey: .day)
        time = try values.decodeIfPresent(Int.self, forKey: .time)
    }
    
}

struct Close : Codable {
    let day : Int?
    let time : Int?
    
    enum CodingKeys: String, CodingKey {
        
        case day = "day"
        case time = "time"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        day = try values.decodeIfPresent(Int.self, forKey: .day)
        time = try values.decodeIfPresent(Int.self, forKey: .time)
    }
    
    
    
}





