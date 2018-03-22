//
//  Entity+CoreDataProperties.swift
//  
//
//  Created by tranvanloc on 5/12/17.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension Entity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Entity> {
        return NSFetchRequest<Entity>(entityName: "Entity")
    }

    @NSManaged public var address: String?
    @NSManaged public var data: NSData?
    @NSManaged public var id: Int64
    @NSManaged public var name: String?

}
