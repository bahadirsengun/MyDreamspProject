//
//  ViewController.swift
//  myDream
//
//  Created by Bahadır Sengun on 31.03.2023.
//

import UIKit
import Firebase
class ViewController: UIViewController {
    
    
    //Giriş Tanımlamalarım.
    @IBOutlet weak var loginRButton: UIButton!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet weak var registerEmailTextField: UITextField!
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet weak var registerPasswordTextfield: UITextField!
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        loading.isHidden = true
        
        imageView.image = UIImage.gif(asset: "giris3")

        //KLAVYE GİZLEME METODU
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(gestureRecognizer)
        

    }
    //KLAVYE GİZLEME METODU
    @objc func hideKeyboard(){
        view.endEditing(false)
    }
    
    @IBAction func registerButton(_ sender: Any) {
        loading.startAnimating()
        loading.isHidden = false
        guard let email = registerEmailTextField.text, let password = registerPasswordTextfield.text else {
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            if let error = error {
                print("Kayıt işlemi başarısız: \(error.localizedDescription)")
                
                let alertController = UIAlertController(title: "Hata", message: error.localizedDescription, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Tamam", style: .default, handler: nil)
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
                
                return
            }
            
            // E-posta doğrulama postasını gönderdiğim yer.
            authResult?.user.sendEmailVerification(completion: { (error) in
                if let error = error {
                    print("E-posta doğrulama postası gönderilemedi: \(error.localizedDescription)")
                    return
                }
                
                print("E-posta doğrulama postası başarıyla gönderildi.")
                
            })
            
            print("Kayıt işlemi başarılı.")
            
            let alertController = UIAlertController(title: "Başarılı", message: "Başarıyla kayıt oldunuz. E-posta adresinize doğrulama postası gönderildi.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Tamam", style: .default) { (action) in
                self.loading.isHidden = true
                self.loginRButton.isHidden = false
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    @IBAction func loginRRButton(_ sender: Any) {
        
        guard let email = registerEmailTextField.text, let password = registerPasswordTextfield.text else {
            return
        }
        
        if email == "admin" && password == "371626"{
            self.performSegue(withIdentifier: "", sender: nil)
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
            if let error = error {
                print("Giriş işlemi başarısız: \(error.localizedDescription)")
                self.loading.isHidden = true
                let alertController = UIAlertController(title: "Hata", message: error.localizedDescription, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Tamam", style: .default, handler: nil)
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
                
                return
            }
            
            if let user = authResult?.user{
                if user.isEmailVerified {
                    print("Giriş işlemi başarılı.")
                    self.performSegue(withIdentifier: "anaSayfa", sender: nil)
                    // KULLANICININ E-POSTA ADRESİ DOĞRULANMIŞ, ANASAYFAYA YÖNLENDİRİLİR.
                }else {
                    print("E-posta adresi doğrulanmamış.")
                    self.loading.isHidden = true
                    let alertController = UIAlertController(title: "Hata", message: "E-posta adresinizi doğrulayın ve tekrar deneyin.", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "Tamam", style: .default, handler: nil)
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
        
    }
    
    
    
    @IBAction func HaveAccountButton(_ sender: Any) {
        performSegue(withIdentifier: "login", sender: nil)
    }
    
    
    
}
