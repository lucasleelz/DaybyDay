//
//  ViewController.swift
//  UIDynamicsOfUIKit
//
//  Created by lucas on 15/11/21.
//  Copyright © 2015年 三只小猪. All rights reserved.
//

import UIKit

/// action: Selector 如果所使用的方法是私有方法会调用失败。

class DropBoxViewController: UIViewController, UICollisionBehaviorDelegate {

    private lazy var dropBoxImageView: UIImageView = {
        var result = UIImageView(frame: CGRectMake(100, 100, 100, 100))
        result.image = UIImage(named: "Box1")?.imageWithRenderingMode(.AlwaysTemplate)
        result.tintColor = UIColor.darkGrayColor()
        result.userInteractionEnabled = true
        return result
    }()
    
    private var animator: UIDynamicAnimator?
    
    private var attachmentBehavior: UIAttachmentBehavior?

    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.dropBoxImageView)
        
        let panGestureReceognizer = UIPanGestureRecognizer(target: self, action: "handleDropPan:")
        self.view.addGestureRecognizer(panGestureReceognizer)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        animator = UIDynamicAnimator(referenceView: self.view)
        
        let gravietyBehavior = UIGravityBehavior(items: [self.dropBoxImageView])
        animator!.addBehavior(gravietyBehavior)
        
        let collisionBehavior = UICollisionBehavior(items: [self.dropBoxImageView])
        collisionBehavior.translatesReferenceBoundsIntoBoundary = true
        collisionBehavior.collisionDelegate = self
        animator!.addBehavior(collisionBehavior)
    }
    
    // MARK: UICollisionBehaviorDelegate
    
    func collisionBehavior(behavior: UICollisionBehavior, beganContactForItem item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?, atPoint p: CGPoint) {
        if let dropBoxView = item as? UIView {
            dropBoxView.tintColor = UIColor.lightGrayColor()
        }
    }
    
    func collisionBehavior(behavior: UICollisionBehavior, endedContactForItem item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?) {
        if let dropBoxView = item as? UIView {
            dropBoxView.tintColor = UIColor.darkGrayColor()
        }
    }
    
    // MARK: UIGestureRecognizer
    
    func handleDropPan(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .Began:
            if (self.attachmentBehavior == nil) {
                let attachmentAnchor = self.dropBoxImageView.center
                self.attachmentBehavior = UIAttachmentBehavior(item: self.dropBoxImageView, attachedToAnchor: attachmentAnchor)
                self.attachmentBehavior?.frequency = 1.0 // 振荡频率
                self.attachmentBehavior?.damping = 0.1   // 临界阻尼
                animator!.addBehavior(self.attachmentBehavior!)
            }
        default:
            break
        }
        self.attachmentBehavior?.anchorPoint = gesture.locationInView(self.view)
        self.dropBoxImageView.center = CGPointMake(self.attachmentBehavior!.anchorPoint.x, self.attachmentBehavior!.anchorPoint.y + 100)
    }
}

