//
//  FavoriteTableViewCell.swift
//  Zarazquare
//
//  Created by Charlin Agramonte on 12/18/17.
//  Copyright © 2017 Universidad San Jorge. All rights reserved.
//

import UIKit

class FavoriteCell: UITableViewCell {

    @IBOutlet weak var addressLablel: UILabel!
    @IBOutlet weak var imageItem: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet var btn_rating: [UIButton]!
    
    func btn_rating_action(score points: Double) {
        for btn_star in btn_rating {
            if Double(btn_star.tag) <  points {
                btn_star.setTitle("★", for: .normal)
            } else {
                btn_star.setTitle("☆", for: .normal)
            }
        }
    }
    
    var task : URLSessionTask?
    
    var path : String? {
        didSet {
            if path != nil {
                let image = PlaceCache.shared.find(path!,
                                                   completion: { (image) in
                                                    self.imageItem.image = image
                                                    UIView.animate(withDuration: 0.3,
                                                                   delay: 0.0,
                                                                   options: UIViewAnimationOptions.curveEaseIn ,
                                                                   animations: {
                                                                    self.imageItem.alpha = 1.0
                                                    }, completion: nil)
                })
                
                if image != nil {
                    imageItem.image = image
                    imageItem.alpha = 1.0
                } else {
                    imageItem.alpha = 0.0
                }
                
            }
        }
    }
}
