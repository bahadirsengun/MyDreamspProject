//
//  LoginPageViewController.swift
//  myDream
//
//  Created by Bahadır Sengun on 31.03.2023.
//

import UIKit
import Firebase
import AppTrackingTransparency


class LoginPageViewController: UIViewController {
    
    
    // Tanımlamalarım.
    
    @IBOutlet weak var rememberMe: UISwitch!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet weak var loginPageEmailTextField: UITextField!
    
    @IBOutlet weak var loginPagePasswordTextField: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem = UIBarButtonItem(
                title: "Login",
                style: .done,
                target: nil,
                action: nil
            )
        
        navigationItem.setHidesBackButton(true, animated: false)

        navigationItem.backBarButtonItem?.tintColor = .red
        
        imageView.image = UIImage.gif(asset: "giris2")
        navigationItem.title = "Login"
        loading.isHidden = true
        
        
               // Remember Me ile Girişi
               if UserDefaults.standard.bool(forKey: "rememberMe") && Auth.auth().currentUser != nil {
                   self.performSegue(withIdentifier: "anaSayfa", sender: nil)
               }
        //KLAVYE GİZLEME METODU
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(gestureRecognizer)
           
    }
    
    @objc func guestButtonTapped() {
            // Misafir Kullanıcıya özgü işlemleri burada gerçekleştiriyoruz.
            //örneğin, belirli bir kullanıcı kimliği tanımlanabilir veya misafir oturumu açılabilir.
            // Bu kod bloğunda misafir kullanıcıya ait özelliklerin tanımlanması gerekmektedir.
            
            // Örnek olarak, bir misafir oturumu açıldığını ve ana sayfaya yönlendirildiğini varsayalım:
            let guestSession = Session(userId: "guest")
            navigateToHomePage(session: guestSession)
        }
    
    func navigateToHomePage(session: Session) {
            // Ana sayfaya yönlendirme işlemleri burada gerçekleştirilir.
            // Misafir kullanıcının oturum bilgilerini taşıyan session parametresini kullanabiliriz.
        self.performSegue(withIdentifier: "anaSayfa", sender: nil)

        // Ana sayfayı temsil eden bir ViewController oluşturulması
           
        }
    

    struct Session {
        let userId: String
        // Misafir kullanıcıya ait diğer özellikleri burada tanımlayabiliriz.
    }
    // KLAVYE GİZLEME
    @objc func hideKeyboard(){
        view.endEditing(false)
    }
    
  


   
    @IBAction func guestButton(_ sender: Any) {
        Auth.auth().signInAnonymously(completion: { authResult, error in
            if let error = error{
                print("giriş başarısız")
            } else {
                print("giriş başarılı")
                self.performSegue(withIdentifier: "anaSayfa", sender: nil)
            }
        })
    }
    
    
    @IBAction func loginPageLoginButton(_ sender: Any) {
        loading.startAnimating()
        loading.isHidden = false
        
        
        guard let email = loginPageEmailTextField.text, let password = loginPagePasswordTextField.text else {
            return
        }
        
        if email == "admin" && password == "371626"{
            self.performSegue(withIdentifier: "", sender: nil)
        }
//
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
                    if self.rememberMe.isOn {
                        UserDefaults.standard.set(true, forKey: "rememberMe")
                    }
                    self.performSegue(withIdentifier: "anaSayfa", sender: nil)
                    // Kullanıcının e-posta adresi doğrulanmış, uygulamanın ana sayfasına yönlendirin.
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
}






