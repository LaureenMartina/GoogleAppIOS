//
//  ViewController.swift
//  GoogleAppIOS
//
//  Created by laureen martina on 19/01/2020.
//  Copyright © 2020 laureen martina. All rights reserved.
//

import UIKit
import ApiAI
import WatchConnectivity

class ViewController: UIViewController {
    
    var session: WCSession?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureWatchKitSesstion()
    }
    
    
    func configureWatchKitSesstion() {
        
        if WCSession.isSupported() {
            session = WCSession.default
        }
    }
    
    
    @IBAction func actionOne(_ sender: Any) {
        let request = ApiAI.shared().textRequest()
        
        request?.query = "allume la lumière du salon"
        
        ApiAI.shared().enqueue(request)
        
        request?.setMappedCompletionBlockSuccess({ (request, response) in
            let response = response as! AIResponse
            
            if let textResponse = response.result.fulfillment.speech {
                print("poulet:", textResponse)
                
                if let validSession = self.session {
                    let data: [String: Any] = ["Response": textResponse as Any]
                    validSession.transferUserInfo(data)
                }
            }
            
        }, failure: { (request, error) in
            print(error!)
        })
    }

}
