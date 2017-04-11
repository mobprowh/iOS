//
//  Countries+CoreDataProperties.swift
//  
//
//  Created by ilker özcan on 29/11/2016.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension Countries {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Countries> {
        return NSFetchRequest<Countries>(entityName: "Countries");
    }

	@NSManaged public var countryId: Int64
	@NSManaged public var country: String?
	@NSManaged public var countryOrder: Int32
	@NSManaged public var countryCode: String?
	@NSManaged public var lastUpdateDate: NSDate
	@NSManaged public var leagues: NSOrderedSet?

}

// MARK: Generated accessors for leagues
extension Countries {

	@objc(insertObject:inLeaguesAtIndex:)
	@NSManaged public func insertIntoLeagues(_ value: Leagues, at idx: Int)
	
	@objc(removeObjectFromLeaguesAtIndex:)
	@NSManaged public func removeFromLeagues(at idx: Int)
	
	@objc(insertLeagues:atIndexes:)
	@NSManaged public func insertIntoLeagues(_ values: [Leagues], at indexes: NSIndexSet)
	
	@objc(removeLeaguesAtIndexes:)
	@NSManaged public func removeFromLeagues(at indexes: NSIndexSet)
	
	@objc(replaceObjectInLeaguesAtIndex:withObject:)
	@NSManaged public func replaceLeagues(at idx: Int, with value: Leagues)
	
	@objc(replaceLeaguesAtIndexes:withLeagues:)
	@NSManaged public func replaceLeagues(at indexes: NSIndexSet, with values: [Leagues])
	
	@objc(addLeaguesObject:)
	@NSManaged public func addToLeagues(_ value: Leagues)
	
	@objc(removeLeaguesObject:)
	@NSManaged public func removeFromLeagues(_ value: Leagues)
	
	@objc(addLeagues:)
	@NSManaged public func addToLeagues(_ values: NSOrderedSet)
	
	@objc(removeLeagues:)
	@NSManaged public func removeFromLeagues(_ values: NSOrderedSet)

}
