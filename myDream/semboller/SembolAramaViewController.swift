//
//  SembolAramaViewController.swift
//  
//
//  Created by Bahadır Sengun on 17.04.2023.
//

import UIKit
import GoogleMobileAds

class SembolAramaViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, GADFullScreenContentDelegate  {
    
    var favoriteItems: [RuyaSembol] = []

    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    
    // Karsidan gonderdik
    var sembol = [RuyaSembol]() {
        didSet {
            print("Veri geldi")
        }
    }
   

    private var interstitial: GADInterstitialAd?
    
    
    var aramaSonucuSembol:[String] = [String]()
    var aramaYapiliyorMu = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
        tableView.sectionIndexMinimumDisplayRowCount = 20

        
        let request = GADRequest()
        GADInterstitialAd.load(withAdUnitID: "ca-app-pub-6772888339663305/3972813999",
                               request: request,
                               completionHandler: { [self] ad, error in
            if let error = error{
                print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                return
                
            }
            interstitial = ad
            interstitial?.fullScreenContentDelegate = self
            
        }
        )
        
        

        
        
    }


    
    
    @objc func hideKeyboard(){
        view.endEditing(false)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if aramaYapiliyorMu == true{
            return aramaSonucuSembol.count
        }else{
            return sembol.count
        }
    }


    /*func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        // İlgili bölümün indeksini döndürün
        if aramaYapiliyorMu {
            return NSNotFound
        } else {
            let sectionIndex = sectionIndexTitles(for: tableView)?.firstIndex(of: title) ?? NSNotFound
            return sectionIndex  
        }
    }*/




    
   /* func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        if aramaYapiliyorMu {
            return nil
        } else {
            return ["A", "B", "C", "Ç", "D", "E", "F", "G", "Ğ", "H", "I", "İ", "J",
                    "K", "L", "M", "N", "O", "Ö", "P", "Q", "R", "S", "Ş", "T", "U",
                    "Ü", "V", "W", "X", "Y", "Z"]
        }
    } */

    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let gelenveri: RuyaSembol
            
        if aramaYapiliyorMu {
            let sembolAdi = aramaSonucuSembol[indexPath.row]
            gelenveri = sembol.first(where: { $0.sembolisim == sembolAdi })!
        } else {
            gelenveri = sembol[indexPath.row]
        }
            
        let cell = UITableViewCell()
        var content = cell.defaultContentConfiguration()
            
        if aramaYapiliyorMu {
            content.text = aramaSonucuSembol[indexPath.row]
        } else {
            content.text = gelenveri.sembolisim
        }
        cell.contentConfiguration = content
            
        // Hücrenin tik işaretini güncelle
        cell.accessoryType = gelenveri.favoriSembol ? .checkmark : .none
            
        return cell
    }


    

    
    // Hücreye tiklaninca ne olsun
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        

        let gelenveri: RuyaSembol
        if aramaYapiliyorMu {
            let sembolAdi = aramaSonucuSembol[indexPath.row]
            gelenveri = sembol.first(where: { $0.sembolisim == sembolAdi })!
        } else {
            gelenveri = sembol[indexPath.row]
        }
            
        let alert = UIAlertController(title: gelenveri.sembolisim!, message: gelenveri.sembolAnlami!, preferredStyle: .alert)
        let button = UIAlertAction(title: "Tamam", style: .default) { [self]  UIAlertAction in
            if interstitial != nil {
                        interstitial!.present(fromRootViewController: self)
                      } else {
                        print("Ad wasn't ready")
                      }
        }
        alert.addAction(button)
            
        // Tik işaretini kaldırmak için kullanıcının alert'i kapattığından emin olun
        /*alert.addAction(UIAlertAction(title: "Kapat", style: .cancel) { _ in
            gelenveri.favoriSembol = false
            tableView.reloadRows(at: [indexPath], with: .none)
        }) */
    
        self.present(alert, animated: true)
    }

    
    func showActionToast(with message: String) {
        let toastLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 250, height: 50))
        toastLabel.center = view.center
        toastLabel.backgroundColor = UIColor.systemPurple.withAlphaComponent(1)
        toastLabel.textColor = UIColor.white
        toastLabel.font = UIFont.systemFont(ofSize: 18)
        toastLabel.textAlignment = .center
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds = true
        view.addSubview(toastLabel)
        
        UIView.animate(withDuration: 2.0, delay: 0.5, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: { (isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }


    
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let toggleFavoriteAction = UIContextualAction(style: .normal, title: nil) { [self] (action, view, completionHandler) in
            let cell = tableView.cellForRow(at: indexPath)
            
            // Tik işaretini güncelle
            cell?.accessoryType = cell?.accessoryType == .checkmark ? .none : .checkmark
            
            // Favorilere ekle veya favorilerden çıkar
            let selectedRuyaSembol: RuyaSembol
            if aramaYapiliyorMu {
                let sembolAdi = aramaSonucuSembol[indexPath.row]
                selectedRuyaSembol = sembol.first(where: { $0.sembolisim == sembolAdi })!
                self.showActionToast(with: "Favoriler, Çok Yakında")
            } else {
                selectedRuyaSembol = sembol[indexPath.row]
                self.showActionToast(with: "Favoriler, Çok Yakında")
            }
            
            selectedRuyaSembol.favoriSembol = cell?.accessoryType == .checkmark
            
            completionHandler(true)
        }
        
        toggleFavoriteAction.backgroundColor = UIColor.systemPurple
        toggleFavoriteAction.image = UIImage(systemName: "heart")
        toggleFavoriteAction.title = "Favorilere Ekle"
        
        let configuration = UISwipeActionsConfiguration(actions: [toggleFavoriteAction])
        configuration.performsFirstActionWithFullSwipe = false
        
        return configuration
    }




    // rehber
    
    // favori semboller sağ üst button

    

}
extension SembolAramaViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("Arama sonucu \(searchText)")
        
        if searchText == "" { // Arama yapilmiyor
            aramaYapiliyorMu = false
        } else {
            aramaYapiliyorMu = true
            
            let filteredSembol = sembol.filter { $0.sembolisim!.lowercased().contains(searchText.lowercased()) }
            aramaSonucuSembol = filteredSembol.map { $0.sembolisim! }
        }
        
        
        tableView.reloadData()
    }
}







