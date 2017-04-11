//
//  ForecastComments+CoreDataProperties.swift
//  
//
//  Created by ilker özcan on 22/12/2016.
//
//

import Foundation
import CoreData


extension ForecastComments {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ForecastComments> {
        return NSFetchRequest<ForecastComments>(entityName: "ForecastComments");
    }

    @NSManaged public var matchId: String?
    @NSManaged public var commentDate: NSDate?

}
