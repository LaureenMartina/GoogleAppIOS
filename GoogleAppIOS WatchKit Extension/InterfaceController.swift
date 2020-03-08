//
//  InterfaceController.swift
//  GoogleAppIOS WatchKit Extension
//
//  Created by laureen martina on 19/01/2020.
//  Copyright © 2020 laureen martina. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class InterfaceController: WKInterfaceController {

    @IBOutlet weak var responseGoogleAssistant: WKInterfaceLabel!
    //var delegate: ExtensionDelegate?
    let session = WCSession.default
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        session.delegate = self
        session.activate()
        
        guard session.isReachable else {
            print("déconnecté iphone")
            return // iphone pas là
        }
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}

extension InterfaceController: WCSessionDelegate {

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    }

    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {
        print("received data: \(userInfo)")

        if let value = userInfo["Response"] as? String {
            self.responseGoogleAssistant.setText(value)
        }
    }
}
