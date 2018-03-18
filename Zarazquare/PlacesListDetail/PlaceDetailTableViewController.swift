//
//  PlaceDetailTableViewController.swift
//  Zarazquare
//
//  Created by jdumasleon on 20/1/18.
//  Copyright © 2018 Universidad San Jorge. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class PlaceDetailTableViewController: UITableViewController {
    
    var headerView: DetailHeaderView!
    var headerMaskLayer: CAShapeLayer!
    var place:Place!
    var IsFromFavorites = false

    // MARK - Private
    private let tableHeaderViewHeight: CGFloat = 300.0  // CODE CHALLENGE: make this height dynamic with the height of the VC - 3/4 of the height
    private let tableHeaderViewCutaway: CGFloat = 40.0
    
    lazy var context : NSManagedObjectContext = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let persistenContainer = appDelegate.persistentContainer
        return persistenContainer.viewContext
    }()
    
    let reqPlace = NSFetchRequest<PlaceEntity>(entityName:"PlaceEntity")
    var reqReview = NSFetchRequest<ReviewsEntity>(entityName:"ReviewsEntity")
    
    
    // Places Entities
    lazy var frc : NSFetchedResultsController<PlaceEntity> = {
        reqPlace.sortDescriptors = [ NSSortDescriptor(key:"name", ascending:true)]
        let _frc = NSFetchedResultsController(fetchRequest: reqPlace,
                                              managedObjectContext: context,
                                              sectionNameKeyPath: nil,
                                              cacheName: nil)
        
        _frc.delegate = self as? NSFetchedResultsControllerDelegate
        try? _frc.performFetch()
        return _frc
    }()
    
    // Reviews Entities
    lazy var revc : NSFetchedResultsController<ReviewsEntity> = {
        if place != nil {
            reqReview.predicate = NSPredicate(format: "place.name = %@", place.name!)
        }
        reqReview.sortDescriptors = [ NSSortDescriptor(key:"author_name", ascending:true)]
        let _revc = NSFetchedResultsController(fetchRequest: reqReview,
                                              managedObjectContext: context,
                                              sectionNameKeyPath: nil,
                                              cacheName: nil)
        
        _revc.delegate = self as? NSFetchedResultsControllerDelegate
        try? _revc.performFetch()
        return _revc
    }()
    
    // Initialize
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Detail"

        if IsFromFavorites == true {
            self.navigationItem.rightBarButtonItem = nil
        }
        
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        
        headerView = tableView.tableHeaderView as! DetailHeaderView
        headerView.name.text = place?.name
        headerView.image = place?.mainImage
        headerView.address.text = place?.formatted_address
        headerView.btn_rating_action(score: place?.rating ?? 0.0)
        headerView.webSite.text = place?.website
        tableView.tableHeaderView = nil
        tableView.addSubview(headerView)
        
        tableView.contentInset = UIEdgeInsets(top: tableHeaderViewHeight, left: 0, bottom: 0, right: 0)
        tableView.contentOffset = CGPoint(x: 0, y: -tableHeaderViewHeight + 64)
        
        // cut away the header view
        headerMaskLayer = CAShapeLayer()
        headerMaskLayer.fillColor = UIColor.black.cgColor
        headerView.layer.mask = headerMaskLayer
        
        let effectiveHeight = tableHeaderViewHeight - tableHeaderViewCutaway/2
        tableView.contentInset = UIEdgeInsets(top: effectiveHeight, left: 0, bottom: 0, right: 0)
        tableView.contentOffset = CGPoint(x: 0, y: -effectiveHeight)
        
        updateHeaderView()

    }

    func updateHeaderView()
    {
        let effectiveHeight = tableHeaderViewHeight - tableHeaderViewCutaway/2
        var headerRect = CGRect(x: 0, y: -effectiveHeight, width: tableView.bounds.width, height: tableHeaderViewHeight)
        
        if tableView.contentOffset.y < -effectiveHeight {
            headerRect.origin.y = tableView.contentOffset.y
            headerRect.size.height = -tableView.contentOffset.y + tableHeaderViewCutaway/2
        }
        
        if headerView != nil {
            headerView?.frame = headerRect
        }
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: headerRect.width, y: 0))
        path.addLine(to: CGPoint(x: headerRect.width, y: headerRect.height))
        path.addLine(to: CGPoint(x: 0, y: headerRect.height - tableHeaderViewCutaway))
        
        headerMaskLayer?.path = path.cgPath
    }
    
    // TableView Methods
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let section = revc.sections?[section], section.numberOfObjects > 0 {
            return section.numberOfObjects
        } else {
            if let reviews = place?.reviews {
                return reviews.count
            } else {
                return 0
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlaceDetailCell", for: indexPath) as! PlaceDetailCell
        
        
        if IsFromFavorites == true {
            var review = ReviewsEntity()
            review = revc.object(at: indexPath)
            cell.path = review.profile_photo_url
            cell.nameLabel.text = review.author_name
            cell.btn_rating_action(score: review.rating)
            cell.descriptionLabel.text = review.text
        } else {
            if place != nil {
                if let reviews = place.reviews, indexPath.row < reviews.count {
                    cell.path = reviews[indexPath.row].profile_photo_url
                    cell.nameLabel.text = reviews[indexPath.row].author_name
                    cell.btn_rating_action(score: reviews[indexPath.row].rating ?? 0.0)
                    cell.descriptionLabel.text = reviews[indexPath.row ].text
                }
            }else{
                cell.path = nil
                cell.nameLabel.text = nil
                cell.descriptionLabel.text = nil
            }
        }
        return cell
    }
    
    @IBOutlet weak var favorite: UIBarButtonItem!
    @IBAction func addPlaceAsFavorite(_ sender: Any) {
        
        if(place != nil){
            favorite.image = #imageLiteral(resourceName: "IsFavorite")
            savePlace(place)
        }
    }
    
    func savePlace(_ localPlace: Place) {
   
        //Persist data
        reqPlace.sortDescriptors = [ NSSortDescriptor(key:"name", ascending:true)]
        _ = try? context.fetch(reqPlace)
            
        let newPlace = NSEntityDescription.insertNewObject(forEntityName: "PlaceEntity", into: context) as! PlaceEntity
        newPlace.name = place.name
        newPlace.main_photo = place.mainImage
        newPlace.adr_address = place.adr_address
        newPlace.formatted_address = place.formatted_address
        newPlace.icon = place.icon
        newPlace.rating = place.rating ?? 0.0
        newPlace.international_phone_number = place.international_phone_number
        newPlace.website = place.website

        reqReview.sortDescriptors = [ NSSortDescriptor(key:"author_name", ascending:true)]
        _ = try? context.fetch(reqReview)
        
        for review in place.reviews! {
            let newReview = NSEntityDescription.insertNewObject(forEntityName: "ReviewsEntity", into: context) as! ReviewsEntity
                
            newReview.place_name = place.name
            newReview.author_name = review.author_name
            newReview.text = review.text
            newReview.rating = review.rating ?? 0.0
            newReview.profile_photo_url = review.profile_photo_url
            newReview.relative_time_description = review.relative_time_description
            newReview.place = newPlace
            
            try? context.save()
            
            newPlace.addToReviews(newReview)
        }
 
        try? context.save()
    }

}

extension PlaceDetailTableViewController
{
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateHeaderView()
    }
}
