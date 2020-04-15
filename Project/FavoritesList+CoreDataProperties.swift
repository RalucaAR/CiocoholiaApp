//
//  FavoritesList+CoreDataProperties.swift
//  Project
//
//  Created by Inovium Digital Vision on 14/04/2020.
//  Copyright © 2020 Inovium Digital Vision. All rights reserved.
//
//

import Foundation
import CoreData


extension FavoritesList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoritesList> {
        return NSFetchRequest<FavoritesList>(entityName: "FavoritesList")
    }

    @NSManaged public var productId: String
    @NSManaged public var owner: Users?

}
