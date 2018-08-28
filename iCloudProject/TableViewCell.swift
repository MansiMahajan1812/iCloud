//
//  TableViewCell.swift
//  iCloudProject
//
//  Created by Mansi Mahajan on 7/9/18.
//  Copyright © 2018 Mansi Mahajan. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var branch: UILabel!
    @IBOutlet weak var age: UILabel!
    @IBOutlet weak var mobile: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var imageSet: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
