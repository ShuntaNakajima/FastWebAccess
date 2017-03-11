//
//  ItemTableViewCell.swift
//  FastWebAccess
//
//  Created by nakajimashunta on 2017/03/07.
//  Copyright © 2017年 ShuntaNakajima. All rights reserved.
//

import UIKit

class ItemTableViewCell: UITableViewCell {

    @IBOutlet var ImageView:UIImageView!
    @IBOutlet var UrlLabel:UILabel!
    @IBOutlet var TitleLabel:UILabel!
    @IBOutlet var ImageLabel:UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
