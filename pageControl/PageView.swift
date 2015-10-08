//
//  PageView.swift
//  pageControl
//
//  Created by Tommy Chheng on 10/8/15.
//  Copyright © 2015 Tommy Chheng. All rights reserved.
//

import UIKit

class PageView: UIView {
    @IBOutlet weak var titleLabel: UILabel!

    var title:String? {
        didSet {
            titleLabel.text = title
        }
    }
    var index:Int?
}
