//
//  Entity+CoreDataProperties.swift
//  SimpleFFPlayer
//
//  Created by tranvanloc on 4/21/17.
//  Copyright © 2017 jefby. All rights reserved.
//

import Foundation
import CoreData


extension Entity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Entity> {
        return NSFetchRequest<Entity>(entityName: "Entity")
    }

//    @NSManaged public var name: String?
//    @NSManaged public var id: Int64
//    @NSManaged public var address: String?
//    @NSManaged public var data: NSData?

}
