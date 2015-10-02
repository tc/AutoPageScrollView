//
//  AutoPageScrollView.swift
//  pageControl
//
//  Created by Tommy Chheng on 10/2/15.
//  Copyright © 2015 Tommy Chheng. All rights reserved.
//

import UIKit

protocol AutoPageScrollViewDelegate {
    func onNextPage();
    func onPreviousPage();

    func onStart();
    func onFinished();
}

class AutoPageScrollView: UIView, UIScrollViewDelegate {
    var repeatScroll = true
    static let timerInterval = 5.0
    static let scrollViewFrame = CGRectMake(0, 0, 600,  300)
    static let pageControlFrame = CGRectMake(100, 300, 200, 50)
    
    var delegate:AutoPageScrollViewDelegate?
    
    let scrollView = UIScrollView(frame: scrollViewFrame)
    var pageControl: UIPageControl = UIPageControl(frame: pageControlFrame)

    var views:[UIView]? {
        didSet {
            
            for (index, view) in views!.enumerate() {
                var frame = CGRectMake(0, 0, 0, 0)
                frame.origin.x = self.scrollView.frame.size.width * CGFloat(index)
                frame.size = self.scrollView.frame.size

                view.frame = frame
                self.scrollView.addSubview(view)
            }
            
            self.frame.size = self.scrollView.frame.size
            self.scrollView.pagingEnabled = true
            self.addSubview(scrollView)

            self.pageControl.numberOfPages = (self.views?.count)!
            self.addSubview(pageControl)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        scrollView.delegate = self
        
        let scrollViewContentWidth = self.scrollView.frame.size.width * 4
        let scrollViewContentHeight = self.scrollView.frame.size.height
        self.scrollView.contentSize = CGSizeMake(scrollViewContentWidth, scrollViewContentHeight)

        pageControl.addTarget(self, action: Selector("nextPage:"), forControlEvents: UIControlEvents.ValueChanged)

        NSTimer.scheduledTimerWithTimeInterval(AutoPageScrollView.timerInterval, target: self, selector: "updatePage", userInfo: nil, repeats: true)
    }
 
    func nextPage(sender: AnyObject) {
        let x = CGFloat(pageControl.currentPage) * scrollView.frame.size.width
        scrollView.setContentOffset(CGPointMake(x, 0), animated: true)
        
        delegate?.onNextPage()
    }

    func updatePage() {
        let contentOffset = scrollView.contentOffset.x
        
        let nextPage = Int((contentOffset/scrollView.frame.size.width) + 1)
        
        if (nextPage == pageControl.numberOfPages) {
            delegate?.onFinished()
        }
        
        if (nextPage < pageControl.numberOfPages)  {
            let rect = CGRectMake(CGFloat(nextPage) * scrollView.frame.size.width, 0, scrollView.frame.size.width, scrollView.frame.size.height)
            scrollView.scrollRectToVisible(rect, animated: true)
            
            pageControl.currentPage = nextPage
        } else if (repeatScroll) {
            let rect = CGRectMake(0, 0, scrollView.frame.size.width, scrollView.frame.size.height)
            scrollView.scrollRectToVisible(rect, animated:true)
            pageControl.currentPage = 0
        }
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = Int(pageNumber)
    }
}
    