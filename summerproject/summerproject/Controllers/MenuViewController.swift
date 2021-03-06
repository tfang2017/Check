//
//  MenuViewController.swift
//  summerproject
//
//  Created by Tommy Fang on 7/13/15.
//  Copyright (c) 2015 Stanford University. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!

    let leftMenuWidth:CGFloat = 260
    
    override func viewDidAppear(animated: Bool) {
        if NSUserDefaults.standardUserDefaults().objectForKey("Tutorial") == nil {
            performSegueWithIdentifier("ShowTutorial", sender: self)
            NSUserDefaults.standardUserDefaults().setObject("Set", forKey: "Tutorial")
        }
    
        dispatch_async(dispatch_get_main_queue()) {
            self.closeMenu()
        }
    }
    
    override func viewDidLoad() {
        dispatch_async(dispatch_get_main_queue()) {
            self.closeMenu()
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "toggleMenu", name: "toggleMenu", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "closeMenu", name: "closeMenu", object: nil)
        
        // START OF BACKEND TEST.
//        var newUser = Profile(username: "awesome2", password: "lala", email: "awesome2@umich.edu", id: "100", profilePicture: "hello", name: "ZhengHao", biography: "I have an awesome biography", phoneNumber: "2065120445", checkPoints: 200, isCheckVerified: true, reviews: nil, settings: nil)
//        
//        newUser.login(newUser)
//        
//        if (newUser.isLoggedIn(newUser)) {
//            print("I am logged in!")
//        }
//        else {
//            print("Not logged in, trying to sign up...")
//            newUser.signup(newUser)
//        }
//
//        //assert(newUser.isLoggedIn(newUser), "User must be logged in1")
//        
//        newUser.logout(newUser)
        
        //assert(!newUser.isLoggedIn(newUser), "User must be logged in")
        
        // END OF BACKEND TEST.
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func toggleMenu(){
        scrollView.contentOffset.x == 0  ? closeMenu() : openMenu()
    }
    
    func closeMenu(){
        scrollView.setContentOffset(CGPoint(x: leftMenuWidth, y: 0), animated: true)
    }
    
    func openMenu(){
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }

}
