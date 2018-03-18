//
//  PlaceViewController.swift
//  Zarazquare
//
//  Created by Charlin Agramonte on 12/17/17.
//  Copyright © 2017 Universidad San Jorge. All rights reserved.
//

import UIKit

class PlaceViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISplitViewControllerDelegate {

    // MARK: - Properties
    private let reuseIdentifier = "categoryCell"
    var headerView: PlaceHeaderView!
    var selectedIndexPath: IndexPath!
    
    var categoryList = [Category]()
    //let leftAndRightPaddings: CGFloat = 1.0
    //let numberOfItemsPerRow: CGFloat = 2.0

    @IBOutlet weak var placeCollectionView: UICollectionView!
    private var collapseDetailViewController = true
    override func viewDidLoad() {
        super.viewDidLoad()
        
        splitViewController?.delegate = self
        placeCollectionView.delegate = self
        placeCollectionView.dataSource = self

        categoryList.append(Category(id: "restaurant", name: "Restaurants", image: "Restaurants"))
        categoryList.append(Category(id: "museum", name: "Museums", image: "Museums"))
        categoryList.append(Category(id: "nightClubs", name: "NightClubs", image: "NightClubs"))
        categoryList.append(Category(id: "banks", name: "Banks", image: "Banks"))
        categoryList.append(Category(id: "bars", name: "Bars", image: "Bars"))
        categoryList.append(Category(id: "hospitals", name: "Hospitals", image: "Hospitals"))
        
        //let collectionViewWidth = placeCollectionView?.frame.width
        //let itemWidth = (collectionViewWidth! - leftAndRightPaddings) / numberOfItemsPerRow
        
       // let layout = placeCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
       // layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        
        let navigationController = splitViewController!.viewControllers[splitViewController!.viewControllers.count-1] as! UINavigationController
        navigationController.topViewController!.navigationItem.leftBarButtonItem = splitViewController!.displayModeButtonItem
    }
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController:UIViewController, onto primaryViewController:UIViewController) -> Bool {
        
        return collapseDetailViewController
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PlaceCategoryViewCell
        cell.imageCellView.image = UIImage(named: categoryList[indexPath.row].image!)
        cell.labelCellView.text = categoryList[indexPath.row].name
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView
    {
        headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "PlaceHeaderView", for: indexPath) as! PlaceHeaderView
        headerView.backgroundHeaderView.image = #imageLiteral(resourceName: "Background")
        
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collapseDetailViewController = false
        let myViewDetailPage:PlacesTableViewController = self.storyboard?.instantiateViewController(withIdentifier: "PlacesTableViewController") as! PlacesTableViewController
        
        myViewDetailPage.selectedCategory = categoryList[indexPath.row]
        
        self.navigationController?.pushViewController(myViewDetailPage, animated:true)
        
    }
}

extension PlaceViewController : ZoomingViewController
{
    func zoomingBackgroundView(for transition: ZoomTransitioningDelegate) -> UIView? {
        return nil
    }
    
    func zoomingImageView(for transition: ZoomTransitioningDelegate) -> UIImageView? {
        if let indexPath = selectedIndexPath {
            let cell = placeCollectionView?.cellForItem(at: indexPath) as! PlaceCategoryViewCell
            return cell.imageCellView
        }
        
        return nil
    }
}


