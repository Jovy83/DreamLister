//
//  Item+CoreDataClass.swift
//  DreamLister
//
//  Created by MacTesterSierra on 12/1/16.
//  Copyright © 2016 DIGIGAMES INTERACTIVE. All rights reserved.
//

import Foundation
import CoreData


public class Item: NSManagedObject {

    
    public override func awakeFromInsert() {
        // this is called any time that this item is inserted into the managed object context
        // in other words, when you create this item from the entity
        
        // call super's implementation before anything
        super.awakeFromInsert()
        
        // set the creation timestamp
        self.created = NSDate()
    }
}
