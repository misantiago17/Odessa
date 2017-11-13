//
//  StoreViewController.swift
//  Odessa
//
//  Created by João Rafael de Aquino on 13/11/17.
//  Copyright © 2017 Michelle Beadle. All rights reserved.
//

import UIKit
import GameplayKit

class StoreViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let sceneNode = StoreScene(size: view.frame.size) as StoreScene? {
            
            sceneNode.scaleMode = .aspectFill
            
            let view = self.view as! SKView
            view.showsNodeCount = true
            
            view.presentScene(sceneNode)
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
