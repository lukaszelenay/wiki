//
//  TableViewCell.swift
//  Wiki
//
//  Created by Lukas Zelenay on 21/03/2021.
//

import UIKit
import WebKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var snippetText: UITextView!
    @IBOutlet weak var saveBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
