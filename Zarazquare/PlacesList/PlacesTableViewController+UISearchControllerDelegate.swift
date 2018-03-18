//
//  PlacesTableViewController+UISearchControllerDelegate.swift
//  Zarazquare
//
//  Created by Charlin Agramonte on 12/21/17.
//  Copyright © 2017 Universidad San Jorge. All rights reserved.
//

import UIKit

extension PlacesTableViewController : UISearchControllerDelegate,UISearchResultsUpdating{
    
    //Filter countries by name (This function will ignor the uppercase letters)
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredPlaces = places!.filter({( place : Place) -> Bool in
            let name = place.name
            return name!.lowercased().contains(searchText.lowercased())
        })
        
    }
    
    //Validate if the Text Is Empty
    func textIsEmpty( _ text : String?) -> Bool {
        return (text?.count ?? 0 == 0)
    }
    
    //Execute when user type on the Search bar
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text
        
        //If the user delete his search, clean the filteredCountries array
        if textIsEmpty(searchText){
            filteredPlaces = [Place]()
        }else{
            filterContentForSearchText(searchText!)
        }
        tableView.reloadData()
        
    }
}
