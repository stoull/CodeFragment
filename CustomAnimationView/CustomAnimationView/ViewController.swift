//
//  ViewController.swift
//  CustomAnimationView
//
//  Created by Hut on 2021/12/15.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var animagionBgView: UIView!
    
    var animView: MGConnectingAnimationView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Is runing !!!")
        let animationView = MGConnectingAnimationView(frame: animagionBgView.bounds, bgColor: kHexColor("#6FB92C"), animationColor: kHexColor("#6FB92C"))
        animagionBgView.addSubview(animationView)
        animView = animationView
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @IBAction func stopAction(_ sender: Any) {
        animView?.stopAnimation()
    }
    
    @IBAction func startAction(_ sender: Any) {
        animView?.startAnimation()
    }
}

