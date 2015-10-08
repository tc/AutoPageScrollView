//
//  AutoPageScrollView.swift
//  pageControl
//
//  Created by Tommy Chheng on 10/2/15.
//  Copyright © 2015 Tommy Chheng. All rights reserved.
//

import UIKit

class RootViewController: UIViewController, AutoPageScrollViewDelegate {
    @IBOutlet weak var mainView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let autoPager = AutoPageScrollView(frame: self.mainView.frame)
        
        autoPager.delegate = self
        self.mainView.addSubview(autoPager)

        autoPager.views = createPageViews(self.mainView.frame, titles: ["Hello", "World", "Today"])
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
    
    //MARK: - UI
    func createPageViews(frame:CGRect, titles:[String]) -> [UIView] {
        let colors:[UIColor] = [UIColor.redColor(), UIColor.blueColor(), UIColor.greenColor(), UIColor.yellowColor()]

        var views:[UIView] = []
        
        for (index, title) in titles.enumerate() {
            let v = NSBundle.mainBundle().loadNibNamed("PageView", owner: self, options: nil)[0] as! PageView
            v.frame = frame
            v.index = index
            v.title = title
            v.backgroundColor = colors[index % colors.count]

            views.append(v)
        }
        
        return views
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}