//
//  MainViewController+UIViewControllerPreviewing.swift
//  3D-Touch
//
//  Created by linkapp on 13/09/2017.
//  Copyright © 2017 hut. All rights reserved.
//

import UIKit

extension MainViewController: UIViewControllerPreviewingDelegate {
    
    // 设置 3D-Touch 的 peek 动作
    public func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController?{
        
        guard let indexPath = tableView.indexPathForRow(at: location),
            let cell = tableView.cellForRow(at: indexPath) else { return nil}
        
        let friut = sampleData[indexPath.row]
        
        guard let detailVC: DetailViewController = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController else {return nil}
        
        detailVC.friutOrVeb = friut
        
        // 设置大小
        let desString: NSString = friut.descir as NSString
        let attribute: [String : Any] = [NSFontAttributeName : UIFont.systemFont(ofSize: 18)]
        
        let expectedSize = (desString.boundingRect(with: CGSize(width: previewingContext.sourceView.bounds.width, height:999), options:.usesLineFragmentOrigin, attributes: attribute, context: nil)).size
        
        // 计算高度
        if let contentImage = UIImage(named: friut.name) {
            detailVC.preferredContentSize = CGSize(width: 0.0, height: 80 + expectedSize.height + contentImage.size.height);
        }else {
            detailVC.preferredContentSize = CGSize(width: 0.0, height: 80 + expectedSize.height);
        }

        previewingContext.sourceRect = cell.frame;
        
        return detailVC
    }
    
    // 设置 3D-Touch 的 pop 动作
    public func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController){
        show(viewControllerToCommit, sender: self)
    }
}
