//
//  MainViewController.swift
//  PowrBrowser
//
//  Created by Kunal Verma on 21/01/17.
//  Copyright © 2017 Kunal Verma. All rights reserved.
//

import UIKit
import FontAwesome_swift
import SWRevealViewController

class MainViewController: UIViewController, ButtonDelegate {

    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var addTabBtn: UIButton!
    @IBOutlet weak var tabScroller: UIScrollView!
    
    var webViews : [WebView] = []
    var tabViews : [TabView] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
        if statusBar.responds(to: #selector(setter: UIView.backgroundColor)){
            statusBar.backgroundColor = UIColor(red: 201/255, green: 201/255, blue: 206/255, alpha: 1)
        }
        let s1 = (NSMutableAttributedString(string: String.fontAwesomeIcon(code: "fa-reorder")!, attributes: [NSFontAttributeName: UIFont.fontAwesome(ofSize: 30), NSForegroundColorAttributeName: UIColor(red: 188/255, green: 24/255, blue: 0, alpha: 1)]))
        menuBtn.setAttributedTitle(s1, for: .normal)
        let s2 = (NSMutableAttributedString(string: String.fontAwesomeIcon(code: "fa-plus-circle")!, attributes: [NSFontAttributeName: UIFont.fontAwesome(ofSize: 30), NSForegroundColorAttributeName: UIColor(red: 188/255, green: 24/255, blue: 0, alpha: 1)]))
        addTabBtn.setAttributedTitle(s2, for: .normal)
        addTab()
        
    }
    
    @IBAction func addTabPressed(_ sender: Any) {
        addTab()
    }
    
    
    func addTab() {
        let browserView = WebView.instanceFromNib()
        browserView.mainView = self
        webViews.append(browserView)
        baseView.addSubview(browserView)
        
        let tabView = TabView.instanceFromNib()
        tabView.mainView = self
        tabView.tag = tabViews.count
        tabView.frame = CGRect(x: 180 * CGFloat(tabViews.count), y: 0, width: 180, height: tabScroller.frame.height)
        tabViews.append(tabView)
        self.tabScroller.contentSize = CGSize(width:180 * CGFloat(tabViews.count), height:self.tabScroller.frame.height)
        tabView.delegate = self
        tabScroller.addSubview(tabView)
        onButtonTap(sender: tabViews.last!.selectBtn)
        checkTab()
        //scrollToTab(index: tabViews.count)
        
    }
    
    func checkTab() {
        if tabViews.count == 1 {
            tabViews[0].closeBtn.isHidden = true
        }
        else {
            tabViews[0].closeBtn.isHidden = false
        }
    }
    
    func scrollToTab(index: Int) {
        //tabScroller.setContentOffset(CGPoint(x: 180 * CGFloat(index), y: 0), animated: true)
        tabScroller.scrollRectToVisible(CGRect(x: 180 * CGFloat(index), y: 0, width: 1, height: 1), animated: true)
        
        for v in webViews {
            v.isHidden = true
        }
        webViews[index - 1].isHidden = false
        
    }
    
    override func viewDidLayoutSubviews() {
        let frame = CGRect(x: 0, y: 0, width: baseView.bounds.width, height: baseView.bounds.height)
        for v in webViews {
            v.frame = frame
            let frame = CGRect(x: 0, y: 0, width: v.baseView.bounds.width, height: v.baseView.bounds.height)
            v.browserWebView.frame = frame
        }
    }
    
    func onButtonTap(sender: UIButton) {
        let ind = tabViews.index(of: sender.superview?.superview as! TabView)
        for i in 0 ..< webViews.count {
            webViews[i].isHidden = true
            tabViews[i].baseView.backgroundColor = UIColor.white
        }
        webViews[ind!].isHidden = false
        tabScroller.setContentOffset(CGPoint(x: 180 * tabViews.index(of: sender.superview?.superview as! TabView)!, y: 0), animated: true)
        tabViews[ind!].baseView.backgroundColor = UIColor(red: 105/255, green: 147/255, blue: 1, alpha: 1)
    }
    
    func onCloseTap(sender: UIButton) {
        let ind = tabViews.index(of: sender.superview?.superview as! TabView)
        webViews[ind!].removeObserer()
        if ind == tabViews.count - 1 {
            tabViews[ind!].removeFromSuperview()
            webViews[ind!].removeFromSuperview()
            tabViews.remove(at: ind!)
            webViews.remove(at: ind!)
        }
        else {
            tabViews[ind!].removeFromSuperview()
            webViews[ind!].removeFromSuperview()
            tabViews.remove(at: ind!)
            webViews.remove(at: ind!)
            //scrollToTab(index: ind! + 1)
        }
        checkTab()
        for i in 0 ..< tabViews.count {
            //tabViews[i]
            tabViews[i].frame = CGRect(x: 180 * CGFloat(i), y: 0, width: 180, height: tabScroller.frame.height)
            print(tabViews[i].frame)
            
        }
        self.tabScroller.contentSize = CGSize(width:180 * CGFloat(tabViews.count), height:self.tabScroller.frame.height)
        if ind == 0 {
            onButtonTap(sender: tabViews[0].selectBtn)
        }
        else {
            onButtonTap(sender: tabViews[ind! - 1].selectBtn)
        }
    }
    
    
    @IBAction func menuBtnPressed(_ sender: Any) {
        print("helloooo")
        //SideMenuClass().show(self, sender: menuBtn)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        SideMenuShow(vc: self, menuButton: menuBtn)
    }
    
    func buttonClicked(_ sender: UIButton!) {
        print("Button Clicked")
    }
    
}
