//
//  AllStandings+CoreDataProperties.swift
//  
//
//  Created by ilker özcan on 29/11/2016.
//
//

import Foundation
import CoreData

enum DB_STANDING_TYPES: Int16 {
	
	case ALL = 0
	case INSIDE = 1
	case OUTSIDE = 2
}

extension AllStandings {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AllStandings> {
        return NSFetchRequest<AllStandings>(entityName: "AllStandings");
    }

	@NSManaged public var standingType: Int16
    @NSManaged public var groupCode: Int32
    @NSManaged public var teamName: String?
    @NSManaged public var teamId: Int64
    @NSManaged public var standingAG: Int32
    @NSManaged public var standingAVG: Int32
    @NSManaged public var standingB: Int32
    @NSManaged public var standingG: Int32
    @NSManaged public var standingM: Int32
    @NSManaged public var standingOM: Int32
    @NSManaged public var standingPTS: Int32
    @NSManaged public var standingYG: Int32
	@NSManaged public var lastUpdateDate: NSDate
    @NSManaged public var league: Leagues?

}
