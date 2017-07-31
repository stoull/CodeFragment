//
//  ViewController.swift
//  FaceDetector
//
//  Created by Stoull Hut on 19/07/2017.
//  Copyright © 2017 CCApril. All rights reserved.
//

import UIKit
import CoreImage

class ViewController: UIViewController {
    @IBOutlet weak var processImage: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        processImage.image = UIImage.init(named: "Missandei")
        
        self.faceDetect()
    }
    
    func faceDetect() {
        guard let personCIImage = CIImage.init(image: processImage.image!) else {
            return
        }
        
        let accuracy = [CIDetectorAccuracy : CIDetectorAccuracyHigh]
        let faceDetetor = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: accuracy)
        let faces = faceDetetor?.features(in: personCIImage)
        
        // Convert Core Image Coordinate to UIView Cooradinate
        let ciImageSize = personCIImage.extent.size
        var transform = CGAffineTransform(scaleX: 1, y: -1)
        transform = transform.translatedBy(x: 0, y: -ciImageSize.height)
        
        for face in faces as! [CIFaceFeature] {
            print("Found bounds are \(face.bounds)")
            var faceViewBounds = face.bounds.applying(transform)
            
            // Calculate the position of rect which enclose face  
            let viewSize = processImage.bounds.size
            let scale = min(viewSize.width / ciImageSize.width, viewSize.height / ciImageSize.height)
            let offsetX = (viewSize.width - ciImageSize.width * scale) / 2
            let offsetY = (viewSize.height - ciImageSize.height * scale) / 2
            faceViewBounds = faceViewBounds.applying(CGAffineTransform(scaleX: scale, y: scale))
            faceViewBounds.origin.x += offsetX
            faceViewBounds.origin.y += offsetY
            
            faceViewBounds = increaseRect(rect: faceViewBounds, byPercentage: 1.0)
            
            let faceBox = UIView.init(frame: faceViewBounds)
            faceBox.layer.borderWidth = 3
            faceBox.layer.borderColor = UIColor.init(red: 0.3, green: 0.6, blue: 0.2, alpha: 1.0).cgColor
            faceBox.backgroundColor = UIColor.clear
            
            processImage.addSubview(faceBox)
            
            if face.hasLeftEyePosition {
                print("Left eye bounds are \(face.leftEyePosition)")
            }
            
            if face.hasRightEyePosition {
                print("Right eye bounds are \(face.rightEyePosition)")
            }
            
        }
    }
    
    func increaseRect(rect: CGRect, byPercentage percentage: CGFloat) -> CGRect {
        let startWidth = rect.width
        let startHeight = rect.height
        let adjustmentWidth = (startWidth * percentage) / 2.0
        let adjustmentHeight = (startHeight * percentage) / 2.0
        return rect.insetBy(dx: -adjustmentWidth, dy: -adjustmentHeight)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

