//
//  MainViewController.swift
//  3D-Touch
//
//  Created by linkapp on 13/09/2017.
//  Copyright © 2017 hut. All rights reserved.
//

import UIKit

struct FruitAndVeg {
    let name: String
    let descir: String
}

class MainViewController: UITableViewController {
    
    let sampleData = [
        FruitAndVeg.init(name: "apple", descir: "Granny Smith, Royal Gala, Golden Delicious and Pink Lady are just a few of the thousands of different kinds of apple that are grown around the world! You can make dried apple rings at home - ask an adult to help you take out the core, thinly slice the apple and bake the rings in the oven at a low heat."),
        FruitAndVeg.init(name: "apricots", descir: "Apricots can be eaten fresh or dried - both are packed with vitamins! Fresh apricots have a soft and slightly furry skin. They make a good lunchbox snack. Apricots are also high in beta-carotene - this helps us keep our eyes and skin healthy."),
        FruitAndVeg.init(name: "aubergine", descir: "Most aubergines are teardrop-shaped and have a glossy purple skin. On the inside, they are spongy and creamy white. Aubergines grow on bushes and are really fruits - although you wouldn't want to eat them raw. Australians and Americans call it eggplant because some types look a bit like large eggs!"),
        FruitAndVeg.init(name: "banana", descir: "Bananas make a nutritious snack! They are a great source of energy and contain lots of vitamins and minerals, especially potassium, which is important to help cells, nerves and muscles in your body to work properly and it helps to lower blood pressure. They have a thick skin to protect them, which is green before bananas are ripe, and get more yellow in colour and sweeter in taste as they ripen. We peel away the skin and eat the soft fleshy part of the fruit underneath. Bananas grow in hanging clusters, sometimes called hands, on the banana plant in tropical regions like Southeast Asia. You can eat them raw, baked, dried or in a smoothie. Why don't you try mashing it up and have it with yoghurt or porridge or even on brown toast?"),
        FruitAndVeg.init(name: "beetroot", descir: "Beetroot is the root of the beet plant - which explains its name! People have grown it for food since Roman times. Raw beetroot is best for you and great for grating - peel it first. Try it in a salad or sandwich. Small beetroots are usually the sweetest. Ahhhh!"),
        FruitAndVeg.init(name: "clementine", descir: "This citrus fruit is the smallest of the tangerines. The skin of Clementines can be peeled away easily and the segments don’t contain pips, which makes them a lot less messy to eat than some other varieties. They smell so delicious and naturally sweet. They are often eaten at Christmas time. Citrus fruits are a good source of vitamin C."),
        FruitAndVeg.init(name: "leek", descir: "These are in the same family as onion and garlic – they are allium vegetables. Leeks need to be washed well to remove any dirt and grit between the white sections. You can boil or steam leeks to add to a recipe or stir-fry them with other vegetables. They are in season in the UK. over the winter months and are a good source of fibre."),
        FruitAndVeg.init(name: "blackeyebeans", descir: "In America, these beans are often called black-eyed peas or cow peas. They each have a little black dot on the side - this is where they were once attached to their pod, so it's a bit like a belly button! You can mix them with all sorts of other beans to make a super salad."),
        FruitAndVeg.init(name: "broccoli", descir: "Broccoli is closely related to cabbage - and it's another one of those 'greens' we're always being told to eat up. The part of a broccoli plant we normally eat is the lovely flowerhead - the flowers are usually green but sometimes purple. Steamed broccoli is tasty in a salad or stir-fry."),
        FruitAndVeg.init(name: "Brusselssprouts", descir: "Brussels sprouts are like mini cabbages! They grow out of the ground in knobbly rows on a long tough stalk. They contain loads of vitamin C. Can you guess which country BRUSSELS sprouts originally came from? Well, Brussels is the capital city of Belgium!"),
        FruitAndVeg.init(name: "butternutsquash", descir: "Butternut squash is large and pear-shaped with a golden-brown to yellow skin. We don't eat the skin and seeds, only the flesh. The flesh is really hard when it is raw but it turns soft and sweet when it is cooked. It can be roasted, pureed, mashed or used in soups or casseroles. It is a good source of beta-carotene, which is turned into vitamin A in the body. Beta-carotene gives the flesh its bright orange colour."),
        FruitAndVeg.init(name: "carrots", descir: "Carrots grow underground and they can be used in all sorts of dishes - from casseroles to cakes. Raw carrots are great to crunch on and they make a healthy juice, too. They contain lots of beta-carotene - this helps us keep our eyes and skin healthy."),
        FruitAndVeg.init(name: "cherries", descir: ""),
        FruitAndVeg.init(name: "endive", descir: ""),
        FruitAndVeg.init(name: "fennel", descir: ""),
        FruitAndVeg.init(name: "figs", descir: ""),
        FruitAndVeg.init(name: "garlic", descir: ""),
        FruitAndVeg.init(name: "greenbeans", descir: ""),
        FruitAndVeg.init(name: "iceberglettuce", descir: ""),
        FruitAndVeg.init(name: "mango", descir: ""),
        FruitAndVeg.init(name: "melon", descir: ""),
        FruitAndVeg.init(name: "mushroom", descir: ""),
        FruitAndVeg.init(name: "nuts", descir: ""),
        FruitAndVeg.init(name: "orange", descir: ""),
        FruitAndVeg.init(name: "peppers", descir: ""),
        FruitAndVeg.init(name: "pineapple", descir: ""),
        FruitAndVeg.init(name: "plums", descir: ""),
        FruitAndVeg.init(name: "pumpkin", descir: ""),
        FruitAndVeg.init(name: "radishes", descir: ""),
        FruitAndVeg.init(name: "strawberry", descir: ""),
        FruitAndVeg.init(name: "sweetpotato", descir: ""),
        FruitAndVeg.init(name: "tomato", descir: ""),
        FruitAndVeg.init(name: "turnip", descir: ""),
        FruitAndVeg.init(name: "zucchini", descir: ""),
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(NSClassFromString("UITableViewCell"), forCellReuseIdentifier: "FriutCell")
        if traitCollection.forceTouchCapability == .available {
            registerForPreviewing(with: self, sourceView: view)
        }
        
        title = "Fruit and Veg"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sampleData.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriutCell", for: indexPath)

        let friutOrVeb = sampleData[(indexPath as NSIndexPath).row];
        if let friutImage = UIImage.init(named: friutOrVeb.name) {
            cell.imageView?.image = friutImage
        }else {
            cell.imageView?.image = nil;
        }
//        cell.textLabel?.text = friutOrVeb.name;
        
        let attribute: [String : Any] = [NSForegroundColorAttributeName : UIColor.gray,
         NSBackgroundColorAttributeName : UIColor.clear,
         NSFontAttributeName : UIFont.boldSystemFont(ofSize: 18)]
        
        let attributeName = NSAttributedString.init(string: friutOrVeb.name, attributes: attribute)
        cell.textLabel?.attributedText = attributeName;
        
        cell.detailTextLabel?.text = friutOrVeb.descir;
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
