//
//  DetailViewController.swift
//  3D-Touch
//
//  Created by linkapp on 13/09/2017.
//  Copyright © 2017 hut. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var friutName: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var desCiblelabel: UILabel!
    
    var friutOrVeb: FruitAndVeg?
    
    
    // 3D-Touch 菜单
    lazy var previewActions: [UIPreviewActionItem] = {
        func previewActionForTitle(_ title: String, style: UIPreviewActionStyle = .default) -> UIPreviewAction{
            
            return UIPreviewAction(title: title, style: style) { previewAction, viewController in
                
                guard let detailViewController = viewController as? DetailViewController,
                    let sampleTitle = detailViewController.friutOrVeb?.name else { return }
                
                print("\(previewAction.title) 触发自 `DetailViewController` for item: \(sampleTitle)")
            }
        }
        
        let action1 = previewActionForTitle("产地")
        let action2 = previewActionForTitle("营养学介绍")
        let action3 = previewActionForTitle("取消", style: .destructive)
        
        let subAction1 = previewActionForTitle("地理分布")
        let subAction2 = previewActionForTitle("土壤条件")
        let groupedActions = UIPreviewActionGroup(title: "培育...", style: .default, actions: [subAction1, subAction2] )
        
        return [action1, action2, groupedActions, action3]

    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let nameStr = friutOrVeb?.name{
            self.friutName.text = nameStr
            self.imageView.image = UIImage.init(named: nameStr)
            self.desCiblelabel.text = friutOrVeb?.descir
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Preview actions 实现此代理，设置对应的菜单项

    override var previewActionItems : [UIPreviewActionItem] {
        return previewActions
    }
}
