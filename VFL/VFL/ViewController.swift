//
//  ViewController.swift
//  VFL
//
//  Created by Stoull Hut on 15/11/2017.
//  Copyright © 2017 CCApril. All rights reserved.
//


/*
 Here’s a step-by-step explanation of the VFL format string:
 1    Direction of your constraints, not required. Can have the following values:
 •    H: indicates horizontal orientation.
 •    V: indicates vertical orientation.
 •    Not specified: Auto Layout defaults to horizontal orientation.
 2    Leading connection to the superview, not required.
 •    Spacing between the top edge of your view and its superview’s top edge (vertical)
 •    Spacing between the leading edge of your view and its superview’s leading edge (horizontal)
 3    View you’re laying out, is required.
 4    Connection to another view, not required.
 5    Trailing connection to the superview, not required.
 •    Spacing between the bottom edge of your view and its superview’s bottom edge (vertical)
 •    Spacing between the trailing edge of your view and its superview’s trailing edge (horizontal)
 There are two special (orange) characters in the image and their definition is below:
 •    ? component is not required inside the layout string.
 •    * component may appear 0 or more times inside the layout string.
 
 Available Symbols
 VFL uses a number of symbols to describe your layout:
 •    | superview
 •    - standard spacing (usually 8 points; value can be changed if it is the spacing to the edge of a superview)
 •    == equal widths (can be omitted)
 •    -20- non standard spacing (20 points)
 •    <= less than or equal to
 •    >= greater than or equal to
 •    @250 priority of the constraint; can have any value between 0 and 1000
 •    250 - low priority
 •    750 - high priority
 •    1000 - required priority
 •
 Example Format String
 H:|-[icon(==iconDate)]-20-[iconLabel(120@250)]-20@750-[iconDate(>=50)]-|
 Here's a step-by-step explanation of this string:
 •    H: horizontal direction.
 •    |-[icon icon's leading edge should have standard distance from its superview's leading edge.
 •    ==iconDate icon's width should be equal to iconDate's width.
 •    ]-20-[iconLabel icon's trailing edge should be 20 points from iconLabel's leading edge.
 •    [iconLabel(120@250)] iconLabel should have a width of 120 points. The priority is set to low, and Auto Layout can break this constraint if a conflict arises.
 •    -20@750- iconLabel's trailing edge should be 20 points from iconDate's leading edge. The priority is set to high, so Auto Layout shouldn't break this constraint if there's a conflict.
 •    [iconDate(>=50)] iconDate's width should be greater than or equal to 50 points.
 •    -| iconDate's trailing edge should have standard distance from its superview's trailing edge.

 
 */

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

