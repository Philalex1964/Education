

import Foundation
import CoreData
import UIKit

class Note: NSManagedObject {
  @NSManaged var title: String
  @NSManaged var body: String
  @NSManaged var dateCreated: Date!
  @NSManaged var displayIndex: NSNumber!
  @NSManaged var attachments: Set<Attachment>?
  
  var image: UIImage? {
    let imageAttachment = latestAttachment as? ImageAttachment
    return imageAttachment?.image
  }
  
  var latestAttachment: Attachment? {
    guard let attachments = attachments,
    let startingAttachment = attachments.first else {
      return nil
    }
    
    return Array(attachments).reduce(startingAttachment) {
      $0.dateCreated.compare($1.dateCreated) == .orderedAscending ? $0 : $1
    }
  }
  override func awakeFromInsert() {
    super.awakeFromInsert()
    dateCreated = Date()
  }
}
