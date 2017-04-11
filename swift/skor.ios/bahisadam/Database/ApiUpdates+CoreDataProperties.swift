//
//  ApiUpdates+CoreDataProperties.swift
//  
//
//  Created by ilker özcan on 29/11/2016.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension ApiUpdates {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ApiUpdates> {
        return NSFetchRequest<ApiUpdates>(entityName: "ApiUpdates");
    }

    @NSManaged public var apiName: String?
    @NSManaged public var lastUpdateDate: NSDate?

}
