//
//  BA_TutorialViewController.swift
//  bahisadam
//
//  Created by ilker özcan on 26/10/2016.
//  Copyright © 2016 ilkerozcan. All rights reserved.
//

import UIKit

class BA_TutorialViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {

	@IBOutlet weak var pageViewControllerView: UIView!
	@IBOutlet weak var pageControl: UIPageControl!
	
	var currentStoryboard: UIStoryboard!
	var navigationView: UIView!
	private var pageController: UIPageViewController!
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		
		let optionsDict = [UIPageViewControllerOptionInterPageSpacingKey : 00]
		self.pageController = UIPageViewController(transitionStyle: UIPageViewControllerTransitionStyle.scroll, navigationOrientation: UIPageViewControllerNavigationOrientation.horizontal, options: optionsDict)

		let pageControllerFrame = CGRect(x: 0, y: 0, width: self.pageViewControllerView.frame.size.width, height: self.pageViewControllerView.frame.size.height)
		self.pageController.view.frame = pageControllerFrame
		
		var pageControllers = [BA_TutorialChildViewController]()
		pageControllers.append(self.viewControllerAtIndex(index: 0))
		self.pageController.setViewControllers(pageControllers, direction: UIPageViewControllerNavigationDirection.forward, animated: false, completion: nil)
		
		self.view.addSubview(self.pageControl)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(true)
		
		let pageControllerFrame = CGRect(x: 0, y: 0, width: pageViewControllerView.frame.size.width, height: pageViewControllerView.frame.size.height)
		self.pageController.view.frame = pageControllerFrame
		
		self.pageController.dataSource = self
		self.pageController.delegate = self
		
		self.addChildViewController(self.pageController)
		self.pageViewControllerView.addSubview(self.pageController.view)
		self.pageController.didMove(toParentViewController: self)
	}
	
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(true)
		
		self.pageController.delegate = nil
		self.pageController.view.removeFromSuperview()
		self.pageController.removeFromParentViewController()
	}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

	func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
		
		var index = (viewController as! BA_TutorialChildViewController).pageIndex
		
		if index == 0 {
			return nil
		}
		
		index = index! - 1
		
		return self.viewControllerAtIndex(index: index!) as UIViewController
	}
	
	func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
		
		var index = (viewController as! BA_TutorialChildViewController).pageIndex
		
		index = index! + 1
		
		if index == 6 {
			return nil
		}
		
		return self.viewControllerAtIndex(index: index!) as UIViewController
	}
	
	private func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
		return 6
	}
	
	private func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
		return 0
	}
	
	func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
		
		if(pendingViewControllers.count > 0) {
			
			let prevView = (pendingViewControllers[0] as! BA_TutorialChildViewController)
			self.pageControl.currentPage = prevView.pageIndex
			
			if(prevView.pageIndex == 5) {
				self.tutorialWillEnd()
			}
		}else{
			self.pageControl.currentPage = 0
		}
	}
	
	private func viewControllerAtIndex(index: Int) -> BA_TutorialChildViewController {
		
		var pageNameIdx = index + 1
		if(pageNameIdx == 6) {
			pageNameIdx = 1
		}
		let retval = self.currentStoryboard.instantiateViewController(withIdentifier: "BA_tutorialPage\(pageNameIdx)") as! BA_TutorialChildViewController
		retval.pageIndex = index
		
		return retval
	}
	
	private func tutorialWillEnd() {
		
		self.BA_dismissTutorialViewController(navigationView: self.navigationView)
	}
}
