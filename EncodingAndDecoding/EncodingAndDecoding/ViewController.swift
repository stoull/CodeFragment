//
//  ViewController.swift
//  EncodingAndDecoding
//
//  Created by Hut on 2022/5/25.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.testerEncodeAndDecoce()
    }

    func testerEncodeAndDecoce() {
        
        var leo_House = House(name: "Leo's House", location: Coordinate(latitude: 116.03, longitude: 25.88), buidDate: Date(), stories: 4, area: 180)
        
        // 编码导出为 JSON 数据
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        if let leo_house_data = try? encoder.encode(leo_House),
           let leo_house_json = String(data: leo_house_data, encoding: .utf8) {
            print("编码导出为 JSON 数据 String")
            print("\(leo_house_json)")
            
            /// JSON 对象
            let leo_house_json_Object = try? JSONSerialization.jsonObject(with: leo_house_data, options: .fragmentsAllowed)
            print("编码导出为 JSON 数据 对象")
            print("\(String(describing: leo_house_json_Object))")
        }
        
        let json_kevin = """
                {
                    "area": 550,
                    "stories": 2,
                    "name": "Kevin's House",
                    "location": {
                      "longitude": 43.32,
                      "latitude": 34.23
                    },
                    "buidDate": "2005-06-22 12:30:55"
                }
            """
        
        if let kevin_house = try? JSONDecoder().decode(House.self, from: json_kevin.data(using: .utf8)!) {
            print(kevin_house)
        }
    }

}

