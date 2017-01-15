//
//  ViewController.swift
//  PowrBrowser
//
//  Created by Kunal Verma on 14/01/17.
//  Copyright © 2017 Kunal Verma. All rights reserved.
//

import UIKit
import WebKit
import RealmSwift

class WebViewController: UIViewController, WKNavigationDelegate, WKUIDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var addressBar: UISearchBar!
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var forwardButton: UIBarButtonItem!
    @IBOutlet weak var reloadStopButton: UIBarButtonItem!
    
    var addressField : UITextField?
    var browserWebView : WKWebView!
    var timer1 = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print(Realm.Configuration.defaultConfiguration.fileURL)
        browserWebView = WKWebView()
        baseView.addSubview(browserWebView)
        browserWebView.navigationDelegate = self
        browserWebView.uiDelegate = self
        browserWebView.allowsBackForwardNavigationGestures = true
        let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
        if statusBar.responds(to: #selector(setter: UIView.backgroundColor)){
            statusBar.backgroundColor = UIColor(red: 201/255, green: 201/255, blue: 206/255, alpha: 1)
        }
        addressBar.autocapitalizationType = .none
        addressBar.returnKeyType = .go
        addressBar.delegate = self
        addressBar.setImage(UIImage(named: "go"), for: .search, state: .normal)
        browserWebView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        browserWebView.addObserver(self, forKeyPath: "canGoBack", options: .new, context: nil)
        browserWebView.addObserver(self, forKeyPath: "canGoForward", options: .new, context: nil)
        loadWebView("http://google.com/")
    }
    
    func loadWebView(_ str: String) {
        let url = URL(string: str)!
        let req = URLRequest(url: url)
        browserWebView.load(req)
    }
    
    override func viewDidLayoutSubviews() {
        let frame = CGRect(x: 0, y: 0, width: baseView.bounds.width, height: baseView.bounds.height)
        browserWebView.frame = frame
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
        
        present(alertController, animated: true, completion: nil)
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        let alertController = UIAlertController(title: "OOPS!!", message: error.localizedDescription + "\nPlease reload the page.", preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "Close", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        addressBar.text = webView.url?.absoluteString
        timer1.invalidate()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        timer1 = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.saveData), userInfo: nil, repeats: true)
    }
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if navigationAction.targetFrame == nil {
            webView.load(navigationAction.request)
        }
        return nil
    }
    
    func saveData() {
        let realm = try! Realm()
        let myHostData = realm.objects(UserSessions.self).filter("host = '\(browserWebView.url!.host!)'").first
        if myHostData != nil {
            let urlCurrent = realm.objects(URLsAccessed.self).filter("url = '\(browserWebView.url!)'").first
            try! realm.write {
            if urlCurrent != nil {
                urlCurrent!.totalSeconds += 5.0
                realm.add(urlCurrent!, update: true)
                var myData = realm.objects(UserSessions.self).filter("host = '\(browserWebView.url!.host!)'").first
                myData = UserSessions(value: ["\(myData!.host)", NSDate(), myData!.totalSeconds + 5, myData!.urls])
                realm.add(myData!, update: true)
            }
            else {
                let urlToSave = URLsAccessed(value: ["\(browserWebView.url!.absoluteString)", NSDate(), 5.0])
                let list = myHostData!.urls
                list.append(urlToSave)
                let userSession = UserSessions(value: ["\(browserWebView.url!.host!)", NSDate(), myHostData!.totalSeconds + 5.0, list])
                realm.add(userSession, update: true)
            }
        }
        }
        else {
            let urlToSave = URLsAccessed(value: ["\(browserWebView.url!.absoluteString)", NSDate(), 5.0])
            let list = List<URLsAccessed>()
            list.append(urlToSave)
            let userSession = UserSessions(value: ["\(browserWebView.url!.host!)", NSDate(), 5.0, list])
            try! realm.write {
            realm.add(userSession, update: true)
            }
        }
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

