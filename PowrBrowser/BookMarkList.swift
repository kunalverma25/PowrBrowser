//
//  BookMarkList.swift
//  PowrBrowser
//
//  Created by Kunal Verma on 24/01/17.
//  Copyright © 2017 Kunal Verma. All rights reserved.
//

import UIKit
import FontAwesome_swift
import RealmSwift

class BookMarkList: UIView, UITableViewDelegate, UITableViewDataSource, DeleteDelegate {
    
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var bookmarksTable: UITableView!
    
    var bookmarks : Results<Bookmark>!
    var webView : WebView?
    
    static func instanceFromNib() -> BookMarkList {
        return UINib(nibName: "BookMarkList", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! BookMarkList
    }
    
    func displayView(onView: WebView) {
        self.alpha = 0.0
        webView = onView
        onView.addSubview(self)
        onView.needsUpdateConstraints()
        baseView.layer.cornerRadius = 10
        baseView.layer.masksToBounds = true
        let s1 = (NSMutableAttributedString(string: String.fontAwesomeIcon(code: "fa-times-circle")!, attributes: [NSFontAttributeName: UIFont.fontAwesome(ofSize: 50), NSForegroundColorAttributeName: UIColor(red: 188/255, green: 24/255, blue: 0, alpha: 1)]))
        closeBtn.layer.cornerRadius = 25
        closeBtn.layer.masksToBounds = true
        closeBtn.setAttributedTitle(s1, for: UIControlState())
        
        // display the view
        transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.alpha = 1.0
            self.transform = .identity
        }) { (finished) -> Void in
        }
    }
    
    func loadData() {
        bookmarksTable.rowHeight = 63
        bookmarksTable.delegate = self
        bookmarksTable.dataSource = self
        bookmarksTable.reloadData()
    }
    
    @IBAction func closeView(_ sender: Any) {
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        }) { (finished) -> Void in
            self.removeFromSuperview()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookmarks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifire = "bkCell"
        var cell = (tableView.dequeueReusableCell(withIdentifier: identifire) as? BookmarkTableViewCell)
        if cell == nil {
            var nib = Bundle.main.loadNibNamed("BookmarkTableViewCell", owner: self, options: nil)
            cell = nib?[0] as? BookmarkTableViewCell
            cell?.configureCell(bookmarks[indexPath.row].Name, data: bookmarks[indexPath.row].Url)
            cell?.selectionStyle = .none
            cell?.delegate = self
            return cell!
        }
        return BookmarkTableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var (str, bool) = (webView?.linkDetect(bookmarks[indexPath.row].Url))!
        if bool {
            webView?.loadWebView(str)
        }
        else {
            str = str.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
            webView?.loadWebView("https://www.google.co.in/search?q=\(str)")
        }
        closeView(self)
    }
    
    
    
    func onDeletePressed(sender: BookmarkTableViewCell) {
        let realm = try! Realm()
        print("as")
        var index = bookmarksTable.indexPath(for: sender)
        bookmarks = realm.objects(Bookmark)
        try! realm.write {
            realm.delete(bookmarks[index!.row])
        }
        bookmarks = realm.objects(Bookmark)
        bookmarksTable.reloadData()
        webView?.checkBookMark()
        if bookmarks.count == 0 {
            closeView(self)
        }
    }
    
}
