//
//  Note+CoreDataProperties.swift
//  
//
//  Created by Jieun Bae on 1/5/21.
//
//

import Foundation
import CoreData


extension Note {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Note> {
        return NSFetchRequest<Note>(entityName: "Note")
    }

    @NSManaged public var date: Date?
    @NSManaged public var name: String?

}
