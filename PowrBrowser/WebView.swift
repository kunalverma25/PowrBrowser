//
//  WebView.swift
//  PowrBrowser
//
//  Created by Kunal Verma on 21/01/17.
//  Copyright © 2017 Kunal Verma. All rights reserved.
//

import UIKit
import FontAwesome_swift
import WebKit
import RealmSwift
import SwiftyJSON
import SCLAlertView
import Firebase

class WebView: UIView, WKNavigationDelegate, WKUIDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var addressBar: UISearchBar!
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var forwardButton: UIBarButtonItem!
    @IBOutlet weak var reloadStopButton: UIBarButtonItem!
    @IBOutlet weak var bookmarkBtn: UIButton!
    
    var tabIDValue = 0
    
    var browserWebView : WKWebView!
    var timer1 = Timer()
    var mainView: MainViewController?
    
    var visitDate = ""
    var localDate = ""
    var transition = "new tab"
    var previousURL = ""
    
    var bookmarks : Results<Bookmark>!

    static func instanceFromNib() -> WebView {
        return UINib(nibName: "WebView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! WebView
    }
    
    override func awakeFromNib() {
        browserWebView = WKWebView()
        baseView.addSubview(browserWebView)
        browserWebView.navigationDelegate = self
        browserWebView.uiDelegate = self
        browserWebView.allowsBackForwardNavigationGestures = true
        addressBar.autocapitalizationType = .none
        addressBar.returnKeyType = .go
        addressBar.delegate = self
        addressBar.setImage(UIImage(named: "go"), for: .search, state: .normal)
        browserWebView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        loadWebView("http://google.com/")
        checkBookMark()
        var tabID = UserDefaults.standard.integer(forKey: "tabID")
        tabIDValue = tabID
        tabID += 1
        UserDefaults.standard.set(tabID, forKey: "tabID")
        UserDefaults.standard.synchronize()
    }
    
    @IBAction func bookmarkPressed(_ sender: Any) {
        let realm = try! Realm()
        let alertView = SCLAlertView()
        let (bkmark , isBkmrk) = checkBookMark()
        if isBkmrk {
            var nameField = alertView.addTextField(bkmark?.Name)
            var urlField = alertView.addTextField(bkmark?.Url)
            nameField.text = bkmark?.Name
            urlField.text = bkmark?.Url
            alertView.addButton("Save Bookmark", action: {
                try! realm.write {
                    let dataToSave = Bookmark(value: ["\(FIRAuth.auth()!.currentUser!.uid)","\(bkmark!.Name)", "\(bkmark!.Url)"])
                    realm.add(dataToSave, update: true)
                }
                self.checkBookMark()
            })
            alertView.addButton("Remove Bookmark", action: {
                try! realm.write {
                    realm.delete(bkmark!)
                }
                self.checkBookMark()
            })
        }
        else {
            var nameField = alertView.addTextField(browserWebView.title)
            var urlField = alertView.addTextField(browserWebView.url?.absoluteString)
            nameField.text = browserWebView.title
            urlField.text = browserWebView.url?.absoluteString
            alertView.addButton("Save Bookmark", action: {
                try! realm.write {
                    let dataToSave = Bookmark(value: ["\(FIRAuth.auth()!.currentUser!.uid)", "\(nameField.text!)", "\(urlField.text!)"])
                    realm.add(dataToSave, update: true)
                }
                self.checkBookMark()
            })
        }
        alertView.showEdit("Edit Bookmark", subTitle: "Save Your Bookmark")
    }
    
    
    func checkBookMark() -> (Bookmark?, Bool) {
        let realm = try! Realm()
        var bkmark : Bookmark? = nil
        bookmarks = realm.objects(Bookmark)
        print(bookmarks)
        var isBkmrk = false
        
        for bookmark in bookmarks {
            if bookmark.Url == browserWebView.url?.absoluteString {
                isBkmrk = true
                bkmark = bookmark
            }
        }
        
        if isBkmrk {
            let s1 = (NSMutableAttributedString(string: String.fontAwesomeIcon(code: "fa-star")!, attributes: [NSFontAttributeName: UIFont.fontAwesome(ofSize: 28), NSForegroundColorAttributeName: UIColor(red: 188/255, green: 24/255, blue: 0, alpha: 1)]))
            bookmarkBtn.setAttributedTitle(s1, for: .normal)
        }
        else {
            let s1 = (NSMutableAttributedString(string: String.fontAwesomeIcon(code: "fa-star-o")!, attributes: [NSFontAttributeName: UIFont.fontAwesome(ofSize: 40), NSForegroundColorAttributeName: UIColor(red: 188/255, green: 24/255, blue: 0, alpha: 1)]))
            bookmarkBtn.setAttributedTitle(s1, for: .normal)
            bkmark = nil
        }
        
        return (bkmark, isBkmrk)
    }
    
    func loadWebView(_ str: String) {
        
        let url = URL(string: str)!
        let req = URLRequest(url: url)
        browserWebView.load(req)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            backButton.isEnabled = browserWebView.canGoBack
            forwardButton.isEnabled = browserWebView.canGoForward
            if browserWebView.estimatedProgress == 0 {
                reloadStopButton.tag = 0
                reloadStopButton.title = "↺"
                progressView.isHidden = true
            }
            else if browserWebView.estimatedProgress == 1 {
                reloadStopButton.tag = 0
                reloadStopButton.title = "↺"
                progressView.isHidden = true
            }
            else {
                reloadStopButton.title = "✖︎"
                reloadStopButton.tag = 1
                progressView.isHidden = false
                progressView.progress = Float(browserWebView.estimatedProgress)
            }
        }
    }
    
    @IBAction func navigationItemsPressed(_ sender: UIBarButtonItem) {
        switch sender.tag {
        case 0:
            browserWebView.reload()
        case 1:
            browserWebView.stopLoading()
        case 2:
            browserWebView.goBack()
        case 3:
            browserWebView.goForward()
        default:
            return
        }
    }
    
    
    //To allow the page to be loaded even with an invalid certificate
    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        completionHandler(Foundation.URLSession.AuthChallengeDisposition.useCredential, URLCredential(trust: ((challenge.protectionSpace.serverTrust))!))
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        let alertController = UIAlertController(title: "OOPS!!", message: error.localizedDescription + "\nPlease reload the page.", preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "Close", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        
        mainView?.present(alertController, animated: true, completion: nil)
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        let alertController = UIAlertController(title: "OOPS!!", message: error.localizedDescription + "\nPlease reload the page.", preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "Close", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        
        mainView?.present(alertController, animated: true, completion: nil)
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        addressBar.text = webView.url?.absoluteString
        checkBookMark()
        timer1.invalidate()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        checkBookMark()
        if webView.canGoBack {
            previousURL = ("\(webView.backForwardList.backItem!.url)")
            print(previousURL)
            transition = "link"
        }
        else {
            previousURL = ""
            transition = "new tab"
        }
        timer1 = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.saveData), userInfo: nil, repeats: true)
        mainView?.tabViews[(mainView?.webViews.index(of: self))!].titleLabel.text = webView.title
        visitDate = Date().iso8601
        localDate = Date().localISO8601
        
    }
    
    func removeObserer() {
        browserWebView.removeObserver(self, forKeyPath: "estimatedProgress")
    }
    
    func saveData() {
        print(Date().iso8601)
        print(Date().localISO8601)
        let realm = try! Realm()
        let myDataToSave = realm.objects(SavedInfo.self).filter("Url = '\(browserWebView.url!)'").first
        if myDataToSave != nil {
            try! realm.write {
            myDataToSave!.LifeTime += 5
                realm.add(myDataToSave!, update: true)
            }
        }
        else {
            try! realm.write {
            let dataToSave = SavedInfo(value: ["\(FIRAuth.auth()!.currentUser!.uid)", "\(browserWebView.url!)", "\(browserWebView.url!.host!)", "\(Date().iso8601)", transition, 5, "\(Date().localISO8601)", previousURL, "\(tabIDValue)"])
            
                realm.add(dataToSave, update: true)
            }
        }
    }
    
    func showPopUp() {
        let realm = try! Realm()
        bookmarks = realm.objects(Bookmark)
        if bookmarks.count > 0 {
        var x = BookMarkList.instanceFromNib()
        x.bookmarks = bookmarks
        x.frame = self.bounds
        x.loadData()
        x.displayView(onView: self)
        }
        else {
            let alertView = SCLAlertView()
            alertView.showInfo("No Bookmarks", subTitle: "You currently don't have any bookmarks.")
        }
    }
    
    @IBAction func callSaveData(_ sender: Any) {
        json()
    }
    
    func json() {
        
        let realm = try! Realm()
        let userSessions = realm.objects(SavedInfo.self)
        let array = userSessions.map { JSON($0.toDictionary()).rawString()! }
        
        let joiner = ","
        var joinedStrings = array.joined(separator: joiner)
        joinedStrings = "{ \"urls\" : [\(joinedStrings)]}"
        print("JOIND", joinedStrings)
        NetworkingClass.saveDataAPI(string: joinedStrings)
    }
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if navigationAction.targetFrame == nil {
            webView.load(navigationAction.request)
        }
        return nil
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        var (str, bool) = linkDetect(searchBar.text!)
        if bool {
            loadWebView(str)
        }
        else {
            str = str.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
            loadWebView("https://www.google.co.in/search?q=\(str)")
        }
    }
    
    func linkDetect (_ text: String) -> (String, Bool) {
        let types: NSTextCheckingResult.CheckingType = .link
        
        let detector = try? NSDataDetector(types: types.rawValue)
        
        let matches = detector?.matches(in: text, options: .reportCompletion, range: NSMakeRange(0, text.characters.count))
        
        if matches!.count > 0{
            return ((matches![0].url?.absoluteString)!, true)
        }
        return (text, false)
        
    }

}
