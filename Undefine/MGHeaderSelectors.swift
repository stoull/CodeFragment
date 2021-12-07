//
//  MGHeaderSelectors.swift
//  MyGro
//
//  Created by Hut on 2021/12/7.
//  Copyright © 2021 Growatt New Energy Technology CO.,LTD. All rights reserved.
//

import UIKit

protocol MGHeaderSelectorsDelegate: AnyObject {
    func didSelectIndex(gunSelector: MGHeaderSelectors, selectedIndex: Int)
}

class MGHeaderSelectors: UIView {

    var titleButtons: [UIButton] = []
    var selectedIndicator: UIView = UIView()
    
    private var titles: [String] = []
    private var totalCount: Int = 1
    private var selectedIndexStorage: Int = 0
    
    var delegate: MGHeaderSelectorsDelegate?
    
    var selectedIndex: Int {
        get { selectedIndexStorage }
        set {
            updateSelectedUI(newIndex: newValue, oldIndex: selectedIndexStorage)
            selectedIndexStorage = newValue
        }
    }
    
    convenience init(frame: CGRect, titles: [String], delegate: MGHeaderSelectorsDelegate){
        self.init(frame: frame)
        self.titles = titles
        self.delegate = delegate
        initViews(titles: titles, size: frame.size)
    }
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func initViews(titles: [String], size: CGSize) {
        totalCount = titles.count
        guard totalCount > 0 else {
            return
        }
        let itemWidth = size.width/CGFloat(totalCount)
        let itemSize: CGSize = CGSize(width: itemWidth, height: 30.0)
        
        let bottomLine = UIView(frame: CGRect(x: 14.0, y: size.height-2, width: size.width-2*14.0, height: 1))
        bottomLine.backgroundColor = kThemeViewBackgroundColor_top
        
        
        let indicatorSize = CGSize(width: 50.0, height: 2.0)
        let firstX = itemWidth+(itemWidth-indicatorSize.width)*0.5
        let indicatorY = bottomLine.frame.origin.y - 2.0
        selectedIndicator.frame = CGRect(origin: CGPoint(x: firstX, y: indicatorY), size: CGSize(width: 50.0, height: 2.0))
        selectedIndicator.backgroundColor = kThemeColor
        
        var originX: CGFloat = 0.0
        let originY: CGFloat = indicatorY - 12.0 - itemSize.height
        for index in 0..<totalCount {
            let btn = UIButton(frame: CGRect(origin: CGPoint(x: originX, y: originY), size: itemSize))
            btn.setTitle(titles[index], for: .normal)
            btn.setTitleColor(kThemeTextColor_top, for: .normal)
            btn.addTarget(self, action: #selector(titleButtonDidClick(sender:)), for: .touchUpInside)
            btn.tag = index
            titleButtons.append(btn)
            self.addSubview(btn)
            originX += itemWidth
        }
        
        self.addSubview(bottomLine)
        self.addSubview(selectedIndicator)
        updateSelectedUI(newIndex: 0, oldIndex: 0)
    }
    
    func updateSelectedUI(newIndex: Int, oldIndex: Int) {
        guard titleButtons.count > newIndex else {
            return
        }
        let oldSelectedBtn = titleButtons[oldIndex]
        let indicatorSize = selectedIndicator.frame.size
        let associatedBtn = titleButtons[newIndex]
        oldSelectedBtn.setTitleColor(kHexColor("#BBBBBB"), for: .normal)
        associatedBtn.setTitleColor(kThemeColor, for: .normal)
        let originX = associatedBtn.frame.origin.x + (associatedBtn.frame.width - indicatorSize.width) * 0.5
        let originY: CGFloat = associatedBtn.frame.maxY + 12.0
        
        UIView.animate(withDuration: 0.2) {
            self.selectedIndicator.frame = CGRect(origin: CGPoint(x: originX, y: originY), size: indicatorSize)
        }
    }
    
    @objc private func titleButtonDidClick(sender: UIButton) {
        self.selectedIndex = sender.tag
        self.delegate?.didSelectIndex(gunSelector: self, selectedIndex: sender.tag)
    }
}
