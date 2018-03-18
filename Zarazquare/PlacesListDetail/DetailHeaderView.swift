//
//  DetailHeaderView.swift
//  Zarazquare
//
//  Created by jdumasleon on 21/1/18.
//  Copyright © 2018 Universidad San Jorge. All rights reserved.
//

import UIKit

class DetailHeaderView: UIView {
   
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var webSite: UILabel!
    @IBOutlet var btn_rating: [UIButton]!
    
    // Set Rating
    func btn_rating_action(score points: Double) {
        for btn_star in btn_rating {
            if Double(btn_star.tag) <  points {
                btn_star.setTitle("★", for: .normal)
            } else {
                btn_star.setTitle("☆", for: .normal)
            }
        }
    }
    
    var image: String? {
        didSet {
            weak var weakSelf = self
            if let code = image {
                let image = PlaceCache.shared.find(code, completion: { (image) in
                    if image != nil {
                        weakSelf?.fillImage(image!)
                    }
                })
                
                if image != nil{
                    weakSelf?.fillImage(image!)
                }
            } else {
                imageView.image = nil
            }
        }
    }
    
    // Image Animation
    func fillImage( _ image: UIImage) {
        imageView.image = image
        weak var weakSelf = self
        
        UIView.animate(withDuration: 0.5,
                       animations: {
                        weakSelf?.imageView.transform = CGAffineTransform(scaleX:1.5, y:1.5)
                        weakSelf?.imageView.alpha = 1.0
        }) { done in
            
            UIView.animate(withDuration: 0.3,
                           animations: {
                            weakSelf?.imageView.transform = .identity
            })
            
        }
    }
}
