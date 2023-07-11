//
//  favoriSembollerViewController.swift
//  myDream
//
//  Created by Bahadır Sengun on 10.05.2023.
//

import UIKit

class favoriSembollerViewController: UIViewController, UITableViewDelegate {


    
    @IBOutlet var tableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        


    }

   


}
