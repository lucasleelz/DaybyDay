//
//  PushViewController.swift
//  UIDynamicsOfUIKit
//
//  Created by lucas on 15/11/22.
//  Copyright © 2015年 三只小猪. All rights reserved.
//

import UIKit

/// 推送

class PushViewController: UIViewController {

    private lazy var dropBoxImageView: UIImageView = {
        var result = UIImageView(frame: CGRectMake(100, 100, 100, 100))
        result.image = UIImage(named: "Box1")?.imageWithRenderingMode(.AlwaysTemplate)
        result.tintColor = UIColor.darkGrayColor()
        result.userInteractionEnabled = true
        return result
    }()
    
    private lazy var originImageView: UIImageView = {
        var result = UIImageView(frame: CGRectMake(150, 300, 10, 10))
        result.image = UIImage(named: "Origin")
        return result
    }()
    
    private var animator: UIDynamicAnimator?
    
    private var pushBehavior: UIPushBehavior?
    
    // MAKR: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.dropBoxImageView)
        self.view.addSubview(self.originImageView)
        self.animator = UIDynamicAnimator(referenceView: self.view);
        
        let collisionBehavior = UICollisionBehavior(items: [self.dropBoxImageView])
//        collisionBehavior.translatesReferenceBoundsIntoBoundary = true
        // 如果不适用该方法
        collisionBehavior.setTranslatesReferenceBoundsIntoBoundaryWithInsets(UIEdgeInsets(top: self.topLayoutGuide.length, left: 0, bottom: self.bottomLayoutGuide.length, right: 0))
        self.animator?.addBehavior(collisionBehavior)
        
        self.pushBehavior = UIPushBehavior(items: [self.dropBoxImageView], mode: .Instantaneous)
        self.animator?.addBehavior(self.pushBehavior!)
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "handlePushGesture:"))
    }
    
    func handlePushGesture(tapGestureRecognizer: UITapGestureRecognizer) {
        let p = tapGestureRecognizer.locationInView(self.view)
        let o = self.originImageView.center
        self.pushBehavior?.angle = atan2(p.y - o.y, p.x - o.x)
        
        // 用Float转换 因为p、o 的x、y是CGFloat 而参数是需要Float。 勾股定理。
        let distance = sqrtf(powf(Float(p.x - o.x), 2.0) + powf(Float(p.y - o.y), 2.0))
        self.pushBehavior?.magnitude = CGFloat(distance / Float(100.0))
        // 使用active 属性激活该行为，而不是删除后再重新添加行为。 如果不设置为true 是不会有动画效果。
        self.pushBehavior?.active = true
    }
}
