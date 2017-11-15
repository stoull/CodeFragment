//
//  ViewController.swift
//  VFL
//
//  Created by Stoull Hut on 15/11/2017.
//  Copyright © 2017 CCApril. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var skipButton: UIButton!
    
    @IBOutlet weak var GrapeviLabel: UILabel!
    @IBOutlet weak var WelecomeLabel: UILabel!
    @IBOutlet weak var communicateLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    private let horizontalPadding: CGFloat = 15.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let metrics = ["hp" : horizontalPadding,
                       "iconImageViewWidth" : 30]
        
        let views: [String : AnyObject] = ["skipButton" : skipButton,
                                             "WelecomeLabel" : WelecomeLabel,
                                             "GrapeviLabel" : GrapeviLabel,
                                             "communicateLabel" : communicateLabel,
                                             "iconImageView" : iconImageView,
                                             "mainImageView" : mainImageView,
                                             "pageControl" : pageControl,
                                             "topLayoutGuide" : topLayoutGuide,
                                             "bottomLayoutGuide" : bottomLayoutGuide]
        
        var allConstraints = [NSLayoutConstraint]()
        
        let iconVerticalConstraints = NSLayoutConstraint.constraints(
            withVisualFormat: "V:[topLayoutGuide]-[iconImageView(30)]",
            options: [],
            metrics: nil,
            views: views)
        allConstraints += iconVerticalConstraints
        
        let topRowHorizontalConstraints = NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-hp-[iconImageView(iconImageViewWidth)]-[GrapeviLabel]-[skipButton]-hp-|",
            options: [.alignAllCenterY],
            metrics: metrics,
            views: views)
        allConstraints += topRowHorizontalConstraints
        
        let communicateHorizontalConstrains = NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-hp-[communicateLabel]-hp-|",
            options: [],
            metrics: metrics,
            views: views)
        allConstraints += communicateHorizontalConstrains
        
        let iconToMainImageVerticalConstraints = NSLayoutConstraint.constraints(
            withVisualFormat: "V:[iconImageView]-10-[mainImageView]",
            options: [],
            metrics: nil,
            views: views)
        allConstraints += iconToMainImageVerticalConstraints
        
        let mainImageToWelcomeVerticalConstraints = NSLayoutConstraint.constraints(
            withVisualFormat: "V:[mainImageView]-10-[WelecomeLabel]",
            options: [.alignAllCenterX],
            metrics: nil,
            views: views)
        allConstraints += mainImageToWelcomeVerticalConstraints
        
        let communicateVerticalConstriaints = NSLayoutConstraint.constraints(
            withVisualFormat: "V:[WelecomeLabel]-4-[communicateLabel]",
            options: [.alignAllCenterX, .alignAllTrailing],
            metrics: nil,
            views: views)
        allConstraints += communicateVerticalConstriaints
        
        let communicateToPageVerticalConstraints = NSLayoutConstraint.constraints(
            withVisualFormat: "V:[communicateLabel]-15-[pageControl(9)]-15-|",
            options: [.alignAllCenterX],
            metrics: nil,
            views: views)
        allConstraints += communicateToPageVerticalConstraints
        
        NSLayoutConstraint.activate(allConstraints)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

