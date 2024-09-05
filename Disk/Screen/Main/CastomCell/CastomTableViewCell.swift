//
//  CastomTableViewCell.swift
//  Disk
//
//  Created by Георгий on 21.07.2024.
//

import Foundation
import UIKit

class CastomTableViewCell: UITableViewCell {
    
    @IBOutlet weak var weightDataTimeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var optionImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        optionImage.contentMode = .center
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
}
