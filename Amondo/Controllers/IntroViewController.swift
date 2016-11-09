//
//  IntroViewController.swift
//  Amondo
//
//  Created by James Bradley on 30/08/2016.
//  Copyright © 2016 Amondo. All rights reserved.
//

import UIKit

class IntroViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    var pages = [UIViewController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.dataSource = self
      
        
        let p1 = self.storyboard!.instantiateViewControllerWithIdentifier("introPage1")
        let p2 = self.storyboard!.instantiateViewControllerWithIdentifier("introPage2")
        let p3 = self.storyboard!.instantiateViewControllerWithIdentifier("introPage3")
        let p4 = self.storyboard!.instantiateViewControllerWithIdentifier("introPage4")
        pages = [p1, p2, p3, p4]
        self.setViewControllers([p1], direction: .Forward, animated: false, completion: { _ in })
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func viewControllerAtIndex(index: Int) -> UIViewController {
        return pages[index]
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        var currentIndex = pages.indexOf(viewController)!
        currentIndex -= 1
        if currentIndex < 0 {
            return nil
        } else {
            return pages[currentIndex]
        }
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        var currentIndex = pages.indexOf(viewController)!
        currentIndex += 1
        if currentIndex >= pages.count {
            return nil
        } else {
            return pages[currentIndex]
        }
    }
}
