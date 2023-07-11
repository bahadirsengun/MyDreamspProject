//
//  SSSViewController.swift
//  myDream
//
//  Created by Bircan Sezgin on 5.05.2023.
//

import UIKit

class SSSViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var cevapArray = [SoruCevap]()
    
    var soruCevapArray = [SoruCevap]() {
        didSet {
            cevapArray = soruCevapArray
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
            
    }
 
}


extension SSSViewController: UITableViewDelegate, UITableViewDataSource, SSSTableViewCellProtocol{

    func asnwerShow(indexPath: IndexPath) {
        let gelenSorular = soruCevapArray[indexPath.row]
        let alert = UIAlertController(title: gelenSorular.soruIsim, message: gelenSorular.soruCevap, preferredStyle: .alert)
        let okbutton = UIAlertAction(title: "Tamam", style: .default)
        alert.addAction(okbutton)
        self.present(alert, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return soruCevapArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        
        let comingQu = soruCevapArray[indexPath.row]

        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SSS") as! SSSTableViewCell
        cell.soruBasligiLabel.text = comingQu.soruIsim
        cell.hucreProtocol = self
        cell.indexPath = indexPath
        
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let gelenSorular = soruCevapArray[indexPath.row]
        if let cell = tableView.cellForRow(at: indexPath) as? SSSTableViewCell {
                UIView.animate(withDuration: 0.1, animations: {
                    cell.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                    cell.alpha = 0.7
                }, completion: { _ in
                    UIView.animate(withDuration: 0.1, animations: {
                        cell.transform = CGAffineTransform.identity
                        cell.alpha = 1.0
                    })
                })
            }
        
        let alert = UIAlertController(title: gelenSorular.soruIsim, message: gelenSorular.soruCevap, preferredStyle: .alert)
        let okbutton = UIAlertAction(title: "Tamam", style: .default)
        alert.addAction(okbutton)
        self.present(alert, animated: true)
            
        }
    
   
    
    
}
