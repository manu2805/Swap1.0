//
//  UIPageViewControllerWithoutOverlay.swift
//  Layer-Parse-iOS-Swift-Example
//
//  Created by Manudeep N.s on 8/16/15.
//  Copyright (c) 2015 layer. All rights reserved.
//

import UIKit

class UIPageViewControllerWithoutOverlay: UIPageViewController {

    override func viewDidLayoutSubviews() {
        for subView in self.view.subviews as! [UIView] {
            if subView is UIScrollView {
                subView.frame = self.view.bounds
            } else if subView is UIPageControl {
                self.view.bringSubviewToFront(subView)
            }
        }
        super.viewDidLayoutSubviews()
    }

}
