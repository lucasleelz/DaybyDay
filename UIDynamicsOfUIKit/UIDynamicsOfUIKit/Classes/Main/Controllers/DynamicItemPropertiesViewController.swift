//
//  DynamicItemPropertiesViewController.swift
//  UIDynamicsOfUIKit
//
//  Created by lucas on 15/11/22.
//  Copyright © 2015年 三只小猪. All rights reserved.
//

import UIKit

class DynamicItemPropertiesViewController: UIViewController {

    @IBOutlet weak var dropBox1ImageView: UIImageView!
    
    @IBOutlet weak var dropBox2ImageView: UIImageView!
    
    private var animator: UIDynamicAnimator?

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.animator = UIDynamicAnimator(referenceView: self.view);
        
        let gravityBehavior = UIGravityBehavior(items: [self.dropBox1ImageView, self.dropBox2ImageView])
        let collisionBehavior = UICollisionBehavior(items: [self.dropBox1ImageView, self.dropBox2ImageView])
        collisionBehavior.translatesReferenceBoundsIntoBoundary = true
        
        let dropBox1Properties = UIDynamicItemBehavior(items: [self.dropBox1ImageView])
        let dropBox2Properties = UIDynamicItemBehavior(items: [self.dropBox2ImageView])
        dropBox2Properties.elasticity = 0.5
        dropBox2Properties.friction = 1
        
        self.animator?.addBehavior(gravityBehavior)
        self.animator?.addBehavior(collisionBehavior)
        self.animator?.addBehavior(dropBox1Properties)
        self.animator?.addBehavior(dropBox2Properties)
    }
}
