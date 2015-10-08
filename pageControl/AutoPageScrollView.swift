//
//  AutoPageScrollView.swift
//  pageControl
//
//  Created by Tommy Chheng on 10/2/15.
//  Copyright Â© 2015 Tommy Chheng. All rights reserved.
//

import UIKit

protocol AutoPageScrollViewDelegate {
    func onNextPage();
    func onPreviousPage();
    
    func onStart();
    func onFinished();
}

class AutoPageScrollView: UIView, UIScrollViewDelegate {
    let pageControlFrameWidth = CGFloat(200.0)
    let pageControlFrameHeight = CGFloat(50.0)
    
    var repeatScroll = true
    var delegate:AutoPageScrollViewDelegate?
    var timer:NSTimer?
    
    var scrollView:UIScrollView?
    var pageControl:UIPageControl?
    
    var views:[UIView]? {
        didSet {
            if let s = scrollView {
                s.autoresizingMask = [UIViewAutoresizing.FlexibleHeight, UIViewAutoresizing.FlexibleWidth]
                
                for (index, view) in views!.enumerate() {
                    var frame = CGRectMake(0, 0, 0, 0)
                    frame.origin.x = s.frame.size.width * CGFloat(index)
                    frame.size = s.frame.size
                    
                    view.frame = frame

                    s.addSubview(view)
                }
                
                self.frame.size = s.frame.size
                s.pagingEnabled = true
                self.addSubview(s)
                
                self.pageControl?.numberOfPages = (self.views?.count)!
                self.addSubview(pageControl!)
                
                resetFrameSizes(self.frame)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        scrollView?.delegate = self
        
        resetFrameSizes(frame)
        
        self.timer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: "nextPage:", userInfo: nil, repeats: true)
        pageControl?.addTarget(self, action: Selector("nextPage:"), forControlEvents: UIControlEvents.ValueChanged)
    }
    
    func resetFrameSizes(frame: CGRect) {
        let scrollViewFrame = CGRectMake(0, 0, frame.width, frame.height)
        let pageControlFrame = CGRectMake(
            (frame.width - pageControlFrameWidth - 10) / 2,
            frame.height - pageControlFrameHeight,
            pageControlFrameWidth,
            pageControlFrameHeight
        )
        
        if (self.scrollView == nil) {
            self.scrollView = UIScrollView(frame: scrollViewFrame)
        } else {
            self.scrollView?.frame = scrollViewFrame
        }
        
        if (self.pageControl == nil) {
            self.pageControl = UIPageControl(frame: pageControlFrame)
        } else {
            self.pageControl?.frame = pageControlFrame
        }
        
        if let s = scrollView {
            let viewCount = CGFloat(self.views?.count ?? 1)
            let scrollViewContentWidth = s.frame.size.width * viewCount
            let scrollViewContentHeight = s.frame.size.height
            s.contentSize = CGSizeMake(scrollViewContentWidth, scrollViewContentHeight)
        }
    }
    
    func goToPage(index:Int) {
        let height = scrollView?.frame.size.height ?? 0
        let width = scrollView?.frame.size.width ?? 0
        
        if (index == pageControl?.numberOfPages) {
            delegate?.onFinished()
            return
        }
        
        if ( index < pageControl?.numberOfPages)  {
            let x = CGFloat(index) * width
            
            let rect = CGRectMake(x, 0, width, height)
            scrollView?.scrollRectToVisible(rect, animated: true)
            pageControl?.currentPage = index
            
        } else if (repeatScroll) {
            let rect = CGRectMake(0, 0, width, height)
            scrollView?.scrollRectToVisible(rect, animated:true)
            pageControl?.currentPage = 0
        }
    }
    
    func previousPage(sender: AnyObject) {
        let contentOffset = scrollView?.contentOffset.x ?? 0
        let width = scrollView?.frame.size.width ?? 0
        
        let currentPage = Int(contentOffset / width)
        let previousPage = currentPage - 1
        
        goToPage(previousPage)
        
        delegate?.onPreviousPage()
    }
    
    func nextPage(sender: AnyObject) {
        let contentOffset = scrollView?.contentOffset.x ?? 0
        let width = scrollView?.frame.size.width ?? 0
        
        let currentPage = Int(contentOffset / width)
        let nextPage = currentPage + 1
        
        if (nextPage > views!.count) {
            goToPage(0)
        } else {
            goToPage(nextPage)
        }
        
        delegate?.onNextPage()
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl?.currentPage = Int(pageNumber)
    }
}
    