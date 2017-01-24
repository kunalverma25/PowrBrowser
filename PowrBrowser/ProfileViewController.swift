//
//  ProfileViewController.swift
//  PowrBrowser
//
//  Created by Kunal Verma on 24/01/17.
//  Copyright © 2017 Kunal Verma. All rights reserved.
//

import UIKit
import Firebase
import FontAwesome_swift
import FirebaseStorage
import RealmSwift

class ProfileViewController: UIViewController {
    
    var imagePicker : UIImagePickerController!
    var vc : MainViewController?

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = FIRAuth.auth()!.currentUser!.displayName
        emailLabel.text = FIRAuth.auth()!.currentUser!.email!
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func backPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func logoutPressed(_ sender: Any) {
        do {
            try! FIRAuth.auth()!.signOut()
            print(FIRAuth.auth()?.currentUser)
            self.view.window?.rootViewController?.dismiss(animated: true, completion: { _ in })
            
            let realm = try! Realm()
            var bookmarks = realm.objects(Bookmark)
            var savedInfo = realm.objects(SavedInfo)
            try! realm.write {
                realm.delete(savedInfo)
                realm.delete(bookmarks)
                for wview in (vc?.webViews)! {
                    wview.timer1.invalidate()
                }
            }
        }
        catch {
            print("CATCH")
        }
    }
    
    

}
