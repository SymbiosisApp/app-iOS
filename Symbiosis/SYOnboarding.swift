//
//  SYOnboarding.swift
//  symbiosis-ios-app
//
//  Created by Quentin Tshaimanga on 19/05/2016.
//  Copyright © 2016 Etienne De Ladonchamps. All rights reserved.
//

import UIKit


class SYOnboarding : UIPageViewController {
    
    var initOnboardingData : [String : AnyObject]!
    var onboardingDelegate: protocolPageViewControllerDelegate?
    
    init(data onboardingData: [String : AnyObject]) {
        self.initOnboardingData = onboardingData
        super.init(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: onboardingData)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private(set) lazy var onboardingViewController : [UIViewController] = {
        var result :[UIViewController] = []
        
        for (key, value) in self.initOnboardingData {
            result += [UIStoryboard(name:"Onboarding",bundle : nil).instantiateViewControllerWithIdentifier(String(value))]
        }
        
        return result
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for (key, value) in initOnboardingData {
            print("\(key): \(value)")
        }
        
        dataSource = self
        delegate = self
        
        scrollToViewController(onboardingViewController.first!)
        onboardingDelegate?.PageViewController(self, didUpdatePageCount: onboardingViewController.count)
        
        //set pagecontroler style
        
    }
    
    
    func scrollToNextViewController() {
        if let visibleViewController = viewControllers?.first,
            let nextViewController = pageViewController(self,
                                                        viewControllerAfterViewController: visibleViewController) {
            scrollToViewController(nextViewController)
        }
    }
    
    
    private func scrollToViewController(viewController: UIViewController){
        setViewControllers([viewController],
                           direction: .Forward,
                           animated: true,
                           completion: { (finished)-> Void in
                            self.updateIndexOnboardingDelegate()
        })
    }
    
    
    func updateIndexOnboardingDelegate() {
        if let firstViewController = viewControllers?.first,
            let index = onboardingViewController.indexOf(firstViewController){
            onboardingDelegate?.PageViewController(self, didUpdatePageIndex: index)
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}


extension SYOnboarding : UIPageViewControllerDataSource {
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = onboardingViewController.indexOf(viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
        
        guard onboardingViewController.count > previousIndex else {
            return nil
        }
        
        return onboardingViewController[previousIndex]
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = onboardingViewController.indexOf(viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let numberOfViewControllers = onboardingViewController.count
        
        guard numberOfViewControllers != nextIndex else{
            return nil
        }
        
        guard numberOfViewControllers > nextIndex else{
            return nil
        }
        
        return onboardingViewController[nextIndex]
        
    }
    
    
    func assignbackground(background:NSString){
        let background = UIImage(named: background as String)
        var imageView : UIImageView!
        imageView = UIImageView(frame: view.bounds)
        imageView.contentMode =  UIViewContentMode.ScaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = background
        imageView.center = view.center
        view.addSubview(imageView)
        self.view.sendSubviewToBack(imageView)
    }
}


extension SYOnboarding: UIPageViewControllerDelegate {
    
    func pageViewController (pageViewController: UIPageViewController,
                             didFinishAnimating finished: Bool,
                                                previousViewControllers: [UIViewController],
                                                transitionCompleted completed: Bool){
        updateIndexOnboardingDelegate()
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        
        return initOnboardingData.count
        
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
}


protocol protocolPageViewControllerDelegate {
    
    func PageViewController (pageViewController : SYOnboarding, didUpdatePageCount count: Int)
    
    func PageViewController (pageViewController : SYOnboarding, didUpdatePageIndex index: Int)
    
}













