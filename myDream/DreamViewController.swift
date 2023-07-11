//
//  DreamViewController.swift
//  myDream
//
//  Created by Bahadır Sengun on 11.04.2023.
//

import UIKit

class DreamViewController: UITabBarController {

    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(kaydetButton))
       
    }
    
    @objc func kaydetButton(){
        performSegue(withIdentifier: "toDetailsVC", sender: nil)
    }
   

}
