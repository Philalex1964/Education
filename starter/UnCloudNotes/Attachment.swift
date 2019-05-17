//
//  Attachment.swift
//  UnCloudNotes
//
//  Created by Alexander Filippov on 17/05/2019.
//  Copyright © 2019 Ray Wenderlich. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class Attachment: NSManagedObject {
  @NSManaged var dateCreated: Date
  @NSManaged var image: UIImage?
  @NSManaged var note: Note?
}
