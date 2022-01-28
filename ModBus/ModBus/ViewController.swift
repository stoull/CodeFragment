//
//  ViewController.swift
//  Bluetooth_Demo
//
//  Created by Hut on 2021/12/17.
//

import UIKit
import SPPermissions

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // MARK: - 蓝牙权限判断
    func checkBluetoothPermission() {
        

        
        if #available(iOS 13.0, *) {
            if SPPermissions.Permission.bluetooth.authorized == false {
                let permissions: [SPPermissions.Permission] = [.bluetooth]
                // 2a. List Style
        //        let controller = SPPermissions.list(permissions)
                // 2b. Dialog Style
                let controller = SPPermissions.dialog(permissions)

        //        // 2c. Native Style
        //        let controller = SPPermissions.native(permissions)
        //        controller.present(on: self)
                
                controller.delegate = self
                controller.dataSource = self
                controller.present(on: self)
            }
        } else {
            
        }

    }
    
    @IBAction func centralDidClick(_ sender: UIButton) {
        self.navigationController?.pushViewController(CentralViewController(), animated: true)
    }
    
    @IBAction func peripheralDidClick(_ sender: UIButton) {
        self.navigationController?.pushViewController(PeripheralViewController(), animated: true)
    }
    
    @IBAction func showPermission(_ sender: Any) {
        checkBluetoothPermission()
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

extension ViewController: SPPermissionsDelegate, SPPermissionsDataSource {

    // MARK: - SPPermissionsDelegate
    func didAllowPermission(_ permission: SPPermissions.Permission){
        print("didAllowPermission")
    }
    
    func didDeniedPermission(_ permission: SPPermissions.Permission) {
        print("didDeniedPermission")
    }
    
    func didHidePermissions(_ permissions: [SPPermissions.Permission]) {
        print("didHidePermissions")
    }
    
    // MARK: - SPPermissionsDataSource
    func configure(_ cell: SPPermissionsTableViewCell, for permission: SPPermissions.Permission) {
        // Here you can customise cell, like texts or colors.
        cell.permissionTitleLabel.text = "蓝牙权限"
        cell.permissionDescriptionLabel.text = "MyGro需要使用您设备的蓝牙功能，这样才能与其它设备进行连接"
        
        // If you need change icon, choose one of this:
        cell.permissionIconView.setPermissionType(.bluetooth)
//        cell.permissionIconView.setCustomImage(UIImage.init(named: "custom-name"))
//        cell.permissionIconView.setCustomView(YourView())
    }
    
    func deniedAlertTexts(for permission: SPPermissions.Permission) -> SPPermissionsDeniedAlertTexts? {
        let texts = SPPermissionsDeniedAlertTexts()
        texts.titleText = "Permission denied"
        texts.descriptionText = "Please, go to Settings and allow permission."
        texts.actionText = "Settings"
        texts.cancelText = "Cancel"
        return texts
    }
}
