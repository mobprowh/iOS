//
//  Leagues+CoreDataProperties.swift
//  
//
//  Created by ilker özcan on 29/11/2016.
//
//

import Foundation
import CoreData


extension Leagues {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Leagues> {
        return NSFetchRequest<Leagues>(entityName: "Leagues");
    }

    @NSManaged public var leagueId: Int64
    @NSManaged public var leagueName: String?
    @NSManaged public var leagueOrder: Int32
	@NSManaged public var countryCode: String?
	@NSManaged public var lastUpdateDate: NSDate
    @NSManaged public var country: Countries?
	@NSManaged public var standings: NSSet?

}

// MARK: Generated accessors for AllStandings
extension Leagues {
	
	@objc(addAllStandingsObject:)
	@NSManaged public func addToAllStandings(_ value: AllStandings)
	
	@objc(removeAllStandingsObject:)
	@NSManaged public func removeFromAllStandings(_ value: AllStandings)
	
	@objc(addAllStandings:)
	@NSManaged public func addToAllStandings(_ values: NSSet)
	
	@objc(removeAllStandings:)
	@NSManaged public func removeFromAllStandings(_ values: NSSet)
	
}
