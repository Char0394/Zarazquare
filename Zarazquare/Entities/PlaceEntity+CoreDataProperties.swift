//
//  PlaceEntity+CoreDataProperties.swift
//  Zarazquare
//
//  Created by jdumasleon on 24/1/18.
//  Copyright © 2018 Universidad San Jorge. All rights reserved.
//
//

import Foundation
import CoreData


extension PlaceEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PlaceEntity> {
        return NSFetchRequest<PlaceEntity>(entityName: "PlaceEntity")
    }

    @NSManaged public var adr_address: String?
    @NSManaged public var formatted_address: String?
    @NSManaged public var formatted_phone_number: String?
    @NSManaged public var icon: String?
    @NSManaged public var id: String?
    @NSManaged public var international_phone_number: String?
    @NSManaged public var main_photo: String?
    @NSManaged public var name: String?
    @NSManaged public var place_id: String?
    @NSManaged public var rating: Double
    @NSManaged public var types: String?
    @NSManaged public var url: String?
    @NSManaged public var utc_offset: Int32
    @NSManaged public var vicinity: String?
    @NSManaged public var website: String?
    @NSManaged public var reviews: NSSet?

}

// MARK: Generated accessors for reviews
extension PlaceEntity {

    @objc(addReviewsObject:)
    @NSManaged public func addToReviews(_ value: ReviewsEntity)

    @objc(removeReviewsObject:)
    @NSManaged public func removeFromReviews(_ value: ReviewsEntity)

    @objc(addReviews:)
    @NSManaged public func addToReviews(_ values: NSSet)

    @objc(removeReviews:)
    @NSManaged public func removeFromReviews(_ values: NSSet)

}
