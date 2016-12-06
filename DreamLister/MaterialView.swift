//
//  MaterialView.swift
//  DreamLister
//
//  Created by MacTesterSierra on 12/1/16.
//  Copyright © 2016 DIGIGAMES INTERACTIVE. All rights reserved.
//

import UIKit

private var materialKey = false

// we're just creating an extension of UIView instead of subclassing off it.
// basically anything that inherits from UIView will also have the ability we're about to make below
extension UIView {

    // this exposes the variable in the storyboard.
    @IBInspectable var materialDesign: Bool {
        get{
            return materialKey
        }
        set{
            materialKey = newValue
            
            if materialKey{
                self.layer.masksToBounds = false
                self.layer.cornerRadius = 3.0
                self.layer.shadowOpacity = 0.8
                self.layer.shadowRadius = 3.0
                self.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
                self.layer.shadowColor = UIColor(red: 157/255, green: 157/255, blue: 157/255, alpha: 1.0).cgColor
            } else {
                self.layer.cornerRadius = 0
                self.layer.shadowOpacity = 0
                self.layer.shadowRadius = 0
                self.layer.shadowColor = nil
            }
        }
    }

}
