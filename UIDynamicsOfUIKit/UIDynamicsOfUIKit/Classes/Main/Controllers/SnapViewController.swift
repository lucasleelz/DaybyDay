//
//  SnapViewController.swift
//  UIDynamicsOfUIKit
//
//  Created by lucas on 15/11/22.
//  Copyright © 2015年 三只小猪. All rights reserved.
//

import UIKit

/// 捕捉行为。

class SnapViewController: UIViewController {

    private lazy var dropBoxImageView: UIImageView = {
        var result = UIImageView(frame: CGRectMake(100, 100, 100, 100))
        result.image = UIImage(named: "Box1")?.imageWithRenderingMode(.AlwaysTemplate)
        result.tintColor = UIColor.darkGrayColor()
        result.userInteractionEnabled = true
        return result
    }()

    private var animator: UIDynamicAnimator?
    
    private var snapBehavior: UISnapBehavior?
    
    // MAKR: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.dropBoxImageView)
        self.animator = UIDynamicAnimator(referenceView: self.view);
    }
    
    @IBAction func handleSnapGestureRecognizer(gesture: UITapGestureRecognizer) {
        let snapToPoint = gesture.locationInView(self.view)
        if #available(iOS 9.0, *) {
            if snapBehavior == nil {
                createAddAddSnapBehavior(snapToPoint)
            }
            self.snapBehavior!.snapPoint = snapToPoint
        } else {
            if self.snapBehavior != nil {
                self.animator?.removeBehavior(self.snapBehavior!)
            }
            createAddAddSnapBehavior(snapToPoint)
        }
    }
    
    private func createAddAddSnapBehavior(snapToPoint: CGPoint) {
        self.snapBehavior = UISnapBehavior(item: self.dropBoxImageView, snapToPoint: snapToPoint)
        self.animator?.addBehavior(self.snapBehavior!)
    }
}
