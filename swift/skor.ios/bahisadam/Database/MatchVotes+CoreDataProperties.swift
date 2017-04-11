//
//  MatchVotes+CoreDataProperties.swift
//  
//
//  Created by ilker özcan on 28/11/2016.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension MatchVotes {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MatchVotes> {
		
        return NSFetchRequest<MatchVotes>(entityName: "MatchVotes");
    }

    @NSManaged public var matchId: String?
    @NSManaged public var vote: Int16

}
