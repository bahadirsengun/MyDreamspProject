//
//  dreamSave.swift
//  myDream
//
//  Created by Bahadır Sengun on 19.04.2023.
//

import UIKit
import CoreData
import GoogleMobileAds

class dreamSave: UIViewController, UITextViewDelegate, GADFullScreenContentDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate {


    @IBOutlet var ruyaTextView: UITextView!

    @IBOutlet var kaydetButton: UIButton!

    @IBOutlet var imageView: UIImageView!

    @IBOutlet var baslıkText: UITextField!

    @IBOutlet var tarihText: UITextField!

    @IBOutlet var duyguText: UITextField!



    var chosenDreams = ""
    var chosenDreamsId: UUID?
    let ruyametni = "Rüyanızı buraya girebilirsiniz :)"

    private var interstitial: GADInterstitialAd?

    override func viewDidLoad() {
        super.viewDidLoad()

        //Reklam         -->        ca-app-pub-3940256099942544/4411468910
        let request = GADRequest()
        GADInterstitialAd.load(withAdUnitID: "ca-app-pub-3940256099942544/4411468910",
                               request: request,
                               completionHandler: { [self] ad, error in
                                   if let error = error {
                                       print("Failed to load interstitial ad with error: (error.localizedDescription)")
                                       return
                                   }
                                   interstitial = ad
                                   interstitial?.fullScreenContentDelegate = self
                               }
        )



        ruyaTextView.delegate = self
        ruyaTextView.text = ruyametni
        ruyaTextView.textColor = .black

        // textviewin cerceve rengini değiştirdik..
        ruyaTextView.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
        ruyaTextView.layer.borderWidth = 1.0
        ruyaTextView.layer.cornerRadius = 5

        tarihText.text = Date().description // şu anki tarihin metin gösterimi
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        tarihText.text = dateFormatter.string(from: Date()) // şu anki tarihin özelleştirilmiş formatlı metin gösterimi.

        let dokunmaAlgilama = UITapGestureRecognizer(target: self, action: #selector(self.dokumaAlgilama))
        view.addGestureRecognizer(dokunmaAlgilama)

        if chosenDreams != "" {

            kaydetButton.isHidden = true

            //coredata
            //HSATIR BOLM BEEE
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext

            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Dreams")
            let idString = chosenDreamsId?.uuidString
            fetchRequest.predicate = NSPredicate(format: "id = %@", idString!)
            fetchRequest.returnsObjectsAsFaults = false

            do {
                let results = try context.fetch(fetchRequest)

                if results.count > 0 {
                    for result in results as! [NSManagedObject] {
                        if let baslık = result.value(forKey: "baslik") as? String {
                            baslıkText.text = baslık
                        }

                        if let duygu = result.value(forKey: "duygu") as? String {
                            duyguText.text = duygu
                        }

                        if let tarih = result.value(forKey: "tarih") as? String {
                            tarihText.text = tarih
                        }

                        if let ruya = result.value(forKey: "ruya") as? String {
                            ruyaTextView.text = ruya
                        }
                    }
                }
            } catch {
                print("Error")
            }

        } else {
        
        }

        //RECOGNİZERS --> Kullanıcı etkileşimlerini tanır. dokunma, sürükleme, kaydırma...

        //Klavye Gizleme
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(gestureRecognizer)

        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addButtonClicked))
    }

    func ad(ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("Ad did fail to present full screen content.")
    }

    /// Tells the delegate that the ad will present full screen content.
    func adWillPresentFullScreenContent(ad: GADFullScreenPresentingAd) {
        print("Ad will present full screen content.")
    }

    /// Tells the delegate that the ad dismissed full screen content.
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad did dismiss full screen content.")
    }

    // son eklemeler
    func textViewDidBeginEditing(_ ruyaTextView: UITextView) {

        if ruyaTextView.text == "Rüyanızı buraya girebilirsiniz :)" {
            ruyaTextView.text = ""
            ruyaTextView.textColor = .black
        }
    }

    // Klavye Gizleme
    @objc func hideKeyboard() {
        view.endEditing(false)
    }

    @objc func addButtonClicked() {
        performSegue(withIdentifier: "recordedDreams", sender: nil)
    }

    @IBAction func saveButton(_ sender: Any) {

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext

        let newDream = NSEntityDescription.insertNewObject(forEntityName: "Dreams", into: context)

        // Attributes

        newDream.setValue(duyguText.text!, forKey: "duygu")
        newDream.setValue(baslıkText.text!, forKey: "baslik")
        newDream.setValue(ruyaTextView.text!, forKey: "ruya") 

        if let tarihString = tarihText.text, let tarihNumber = Int(tarihString) {
            newDream.setValue(NSNumber(value: tarihNumber), forKey: "tarih")
        }

        newDream.setValue(UUID(), forKey: "id")
        do {
            try context.save()
            print("Success")
        } catch {
            print("Hata Var")
        }

        NotificationCenter.default.post(name: NSNotification.Name("newData"), object: nil)
        self.navigationController?.popViewController(animated: true)

        if interstitial != nil {
            interstitial!.present(fromRootViewController: self)
        } else {
            print("Ad wasn't ready")
        }
    }


    @objc func dokumaAlgilama() {
        view.endEditing(true)
    }
}
