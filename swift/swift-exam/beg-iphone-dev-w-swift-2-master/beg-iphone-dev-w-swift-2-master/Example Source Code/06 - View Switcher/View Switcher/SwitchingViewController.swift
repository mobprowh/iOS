//
//  SwitchingViewController.swift
//  View Switcher
//
//  Created by Kim Topley on 9/5/15.
//  Copyright © 2015 Apress Inc. All rights reserved.
//

import UIKit

class SwitchingViewController: UIViewController {
    private var blueViewController: BlueViewController!
    private var yellowViewController: YellowViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        blueViewController =
            storyboard?.instantiateViewControllerWithIdentifier("Blue")
                   as! BlueViewController
        blueViewController.view.frame = view.frame
        switchViewController(from: nil, to: blueViewController)
   }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        if blueViewController != nil
                && blueViewController!.view.superview == nil {
            blueViewController = nil
        }
        if yellowViewController != nil
                && yellowViewController!.view.superview == nil {
            yellowViewController = nil
        }
   }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func switchViews(sender: UIBarButtonItem) {
        // Create the new view controller, if required
        if yellowViewController?.view.superview == nil {
            if yellowViewController == nil {
                yellowViewController =
                    storyboard?.instantiateViewControllerWithIdentifier("Yellow")
                        as! YellowViewController
            }
        } else if blueViewController?.view.superview == nil {
            if blueViewController == nil {
                blueViewController =
                    storyboard?.instantiateViewControllerWithIdentifier("Blue")
                         as! BlueViewController
            }
        }

        UIView.beginAnimations("View Flip", context: nil)
        UIView.setAnimationDuration(0.4)
        UIView.setAnimationCurve(.EaseInOut)
        // Switch view controllers
        if blueViewController != nil
                && blueViewController!.view.superview != nil {
            UIView.setAnimationTransition(.FlipFromRight,
                             forView: view, cache: true)
            yellowViewController.view.frame = view.frame
            switchViewController(from: blueViewController,
                                 to: yellowViewController)
        } else {
            UIView.setAnimationTransition(.FlipFromLeft,
                            forView: view, cache: true)
            blueViewController.view.frame = view.frame
            switchViewController(from: yellowViewController,
                                to: blueViewController)
        }
        UIView.commitAnimations()
    }
    
    private func switchViewController(from fromVC:UIViewController?,
                                      to toVC:UIViewController?) {
        if fromVC != nil {
            fromVC!.willMoveToParentViewController(nil)
            fromVC!.view.removeFromSuperview()
            fromVC!.removeFromParentViewController()
        }
                                    
        if toVC != nil {
            self.addChildViewController(toVC!)
            self.view.insertSubview(toVC!.view, atIndex: 0)
            toVC!.didMoveToParentViewController(self)
        }
    }
}
