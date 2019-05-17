//
//  AttachmentToImageAttachmentMigrationPolicyV3toV4.swift
//  UnCloudNotes
//
//  Created by Alexander Filippov on 17/05/2019.
//  Copyright © 2019 Ray Wenderlich. All rights reserved.
//

import CoreData
import UIKit

let errorDomain = "Migration"

class AttachmentToImageAttachmentMigrationPolicyV3toV4: NSEntityMigrationPolicy {
  
  override func createDestinationInstances(
    forSource sInstance: NSManagedObject,
    in mapping: NSEntityMapping,
    manager: NSMigrationManager) throws {
    
    // 1
    let description = NSEntityDescription.entity(
      forEntityName: "ImageAttachment",
      in: manager.destinationContext)
    let newAttachment = ImageAttachment(entity: description!, insertInto: manager.destinationContext)
    
    // 2
    func traversePropertyMapping(block:
      (NSPropertyMapping, String) -> ()) throws {
      if let attributeMappings = mapping.attributeMappings {
        for propertyMapping in attributeMappings {
          if let destinationName = propertyMapping.name {
            block(propertyMapping, destinationName)
          } else {
            // 3
            let message = "Attribute destination nor configured properly"
            let userInfo = [NSLocalizedFailureReasonErrorKey: message]
            throw NSError(domain: errorDomain,
                          code: 0, userInfo: userInfo)
          }
        }
      } else {
        let message = "No Attribute Mapping found!"
        let userInfo = [NSLocalizedFailureReasonErrorKey: message]
        throw NSError(domain: errorDomain, code: 0, userInfo: userInfo)
      }
    }
    
    // 4
    try traversePropertyMapping {
      propertyMapping, destinationName in
      if let valueExpression = propertyMapping.valueExpression {
        let context: NSMutableDictionary = ["source": sInstance]
        guard let destinationValue = valueExpression.expressionValue(
          with: sInstance,
          context: context) else {
         return
        }
        
        newAttachment.setValue(destinationValue,
                               forKey: destinationName)
      }
    }
    
    // 5
    if let image = sInstance.value(forKey: "image") as? UIImage {
      newAttachment.setValue(image.size.width, forKey: "width")
      newAttachment.setValue(image.size.height, forKey: "height")
    }
    
    // 6
    let body = sInstance.value(forKeyPath: "note.body") as? NSString ?? ""
    newAttachment.setValue(body.substring(to: 80),
                           forKey: "caption")
    
    // 7
    manager.associate(sourceInstance: sInstance,
                      withDestinationInstance: newAttachment,
                      for: mapping)
  }
}
