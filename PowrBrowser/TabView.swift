//
//  TabView.swift
//  PowrBrowser
//
//  Created by Kunal Verma on 21/01/17.
//  Copyright © 2017 Kunal Verma. All rights reserved.
//

import UIKit
import FontAwesome_swift

class TabView: UIView {
    
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var selectBtn: UIButton!
    
    var mainView : MainViewController?
    
    static func instanceFromNib() -> TabView {
        return UINib(nibName: "TabView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! TabView
    }
    
    override func awakeFromNib() {
        let s1 = (NSMutableAttributedString(string: String.fontAwesomeIcon(code: "fa-times-circle")!, attributes: [NSFontAttributeName: UIFont.fontAwesome(ofSize: 28), NSForegroundColorAttributeName: UIColor(red: 188/255, green: 24/255, blue: 0, alpha: 1)]))
        closeBtn.setAttributedTitle(s1, for: .normal)
        baseView.layer.cornerRadius = 10
        baseView.layer.masksToBounds = true
    }
    
    var delegate: ButtonDelegate?
    
    @IBAction func tabSelected(_ sender: Any) {
        delegate?.onButtonTap(sender: sender as! UIButton)
    }
    
    @IBAction func closePressed(_ sender: Any) {
        delegate?.onCloseTap(sender: sender as! UIButton)
    }
    
    
}

protocol ButtonDelegate: class {
    func onButtonTap(sender: UIButton)
    func onCloseTap(sender: UIButton)
}
