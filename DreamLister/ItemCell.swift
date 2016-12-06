//
//  ItemCell.swift
//  DreamLister
//
//  Created by MacTesterSierra on 12/1/16.
//  Copyright © 2016 DIGIGAMES INTERACTIVE. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {
    
    @IBOutlet weak var thumbnail: UIImageView!
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var details: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(item: Item)
    {
        title.text = item.title
        price.text = "$\(item.price)"
        details.text = item.details
        
        thumbnail.image = item.toImage?.image as? UIImage
    }

}
