//
//  AutoPageScrollView.swift
//  pageControl
//
//  Created by Tommy Chheng on 10/2/15.
//  Copyright © 2015 Tommy Chheng. All rights reserved.
//

import UIKit

class RootViewController: UIViewController, AutoPageScrollViewDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let autoPager = AutoPageScrollView(frame: self.view.frame)
        
        autoPager.delegate = self
 
        self.view.addSubview(autoPager)

        autoPager.views = createFourViews(self.view.frame)
    }
    
    func createFourViews(frame:CGRect) -> [UIView] {
        let colors:[UIColor] = [UIColor.redColor(), UIColor.blueColor(), UIColor.greenColor(), UIColor.yellowColor()]
        
        let views = colors.map { (color:UIColor) -> UIView in
            let subView = UIView(frame: frame)
            subView.backgroundColor = color
            return subView
        }
        
        return views
    }
    
    //MARK: - AutoPageScrollViewDelegate
    func onNextPage() {
        NSLog("onNextPage")
    }
    
    func onPreviousPage() {
        NSLog("onPreviousPage")
    }
    
    func onStart() {
        NSLog("onStart")
    }
    
    func onFinished() {
        NSLog("onFinished")
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}