//
//  MenuViewController.swift
//  PowrBrowser
//
//  Created by Kunal Verma on 23/01/17.
//  Copyright © 2017 Kunal Verma. All rights reserved.
//

import UIKit
import Firebase

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var vc : MainViewController?
    
    @IBOutlet weak var menuTable: UITableView!
    var menuItems = ["Browser","My Bookmarks"]
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        menuTable.delegate = self
        menuTable.dataSource = self
        nameLabel.text = FIRAuth.auth()!.currentUser!.displayName!
        emailLabel.text = FIRAuth.auth()!.currentUser!.email!
        // Do any additional setup after loading the view.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func getVC(_ vc: MainViewController){
        self.vc = vc
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath) as! MenuCell
        cell.configureCell(menuItems[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath)
        self.revealViewController().revealToggle(animated: true)
        var wView: WebView?
        for webView in (vc?.webViews)! {
            if !webView.isHidden {
                wView = webView
            }
        }
        if indexPath.row == 1 {
            wView?.showPopUp()
        }
    }
    
    @IBAction func profilePressed(_ sender: Any) {
        
        performSegue(withIdentifier: "profileSegue", sender: nil)
        self.revealViewController().revealToggle(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "profileSegue" {
            (segue.destination as! ProfileViewController).vc = self.vc
        }
    }
}

class MenuCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    func configureCell(_ title: String) {
        titleLabel.text = title
        titleLabel.textColor = UIColor.white
    }
}
