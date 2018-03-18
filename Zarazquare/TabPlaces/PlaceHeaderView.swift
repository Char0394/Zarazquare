//
//  PlaceHeaderView.swift
//  Zarazquare
//
//  Created by jdumasleon on 16/1/18.
//  Copyright © 2018 Universidad San Jorge. All rights reserved.
//

import UIKit

class PlaceHeaderView: UICollectionReusableView {

    @IBOutlet weak var backgroundHeaderView: UIImageView!
    
    var headerImage: String! {
        didSet{
            backgroundHeaderView.image = UIImage(named: headerImage)
        }
    }}
