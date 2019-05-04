/// Copyright (c) 2018 Razeware LLC


import UIKit
import CoreData

class FilterViewController: UITableViewController {

  @IBOutlet weak var firstPriceCategoryLabel: UILabel!
  @IBOutlet weak var secondPriceCategoryLabel: UILabel!
  @IBOutlet weak var thirdPriceCategoryLabel: UILabel!
  @IBOutlet weak var numDealsLabel: UILabel!

  // MARK: - Price section
  @IBOutlet weak var cheapVenueCell: UITableViewCell!
  @IBOutlet weak var moderateVenueCell: UITableViewCell!
  @IBOutlet weak var expensiveVenueCell: UITableViewCell!

  // MARK: - Most popular section
  @IBOutlet weak var offeringDealCell: UITableViewCell!
  @IBOutlet weak var walkingDistanceCell: UITableViewCell!
  @IBOutlet weak var userTipsCell: UITableViewCell!
  
  // MARK: - Sort section
  @IBOutlet weak var nameAZSortCell: UITableViewCell!
  @IBOutlet weak var nameZASortCell: UITableViewCell!
  @IBOutlet weak var distanceSortCell: UITableViewCell!
  @IBOutlet weak var priceSortCell: UITableViewCell!
  
  var coreDataStack: CoreDataStack!
  
  lazy var cheapVenuePredicate: NSPredicate = {
    return NSPredicate(format: "%K == %@", #keyPath(Venue.priceInfo.priceCategory), "$")
  } ()
  
  lazy var moderateVenuePredicate: NSPredicate = {
    return NSPredicate(format: "%K == %@",
                       #keyPath(Venue.priceInfo.priceCategory), "$$")
  } ()
  
  lazy var expebsiveVenuePredicate: NSPredicate = {
    return NSPredicate(format: "%K == %@",
                       #keyPath(Venue.priceInfo.priceCategory), "$$$")
  }()
  
  // MARK: - View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()

    populateCheapVenueCountLabel()
    populateModerateVenueCountLabel()
    populateExpensiveVenueCountLabel()
    populateDealsCountLabel()
  }
}

// MARK: - IBActions
extension FilterViewController {

  @IBAction func search(_ sender: UIBarButtonItem) {

  }
}

// MARK - UITableViewDelegate
extension FilterViewController {

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
  }
}

// MARK - Helper methods
extension FilterViewController {
  
  func populateCheapVenueCountLabel() {
    let fetchRequest = NSFetchRequest<NSNumber>(entityName: "Venue")
    fetchRequest.resultType = .countResultType
    fetchRequest.predicate = cheapVenuePredicate
    do {
      let countResult = try coreDataStack.managedContext.fetch(fetchRequest)
      let count = countResult.first!.intValue
      let pluralized = count == 1 ? "place" : "places"
      firstPriceCategoryLabel.text = "\(count) bubble tea \(pluralized)"
    } catch let error as NSError {
      print("Count not fetch \(error), \(error.userInfo)")
    }
  }
  
  func populateModerateVenueCountLabel() {
    
    let fetchRequest = NSFetchRequest<NSNumber>(entityName: "Venue")
    fetchRequest.resultType = .countResultType
    fetchRequest.predicate = moderateVenuePredicate
    
    do {
      let countResult =
        try coreDataStack.managedContext.fetch(fetchRequest)
      let count = countResult.first!.intValue
      let pluralized = count == 1 ? "place" : "places"
      secondPriceCategoryLabel.text =
      "\(count) bubble tea \(pluralized)"
    } catch let error as NSError {
      print("Count not fetch \(error), \(error.userInfo)")
    }
  }
  
  func populateExpensiveVenueCountLabel() {
    let fetchRequest: NSFetchRequest<Venue> = Venue.fetchRequest()
    fetchRequest.predicate = expebsiveVenuePredicate
    
    do {
      let count = try coreDataStack.managedContext.count(for: fetchRequest)
      let pluralized = count == 1 ? "place" : "places"
      thirdPriceCategoryLabel.text = "\(count) bubble tea \(pluralized)"
    } catch let error as NSError {
      print("Count not fetch \(error), \(error.userInfo)")
    }
  }
  
  func populateDealsCountLabel() {
    
    // 1
    let fetchRequest = NSFetchRequest<NSDictionary>(entityName: "Venue")
    fetchRequest.resultType = .dictionaryResultType
    
    // 2
    let sumExpressionDesc = NSExpressionDescription()
    sumExpressionDesc.name = "sumDeals"
    
    // 3
    let specialCountExp = NSExpression(forKeyPath: #keyPath(Venue.specialCount))
    sumExpressionDesc.expression = NSExpression(forFunction: "sum:", arguments: [specialCountExp])
    sumExpressionDesc.expressionResultType = .integer32AttributeType
    
    // 4
    fetchRequest.propertiesToFetch = [sumExpressionDesc]
    
    // 5
    do {
      let results = try coreDataStack.managedContext.fetch(fetchRequest)
      
      let resultDict = results.first!
      let numDeals = resultDict["sumDeals"] as! Int
      let pluralized = numDeals == 1 ? "deal" : "deals"
      numDealsLabel.text = "\(numDeals) \(pluralized)"

    } catch let error as NSError {
      print("Could not fetch \(error), \(error.userInfo)")
    }
  }
}

