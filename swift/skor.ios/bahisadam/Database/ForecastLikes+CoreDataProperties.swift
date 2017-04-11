//
//  ForecastLikes+CoreDataProperties.swift
//  
//
//  Created by ilker özcan on 30/11/2016.
//
//

import Foundation
import CoreData


extension ForecastLikes {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ForecastLikes> {
        return NSFetchRequest<ForecastLikes>(entityName: "ForecastLikes");
    }

    @NSManaged public var forecastId: String
    @NSManaged public var likeDate: NSDate?

}
