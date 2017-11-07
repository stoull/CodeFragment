//
//  CustomSearchBar.swift
//  CustomSearch
//
//  Created by linkapp on 07/11/2017.
//  Copyright © 2017 hut. All rights reserved.
//

import UIKit

class CustomSearchBar: UISearchBar {
    var preferredFont: UIFont?
    var preferredTextColor: UIColor?
    
    init(){
        super.init(frame: CGRect.zero)
    }
    
    func setUp(delegate: UISearchBarDelegate?,
               frame: CGRect?,
               barStyle: UISearchBarStyle,
               placeholder: String,
               font: UIFont?,
               textColor: UIColor?,
               barTintColor: UIColor?,
               tintColor: UIColor?) {
        
        self.delegate = delegate
        self.frame = frame ?? self.frame
        self.searchBarStyle = searchBarStyle
        self.placeholder = placeholder
        self.preferredFont = font
        self.preferredTextColor = textColor
        self.barTintColor = barTintColor ?? self.barTintColor
        self.tintColor = tintColor ?? self.tintColor
        self.bottomLineColor = tintColor ?? UIColor.clear
        
        sizeToFit()
        
        //        translucent = false
        //        showsBookmarkButton = false
        //        showsCancelButton = true
        //        setShowsCancelButton(false, animated: false)
        //        customSearchBar.backgroundImage = UIImage()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    let bottomLine = CAShapeLayer()
    var bottomLineColor = UIColor.clear
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        for view in subviews {
            if let searchField = view as? UITextField { self.setSearchFieldAppearance(searchField: searchField); break }
            else {
                for sView in view.subviews {
                    if let searchField = sView as? UITextField { self.setSearchFieldAppearance(searchField: searchField); break }
                }
            }
        }
        
        bottomLine.path = UIBezierPath(rect: CGRect.init(x: 0.0, y: frame.size.height - 1, width: frame.size.width, height: 1.0)).cgPath
        bottomLine.fillColor = bottomLineColor.cgColor
        layer.addSublayer(bottomLine)
    }
    
    func setSearchFieldAppearance(searchField: UITextField) {
        searchField.frame = CGRect.init(x: 5.0, y: 5.0, width: frame.size.width - 10.0, height: frame.size.height - 10.0)
        searchField.font = preferredFont ?? searchField.font
        searchField.textColor = preferredTextColor ?? searchField.textColor
        //searchField.backgroundColor = UIColor.clearColor()
        //backgroundImage = UIImage()
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
