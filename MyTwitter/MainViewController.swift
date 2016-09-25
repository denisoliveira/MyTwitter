//
//  MainViewController.swift
//  MyTwitter
//
//  Created by Denis Oliveira on 9/25/16.
//  Copyright © 2016 Denis Oliveira. All rights reserved.
//

import UIKit
import TwitterKit

class MainViewController: UIViewController {
    
    @IBOutlet var stackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Twitter Logo
        let logo = UIImageView(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        logo.image = UIImage(named: "twitter")
        logo.contentMode = .scaleAspectFit
        self.navigationItem.titleView = logo
        
        // Twitter Login Button
        let logInButton = TWTRLogInButton { (session, error) in
            if let unwrappedSession = session {
                let alert = UIAlertController(title: "Login",
                                              message: "Usuário \(unwrappedSession.userName) foi logado.",
                    preferredStyle: .alert
                )
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
                    let viewController = TimelineViewController()
                    self.navigationController?.pushViewController(viewController, animated: true)
                }))
                self.present(alert, animated: true, completion: nil)
            } else {
                debugPrint("Login error: %@", error!.localizedDescription);
            }
        }
        
        self.stackView.addArrangedSubview(logInButton)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

