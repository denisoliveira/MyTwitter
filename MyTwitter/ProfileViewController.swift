//
//  ProfileViewController.swift
//  MyTwitter
//
//  Created by Denis Oliveira on 9/25/16.
//  Copyright © 2016 Denis Oliveira. All rights reserved.
//

import UIKit
import TwitterKit

class ProfileViewController: UIViewController {
    
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var profileLabel: UILabel!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var bioTextField: UITextField!
    @IBOutlet var websiteTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        // Twitter Logo
        let logo = UIImageView(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        logo.image = UIImage(named: "twitter")
        logo.contentMode = .scaleAspectFit
        self.navigationItem.titleView = logo
        
        // Right Button
        let udpateButton = UIBarButtonItem(title: "Update", style: .plain, target: self, action: #selector(updateTap(sender:)))
        self.navigationItem.rightBarButtonItem = udpateButton
        
        // Setup
        let store = Twitter.sharedInstance().sessionStore
        let client = TWTRAPIClient(userID: store.session()?.userID)
        
        client.loadUser(withID: (store.session()?.userID)!) { (user:TWTRUser?, error:Error?) in
            let url = URL(string: (user?.profileImageLargeURL)!)
            do {
                let data = try? Data(contentsOf: url!)
                self.profileImageView?.image = UIImage(data: data!)
            }
            self.nameTextField?.text = user?.name
            if let screenName = user?.screenName {
                self.profileLabel?.text = "@\(screenName)"
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func updateTap(sender:Any?) -> Void {
        if let name = self.nameTextField?.text {
            let statusesShowEndpoint = "https://api.twitter.com/1.1/account/update_profile.json"
            let store = Twitter.sharedInstance().sessionStore
            let client = TWTRAPIClient(userID: store.session()?.userID)
            
            let params = ["name": name]
            var clientError:NSError?
            
            let request = client.urlRequest(withMethod: "POST", url: statusesShowEndpoint, parameters: params, error: &clientError)

            client.sendTwitterRequest(request) { (response, data, connectionError) -> Void in
                if connectionError != nil {
                    print("Error: \(connectionError)")
                }
                do {
                    if let raw = data {
                        let json = try JSONSerialization.jsonObject(with: raw, options: [])
                        let alert = UIAlertController(title: "Update",
                                                      message: "Perfil atualizado.",
                            preferredStyle: .alert
                        )
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        print("json: \(json)")
                    }
                } catch let jsonError as NSError {
                    let alert = UIAlertController(title: "Update",
                                                  message: "Perfil não atualizado.",
                                                  preferredStyle: .alert
                    )
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    print("json error: \(jsonError.localizedDescription)")
                }
            }
        }
    }
}
