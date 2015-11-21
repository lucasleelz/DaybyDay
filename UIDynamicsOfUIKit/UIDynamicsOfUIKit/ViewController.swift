//
//  ViewController.swift
//  UIDynamicsOfUIKit
//
//  Created by lucas on 15/11/21.
//  Copyright © 2015年 三只小猪. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private lazy var dropBoxImageView: UIImageView = {
        var result = UIImageView(frame: CGRectMake(100, 50, 100, 100))
        result.image = UIImage(named: "Box1")
        return result
    }()
    
    private var animator: UIDynamicAnimator?

    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.dropBoxImageView)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        animator = UIDynamicAnimator(referenceView: self.view)
        
        let gravietyBehavior = UIGravityBehavior(items: [self.dropBoxImageView])
        animator!.addBehavior(gravietyBehavior)
    }
}

