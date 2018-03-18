//
//  FavoriteTableViewController.swift
//  Zarazquare
//
//  Created by Charlin Agramonte on 12/17/17.
//  Copyright © 2017 Universidad San Jorge. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class FavoriteTableViewController: UITableViewController, UISplitViewControllerDelegate {

    private var collapseDetailViewController = true

    lazy var context : NSManagedObjectContext = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let persistenContainer = appDelegate.persistentContainer
        return persistenContainer.viewContext
    }()
    
    lazy var frc : NSFetchedResultsController<PlaceEntity> = {
        let req = NSFetchRequest<PlaceEntity>(entityName:"PlaceEntity")
        req.sortDescriptors = [ NSSortDescriptor(key:"name", ascending:true)]
        
        let _frc = NSFetchedResultsController(fetchRequest: req,
                                              managedObjectContext: context,
                                              sectionNameKeyPath: nil,
                                              cacheName: nil)
        
        _frc.delegate = self
        
        try? _frc.performFetch()
        
        return _frc
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        splitViewController?.delegate = self
        
        title = "Favoritos"
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

     func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController:UIViewController, onto primaryViewController:UIViewController) -> Bool {
        
        return collapseDetailViewController
        
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return frc.sections?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        collapseDetailViewController = false
        if let section = frc.sections?[section] {
            return section.numberOfObjects
        }
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var place = PlaceEntity()
        place = frc.object(at: indexPath)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlaceElementCell", for: indexPath) as! FavoriteCell
        cell.path = place.main_photo
        cell.name.text = place.name
        cell.btn_rating_action(score: place.rating)
        cell.addressLablel.text = place.formatted_address
        return cell
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let place = frc.object(at: indexPath)
            do {
                context.delete(place)
                try context.save()
            } catch {
                let alert = UIAlertController(title: "Error", message: "No se pudo eliminar elemento", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                  self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        if identifier == "favoritedetailSegue" ,
            let _ = tableView.indexPathForSelectedRow?.row {
            return true
        } else {
            return false
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "favoritedetailSegue" {
            var place: PlaceEntity
            if let row = tableView.indexPathForSelectedRow?.row {
                place = frc.object(at: IndexPath(row:row, section:0))
                let nav = segue.destination as! UINavigationController
                let nextVC = nav.viewControllers.first as! PlaceDetailTableViewController

                let newPlace = Place(id: place.id, name: place.name, image: place.main_photo, adr_address: place.adr_address, formatted_address: place.formatted_address, formatted_phone_number: place.formatted_phone_number, rating: place.rating)
                nextVC.place = newPlace
                nextVC.IsFromFavorites = true
                
                // Manage the display mode button
                nextVC.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                nextVC.navigationItem.leftItemsSupplementBackButton = true
    
            }
        }
    }
}

extension FavoriteTableViewController : NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        
        switch type {
        case .delete:
            let indexSet = IndexSet(arrayLiteral: sectionIndex)
            tableView.deleteSections(indexSet, with: .fade)
        case .insert:
            let indexSet = IndexSet(arrayLiteral: sectionIndex)
            tableView.insertSections(indexSet, with: .fade)
        default:
            break
        }
    }
    
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .move:
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
        case .update:
            tableView.reloadRows(at: [indexPath!], with: .fade)
            
        }
        
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
}


