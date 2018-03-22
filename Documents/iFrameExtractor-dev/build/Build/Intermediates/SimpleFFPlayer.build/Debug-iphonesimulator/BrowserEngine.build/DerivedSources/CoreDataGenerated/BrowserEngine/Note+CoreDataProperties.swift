//
//  Note+CoreDataProperties.swift
//  
//
//  Created by loctv on 6/14/17.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension Note {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Note> {
        return NSFetchRequest<Note>(entityName: "Note")
    }

    @NSManaged public var image: String?

}
