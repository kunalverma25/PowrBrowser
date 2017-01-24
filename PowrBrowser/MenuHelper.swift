//
//  MenuHelper.swift
//  PowrBrowser
//
//  Created by Kunal Verma on 23/01/17.
//  Copyright © 2017 Kunal Verma. All rights reserved.
//

import Foundation
import SWRevealViewController
//
//class SideMenuClass: UIViewController {
//    
//    func buttonClicked(_ sender: UIButton!) {
//        print("Button Clicked")
//    }

func SideMenuShow(vc: UIViewController, menuButton: UIButton) {
    
    if UIDevice.current.userInterfaceIdiom == .pad {
        vc.revealViewController().rearViewRevealWidth = 400
    }
    else {
        let screenSize: CGRect = UIScreen.main.bounds
        vc.revealViewController().rearViewRevealWidth = screenSize.width - 60
    }
    vc.tabBarController?.tabBar.isHidden = true
    if vc.revealViewController() != nil {
        menuButton.addTarget(vc.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        //menuButton.target = vc.revealViewController()
        //menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        vc.view.addGestureRecognizer(vc.revealViewController().panGestureRecognizer())
    }
}
