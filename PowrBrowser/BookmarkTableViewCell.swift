//
//  BookmarkTableViewCell.swift
//  PowrBrowser
//
//  Created by Kunal Verma on 24/01/17.
//  Copyright © 2017 Kunal Verma. All rights reserved.
//

import UIKit
import FontAwesome_swift

class BookmarkTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var urlLabel: UILabel!
    @IBOutlet weak var deleteBtn: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(_ header: String, data: String) {
        nameLabel.text = header
        urlLabel.text = data
        let s1 = (NSMutableAttributedString(string: String.fontAwesomeIcon(code: "fa-trash")!, attributes: [NSFontAttributeName: UIFont.fontAwesome(ofSize: 45), NSForegroundColorAttributeName: UIColor(red: 188/255, green: 24/255, blue: 0, alpha: 1)]))
        deleteBtn.setAttributedTitle(s1, for: UIControlState())
    }
    var delegate: DeleteDelegate?
    
    @IBAction func deletePressed(_ sender: Any) {
        delegate?.onDeletePressed(sender: self)
    }
}

protocol DeleteDelegate: class {
    func onDeletePressed(sender: BookmarkTableViewCell)
}
