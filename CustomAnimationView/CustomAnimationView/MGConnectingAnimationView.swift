//
//  MGConnectingAnimationView.swift
//  CustomAnimationView
//
//  Created by Hut on 2021/12/15.
//

import UIKit


class MGConnectingAnimationView: UIView {
    let backgrounView = UIView()
    let centerView = UIView()
    let cPercentage: CGFloat = 0.3
    let lineAngleWidth = MGConnectingAnimationView.deg2rad(80.0)
    
    var bgColor: UIColor = .lightGray
    var animationColor: UIColor = UIColor.white
    
    private var isShouldStopAnimation: Bool = false
    private var isSuccessFull: Bool = true
    private var arcLineLeftLayer = CAShapeLayer()
    private var arcLineRightLayer = CAShapeLayer()
    
    convenience init(frame: CGRect, bgColor: UIColor, animationColor: UIColor) {
        self.init(frame: frame)
        self.bgColor = bgColor
        self.animationColor = animationColor
        
        backgrounView.frame = frame
        let radarAniLayer = radarScaleAnimationLayer(size: backgrounView.frame.size, color: animationColor, startPercenage: cPercentage)
        backgrounView.layer.addSublayer(radarAniLayer)
        addSubview(backgrounView)
        
        let cWidth = frame.width*cPercentage
        let originX = (frame.width - cWidth)*0.5
        centerView.frame = CGRect(origin: CGPoint(x: originX, y: originX), size: CGSize(width: cWidth, height: cWidth))
        centerView.layer.backgroundColor = bgColor.cgColor
        centerView.layer.cornerRadius = cWidth*0.5
        
        addSubview(centerView)
    }
    
    /// 开始动画
    func startAnimation() {
        arcLineLeftLayer.removeFromSuperlayer()
        arcLineRightLayer.removeFromSuperlayer()
        centerView.layer.removeAllAnimations()
        if let subLayers = centerView.layer.sublayers {
            for layer in subLayers {
                layer.removeFromSuperlayer()
            }
        }
        setupAnimaiton()
    }
    
    /// 结束动画
    func setupAnimaiton() {
        // Scale animation
        isShouldStopAnimation = false
        setupStartingAnimation(in: centerView, animationColor: UIColor.white)
    }
    
    func stopAnimation(isSuccess: Bool) {
        isShouldStopAnimation = true
        isSuccessFull = isSuccess
    }
    
    private func setupStartingAnimation(in view: UIView, animationColor: UIColor){
        let length = view.frame.width
        let lineWidth = length*0.1
        let radius = length*0.5*0.6
        let centerPoint = CGPoint(x: length*0.5, y: length*0.5)
        
        let path1 = UIBezierPath(arcCenter: centerPoint, radius: radius, startAngle: 1.5*Double.pi, endAngle: 1.5*Double.pi+lineAngleWidth, clockwise: true)
        let path2 = UIBezierPath(arcCenter: centerPoint, radius: radius, startAngle: 0.5*Double.pi, endAngle: 0.5*Double.pi+lineAngleWidth, clockwise: true)
        
        let paths = [path1, path2]

        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = 0.3
        animation.fromValue = 0
        animation.toValue = 1
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        animation.delegate = self
        animation.setValue("ConnectingStartingAnition", forKey: "MGAnimationID")

        for i in 0..<2 {
            let layer = CAShapeLayer()
            layer.path = paths[i].cgPath
            layer.fillColor = UIColor.clear.cgColor
            layer.strokeColor = animationColor.cgColor
            layer.lineWidth = lineWidth
            layer.lineCap = .round
            layer.lineJoin = .round
            layer.strokeEnd = 0

            animation.beginTime = CACurrentMediaTime()
            
            layer.add(animation, forKey: "ConnectingStartingAnition")
            view.layer.addSublayer(layer)
            
            if i == 0 {
                arcLineLeftLayer = layer
            }
            if i == 1 {
                arcLineRightLayer = layer
            }
        }
    }
    
    /// 开始连接中动画
    func startRotationAnimation(in view: UIView, with angle: Double?=Double.pi*2, isTheLast: Bool? = false) {
        let duration: CGFloat = 1.0
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")

        rotationAnimation.duration = duration
        rotationAnimation.fromValue = 0
        rotationAnimation.toValue = angle
        rotationAnimation.isRemovedOnCompletion = false
        rotationAnimation.fillMode = .forwards
        
        rotationAnimation.delegate = self
        
        if isTheLast == true {
            rotationAnimation.setValue("ConnectingRotationTheLastAnition", forKey: "MGAnimationID")
            view.layer.add(rotationAnimation, forKey: "ConnectingRotationTheLastAnition")
        } else {
            rotationAnimation.setValue("ConnectingRotationAnition", forKey: "MGAnimationID")
            view.layer.add(rotationAnimation, forKey: "ConnectingRotationAnition")
        }
    }
    
    // 角度转弧度
    static func rad2deg(_ number: Double) -> Double {
        return number * 180 / .pi
    }
    
