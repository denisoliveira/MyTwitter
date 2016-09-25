//
//  TimelineViewController.swift
//  MyTwitter
//
//  Created by Denis Oliveira on 9/25/16.
//  Copyright © 2016 Denis Oliveira. All rights reserved.
//

import UIKit
import TwitterKit

class TimelineViewController: TWTRTimelineViewController {

    // let unwrappedSession:TWTRSession
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Twitter Logo
        let logo = UIImageView(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        logo.image = UIImage(named: "twitter")
        logo.contentMode = .scaleAspectFit
        self.navigationItem.titleView = logo
      
        // Left Button
        let tweet = UIBarButtonItem(title: "Tweet", style: .plain, target: self, action: #selector(tweetTap(sender:)))
        self.navigationItem.leftBarButtonItem = tweet
        
        // Right Button
        let perfil = UIBarButtonItem(title: "Perfil", style: .plain, target: self, action: #selector(perfilTap(sender:)))
        self.navigationItem.rightBarButtonItem = perfil
        
        // Setup
        let store = Twitter.sharedInstance().sessionStore
        let client = TWTRAPIClient(userID: store.session()?.userID)
        
        client.loadUser(withID: (store.session()?.userID)!) { (user:TWTRUser?, error:Error?) in
            print(user?.profileImageURL)
            self.dataSource = TWTRUserTimelineDataSource(screenName:(user?.screenName)!, apiClient: client)
        }

        self.showTweetActions = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tweetTap(sender:Any?) -> Void {
        let composer = TWTRComposer()
        composer.setText("")
        composer.show(from: self) { (result:TWTRComposerResult) in
            if result == .cancelled {
                print("Tweet cancelado.")
            } else {
                print("Tweet enviado.")
            }
        }
    }

    @IBAction func perfilTap(sender:Any?) -> Void {
        let viewController = ProfileViewController()
        self.navigationController?.show(viewController, sender: self)
    }
}
