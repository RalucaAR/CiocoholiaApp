//
//  Users+CoreDataProperties.swift
//  Project
//
//  Created by Inovium Digital Vision on 14/04/2020.
//  Copyright © 2020 Inovium Digital Vision. All rights reserved.
//
//

import Foundation
import CoreData


extension Users {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Users> {
        return NSFetchRequest<Users>(entityName: "Users")
    }

    @NSManaged public var email: String?
    @NSManaged public var name: String?
    @NSManaged public var password: String?
    @NSManaged public var list: NSSet?

}

// MARK: Generated accessors for list
extension Users {

    @objc(addListObject:)
    @NSManaged public func addToList(_ value: FavoritesList)

    @objc(removeListObject:)
    @NSManaged public func removeFromList(_ value: FavoritesList)

    @objc(addList:)
    @NSManaged public func addToList(_ values: NSSet)

    @objc(removeList:)
    @NSManaged public func removeFromList(_ values: NSSet)

}
