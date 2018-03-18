//
//  PlacesTableViewController.swift
//  Zarazquare
//
//  Created by Charlin Agramonte on 12/17/17.
//  Copyright © 2017 Universidad San Jorge. All rights reserved.
//

import UIKit

class PlacesTableViewController: UITableViewController, UISplitViewControllerDelegate {

    var selectedCategory:Category!
    var places : [Place]?
    lazy var filteredPlaces: [Place]? = {
        return [Place]()
    }()
    
    private var collapseDetailViewController = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        splitViewController?.delegate = self
   
        title = selectedCategory.name;
        
        //Add SearchBar to filter country list item
        let searchController = UISearchController(searchResultsController: nil)
        searchController.delegate = self
        navigationItem.searchController = searchController
        
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = true
        searchController.searchBar.placeholder = "Buscar"
        definesPresentationContext = true

        self.downloadPlaces(nil)
        //Add 'refreshControlAction' method when pulling to refresh the list
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl!.addTarget(self,action: #selector(refreshControlAction(_:)),for: .valueChanged)
    }
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController:UIViewController, onto primaryViewController:UIViewController) -> Bool {
        
        return collapseDetailViewController
        
    }
    
    @objc func refreshControlAction(_ sender: UIRefreshControl) {
        downloadPlaces(sender)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if navigationItem.searchController!.isActive , !textIsEmpty(navigationItem.searchController?.searchBar.text) {
            return filteredPlaces!.count
        } else {
            return places?.count ?? 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var content : [Place]
        if navigationItem.searchController!.isActive, !textIsEmpty(navigationItem.searchController?.searchBar.text) {
            content = filteredPlaces!
        } else {
            content = places!
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlaceCell", for: indexPath) as! PlaceCell
        let place = content[indexPath.row]
        cell.labelItem.text = place.name
        cell.path = place.mainImage
        cell.imageView?.layer.cornerRadius = (cell.imageView?.frame.height)! / 2
        cell.btn_rating_action(score: place.rating ?? 0.0)
        cell.descriptionItem.text = place.formatted_address
        return cell
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        if identifier == "detailSegue" ,
            let _ = tableView.indexPathForSelectedRow?.row {
            return true
        } else {
            return false
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailSegue" {
            var content: [Place]
            if navigationItem.searchController!.isActive, navigationItem.searchController!.searchBar.text?.count ?? 0 > 0 {
                content = filteredPlaces!
            } else {
                content = places!
            }
            
            if let row = tableView.indexPathForSelectedRow?.row {
                let place = content[row]
                let nav = segue.destination as! UINavigationController
                let nextVC = nav.viewControllers.first as! PlaceDetailTableViewController
                
                nextVC.place = place
                nextVC.IsFromFavorites = false
                
                // Manage the display mode button
                nav.topViewController!.navigationItem.leftBarButtonItem = splitViewController!.displayModeButtonItem
            
                nextVC.navigationItem.leftItemsSupplementBackButton = true
                nextVC.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
            }
        }
    }
}

extension PlacesTableViewController {
    
    func downloadPlaces(_ control: UIRefreshControl?) {
        
        
        let session = URLSession.shared
        
        let url = URL(string:baseURL + "types=" + selectedCategory.id! + "&location=41.6998996,-1.1215893&radius=8000&sensor=true&key=" + googleApiKey)!
        
        let request = URLRequest(url: url)
        weak var weakSelf = self
        
        let task = session.dataTask(with: request) { (data, response, error) in
            do {
                var places:[Place]? = [Place]()
                let jsonDecoder = JSONDecoder()
                let responseModel = try jsonDecoder.decode(PlaceRoot.self, from: data!)
                
                //Si hay algun error cargando la data es debido al limite de 2,000 request por dia del
                //api de Google, se peude probar cambiando generando un nuevo APIKey y cambiandolo
                //https://developers.google.com/places/web-service/get-api-key o esperando al otro dia
                
                
                for item in responseModel.results! {
                    //Get place detail
                    let urlDetail = URL(string:placeDetailUrl + "reference=" + item.reference! + "&sensor=true&key=" + googleApiKey)!
                    let requestDetail = URLRequest(url: urlDetail)
                    let taskO = URLSession.shared.dataTask(with: requestDetail) { (data, response, error) in
                        do {
                            let jsonDecoder = JSONDecoder()
                            let response = try jsonDecoder.decode(PlaceDetailRoot.self, from: data!)
                            if response.result == nil{
                                let alert = UIAlertController(title: response.status, message: "No se puedo optener data del servidor, por favor intente mas tarde", preferredStyle: UIAlertControllerStyle.alert)
                                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                                self.present(alert, animated: true, completion: nil)
                                return
                            }else{
                                places?.append(response.result!)
                                
                                if(responseModel.results?.count == places?.count){
                                    DispatchQueue.main.async {
                                        weakSelf?.places = places
                                        weakSelf?.tableView.reloadData()
                                        control?.endRefreshing()
                                    }
                                }
                            }
                        } catch let error as NSError {
                            print(error.localizedDescription)
                        }
                        
                    }
                    taskO.resume()
                }
            } catch let error as NSError {
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    control?.endRefreshing()
                }
            }
        }
        task.resume()
    }
}




