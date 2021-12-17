//
//  ViewController.swift
//  Bluetooth_Demo
//
//  Created by Hut on 2021/12/17.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func centralDidClick(_ sender: UIButton) {
        self.navigationController?.pushViewController(CentralViewController(), animated: true)
    }
    
    @IBAction func peripheralDidClick(_ sender: UIButton) {
        self.navigationController?.pushViewController(PeripheralViewController(), animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
