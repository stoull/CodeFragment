//
//  MGHeaderSelectors.swift
//  MyGro
//
//  Created by Hut on 2021/12/7.
//  Copyright © 2021 Growatt New Energy Technology CO.,LTD. All rights reserved.
//

import UIKit

protocol MGHeaderSelectorsDelegate: AnyObject {
    func didSelectIndex(selector: MGHeaderSelectors, selectedIndex: Int)
}

class MGHeaderSelectors: UIScrollView {
    private let minWidth: CGFloat = 60.0
    private let maxWidth: CGFloat = 160.0
    private var buttonHeight: CGFloat = 40.0
    private let spacing: CGFloat = 8.0
    private var titleColor: UIColor = .darkText
    private var unSelectedTitleColor: UIColor = .lightText
    private var indicatorColor: UIColor = .lightText
    private var bottomLineColor: UIColor = .clear
    
    var titleButtons: [UIButton] = []
    var selectedIndicator: UIView = UIView()
    
    private var titles: [String] = []
    private var totalCount: Int = 1
    private var selectedIndexStorage: Int = 0
    
    var selectorDelegate: MGHeaderSelectorsDelegate?
    
    var selectedIndex: Int {
        get { selectedIndexStorage }
        set {
            updateSelectedUI(newIndex: newValue, oldIndex: selectedIndexStorage)
            selectedIndexStorage = newValue
        }
    }
    
    convenience init(frame: CGRect,
                     titles: [String],
                     titleColor: UIColor,
                     unSelectedTitleColor: UIColor,
                     indicatorColor: UIColor,
                     delegate: MGHeaderSelectorsDelegate){
        self.init(frame: frame)
        self.titles = titles
        self.selectorDelegate = delegate
        self.titleColor = titleColor
        self.unSelectedTitleColor = unSelectedTitleColor
        self.indicatorColor = indicatorColor
        self.buttonHeight = frame.size.height - 4
        initViews(titles: titles, size: frame.size, titleColor: titleColor, unSelectedTitleColor: unSelectedTitleColor, indicatorColor: indicatorColor)
    }
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func initViews(titles: [String], size: CGSize, titleColor: UIColor, unSelectedTitleColor: UIColor, indicatorColor: UIColor) {
        totalCount = titles.count
        guard totalCount > 0 else {
            return
        }
        
        var originX: CGFloat = 0.0
        var index = 0
        titleButtons = []
        for title in titles {
            let bt = createButton(withTitle: title, titleColor: titleColor, unSelectedTitleColor: unSelectedTitleColor)
            var btWidth:CGFloat = bt.bounds.width
            if btWidth < minWidth { btWidth = minWidth }
            if btWidth > maxWidth { btWidth = maxWidth }
            bt.frame = CGRect(origin: CGPoint(x: originX, y: 0), size: CGSize(width: btWidth, height: buttonHeight))
            bt.tag = index
            index+=1
            titleButtons.append(bt)
            addSubview(bt)
            originX += bt.frame.width + spacing
        }
        self.contentSize = CGSize(width: originX, height: size.height)
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false
        
        // 最底部的线
        let bottomLine = UIView(frame: CGRect(x: 0.0, y: size.height-2, width: size.width, height: 1))
        bottomLine.backgroundColor = bottomLineColor
        
        // 已选的指示线
        let indicatorSize = CGSize(width: titleButtons.first?.bounds.width ?? minWidth, height: 2.0)
        let indicatorY = size.height-4.0
        selectedIndicator.frame = CGRect(origin: CGPoint(x: 0, y: indicatorY), size: indicatorSize)
        selectedIndicator.backgroundColor = indicatorColor
        
        addSubview(bottomLine)
        addSubview(selectedIndicator)
        updateSelectedUI(newIndex: 0, oldIndex: 0)
    }
    
    func updateSelectedUI(newIndex: Int, oldIndex: Int) {
        guard titleButtons.count > newIndex else {
            return
        }
        let oldSelectedBtn = titleButtons[oldIndex]
        let associatedBtn = titleButtons[newIndex]
        let indicatorSize = CGSize(width: associatedBtn.bounds.width, height: 2.0)
        oldSelectedBtn.isSelected = false
        associatedBtn.isSelected = true
        let originX = associatedBtn.frame.origin.x
        let originY: CGFloat = bounds.height - 4.0
        UIView.animate(withDuration: 0.2) {
            self.selectedIndicator.frame = CGRect(origin: CGPoint(x: originX, y: originY), size: indicatorSize)
        }
    }
    
    @objc private func titleButtonDidClick(sender: UIButton) {
        self.selectedIndex = sender.tag
        self.selectorDelegate?.didSelectIndex(selector: self, selectedIndex: sender.tag)
    }
    
    private func createButton(withTitle title: String, titleColor: UIColor, unSelectedTitleColor: UIColor) -> UIButton {
        let selectTitleAttr: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 18, weight: .bold), .foregroundColor: titleColor]
        let titleAttr: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 18, weight: .medium), .foregroundColor: unSelectedTitleColor]
        let titleSize = title.getBoundingRect(maxSize: CGSize(width: maxWidth, height: 44.0), attributes: selectTitleAttr)
        let bt = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: titleSize.width, height: buttonHeight)))
        bt.setAttributedTitle(NSAttributedString(string: title, attributes: selectTitleAttr), for: .selected)
        bt.setAttributedTitle(NSAttributedString(string: title, attributes: titleAttr), for: .normal)
        bt.addTarget(self, action: #selector(titleButtonDidClick(sender:)), for: .touchUpInside)
        return bt
    }
}
