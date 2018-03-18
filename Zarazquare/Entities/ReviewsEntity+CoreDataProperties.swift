//
//  ReviewsEntity+CoreDataProperties.swift
//  Zarazquare
//
//  Created by jdumasleon on 24/1/18.
//  Copyright © 2018 Universidad San Jorge. All rights reserved.
//
//

import Foundation
import CoreData


extension ReviewsEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ReviewsEntity> {
        return NSFetchRequest<ReviewsEntity>(entityName: "ReviewsEntity")
    }

    @NSManaged public var author_name: String?
    @NSManaged public var place_name: String?
    @NSManaged public var profile_photo_url: String?
    @NSManaged public var rating: Double
    @NSManaged public var relative_time_description: String?
    @NSManaged public var text: String?
    @NSManaged public var place: PlaceEntity?

}
