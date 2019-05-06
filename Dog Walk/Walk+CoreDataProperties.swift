//
//  Walk+CoreDataProperties.swift
//  Dog Walk
//
//  Created by Александр Филиппов on 03.05.2019.
//  Copyright © 2019 Razeware. All rights reserved.
//
//

import Foundation
import CoreData


extension Walk {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Walk> {
        return NSFetchRequest<Walk>(entityName: "Walk")
    }

    @NSManaged public var date: NSDate?
    @NSManaged public var dog: Dog?

}