    // 弧度转角度
    static func deg2rad(_ number: Double) -> Double {
        return number * .pi / 180
    }
    
    /// 成功的动画
    func animatedIconSucceed(in view: UIView, animationColor: UIColor) {
        let length = view.frame.width
        let duration: CGFloat = 0.6
        let lineWidth = length*0.1
        let radius = length*0.5*0.6
        
        let path1 = UIBezierPath()
        path1.move(to: CGPoint(x: length * 0.35, y: length * 0.50))
        path1.addLine(to: CGPoint(x: length * 0.45, y: length * 0.60))
        path1.addLine(to: CGPoint(x: length * 0.65, y: length * 0.40))
        
        let centerPoint = CGPoint(x: length*0.5, y: length*0.5)
        let path2 = UIBezierPath(arcCenter: centerPoint, radius: radius, startAngle: 2*Double.pi-lineAngleWidth, endAngle: 2*Double.pi, clockwise: true)
        let path3 = UIBezierPath(arcCenter: centerPoint, radius: radius, startAngle: Double.pi-lineAngleWidth, endAngle: Double.pi, clockwise: true)
        
        let paths = [path1, path2, path3]
        

        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = duration
        animation.fromValue = 0
        animation.toValue = 1
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        
        let animation2 = CABasicAnimation(keyPath: "strokeStart")
        animation2.duration = duration
        animation2.fromValue = 0
        animation2.toValue = 1
        animation2.fillMode = .forwards
        animation2.isRemovedOnCompletion = false

        for i in 0..<3 {

            let layer = CAShapeLayer()
            layer.path = paths[i].cgPath
            layer.fillColor = UIColor.clear.cgColor
            layer.strokeColor = animationColor.cgColor
            layer.lineWidth = lineWidth
            layer.lineCap = .round
            layer.lineJoin = .round
            layer.strokeEnd = 0
            
            animation.beginTime = CACurrentMediaTime()
            if i == 0 {
                layer.add(animation, forKey: "SuccessfulIconAnimation")
            } else if i == 1 {
                arcLineRightLayer.add(animation2, forKey: "SuccessfulDismissAnimation")
            } else if i == 2 {
                arcLineLeftLayer.add(animation2, forKey: "SuccessfulDismissAnimation")
            }
            
            view.layer.addSublayer(layer)
        }
    }
    

    // 设置圆形radar动画
    func radarScaleAnimationLayer(size: CGSize, color: UIColor, startPercenage: CGFloat) -> CALayer {
        let duration: CFTimeInterval = 2.0

        // Scale animation
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")

        scaleAnimation.duration = duration
        scaleAnimation.fromValue = startPercenage // 0.4
        scaleAnimation.toValue = 1

        // Opacity animation
        let opacityAnimation = CABasicAnimation(keyPath: "opacity")

        opacityAnimation.duration = duration
        opacityAnimation.fromValue = 1
        opacityAnimation.toValue = 0

        // Animation
        let animation = CAAnimationGroup()

        animation.animations = [scaleAnimation, opacityAnimation]
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animation.duration = duration
        animation.repeatCount = HUGE
        animation.isRemovedOnCompletion = false

        // Draw circle
        let circleLayer = self.arcLayerWith(size: size, color: color)
        
        circleLayer.frame = CGRect(x: (layer.bounds.size.width - size.width) / 2,
                              y: (layer.bounds.size.height - size.height) / 2,
                              width: size.width,
                              height: size.height)
        circleLayer.add(animation, forKey: "animation")
        return circleLayer
    }

    /// 生成形状layer图
    func arcLayerWith(size: CGSize, color: UIColor) -> CALayer {
        let layer: CAShapeLayer = CAShapeLayer()
        let path: UIBezierPath = UIBezierPath()

        path.addArc(withCenter: CGPoint(x: size.width / 2, y: size.height / 2),
                    radius: size.width / 2,
                    startAngle: 0,
                    endAngle: CGFloat(2 * Double.pi),
                    clockwise: false)
        layer.fillColor = color.cgColor
        
        layer.backgroundColor = nil
        layer.path = path.cgPath
        layer.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)

        return layer
    }
}


extension MGConnectingAnimationView: CAAnimationDelegate {
    func animationDidStart(_ anim: CAAnimation) {
        print("animationDidStart")
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if let animID = anim.value(forKey: "MGAnimationID") as? String,
           flag == true{
            
            if animID == "ConnectingStartingAnition" {
                startRotationAnimation(in: self.centerView)
            }
            
            if animID == "ConnectingRotationAnition" {
                if isShouldStopAnimation == true {
                    startRotationAnimation(in: self.centerView, isTheLast: true)
                } else {
                    startRotationAnimation(in: self.centerView)
                }
            }
            
            if animID == "ConnectingRotationTheLastAnition" {
                if isSuccessFull == true {
                    animatedIconSucceed(in: self.centerView, animationColor: UIColor.white)
                } else {
                    
                }
            }
        }
        
    }
}
 
