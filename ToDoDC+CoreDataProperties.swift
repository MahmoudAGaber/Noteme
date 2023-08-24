//
//  ToDoDC+CoreDataProperties.swift
//  To-Do
//
//  Created by MAG on 09/08/2023.
//
//

import Foundation
import CoreData


extension ToDoDC {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToDoDC> {
        return NSFetchRequest<ToDoDC>(entityName: "ToDoDC")
    }

    @NSManaged public var id: String?
    @NSManaged public var color: String?
    @NSManaged public var name: String?
    @NSManaged public var desc: String?
    @NSManaged public var date: String?
    @NSManaged public var time: String?

}

extension ToDoDC : Identifiable {

}
