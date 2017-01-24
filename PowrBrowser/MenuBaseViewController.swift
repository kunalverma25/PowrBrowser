//
//  MenuBaseViewController.swift
//  PowrBrowser
//
//  Created by Kunal Verma on 24/01/17.
//  Copyright © 2017 Kunal Verma. All rights reserved.
//

import UIKit
import SWRevealViewController

class MenuBaseViewController: SWRevealViewController {

    var vc1 : MainViewController? = nil
    var vc2 : MenuViewController? = nil
    
    var bool = [false, false]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sw_rear" {
            vc2 = segue.destination as? MenuViewController
            bool[0] = true
        }
        if segue.identifier == "sw_front" {
            vc1 = segue.destination as? MainViewController
            bool[1] = true
        }
        if bool[0] == true && bool[1] == true {
            vc2!.getVC(vc1!)
        }
    }

}
