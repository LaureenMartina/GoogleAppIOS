//
//  ActionsTableViewController.swift
//  GoogleAppIOS
//
//  Created by laureen martina on 25/01/2020.
//  Copyright © 2020 laureen martina. All rights reserved.
//

import UIKit
import ApiAI
import WatchConnectivity

class DataOfCell{
    var nameSection: String
    var nameCell: [String]
    
    init(nameSection: String, nameCell: [String]){
        self.nameSection = nameSection
        self.nameCell = nameCell
    }
}


class ActionsTableViewController: UITableViewController {
        
    @IBOutlet var actionsTableView: UITableView!
    
    var dataOfCell = [DataOfCell]()
    var dataWelcome: [String] = ["Hello", "Salut", "Bonjour"]
    let indice = Int.random(in: 0 ..< 3)
    var indexRow = 0
    var session: WCSession?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureWatchKitSesstion()
        
        dataOfCell.append(DataOfCell.init(nameSection: "Chambre",
                                          nameCell: ["allume la lampe de la chambre",
                                                     "enlève la lumière de la pièce à coucher"]))
        dataOfCell.append(DataOfCell.init(nameSection: "Cuisine",
                                          nameCell: ["active le feu de la cuisine",
                                                     "éteint la plaque électrique dans la cuisine"]))
        dataOfCell.append(DataOfCell.init(nameSection: "Toilette",
                                          nameCell: ["enclenche le chauffage des toilettes",
                                                     "met le radiateur sur off des WC"]))
        dataOfCell.append(DataOfCell.init(nameSection: "Salon",
                                          nameCell: ["allume l'ordi du salon",
                                                     "éteint la télé"]))
        
        let request = ApiAI.shared().textRequest()
        
        request?.query = dataWelcome[indice]
        
        ApiAI.shared().enqueue(request)
        
        request?.setMappedCompletionBlockSuccess({ (request, response) in
            let response = response as! AIResponse
            
            if let textResponse = response.result.fulfillment.speech {
                //print("poulet:", textResponse)
                
                if let validSession = self.session {
                    let data: [String: Any] = ["Response": textResponse as Any]
                    validSession.transferUserInfo(data)
                }
            }
            
        }, failure: { (request, error) in
            print(error!)
        })
    
    }
    

    func configureWatchKitSesstion() {
        
        if WCSession.isSupported() {
            session = WCSession.default
        }
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.dataOfCell.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataOfCell[section].nameCell.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableActions", for: indexPath) as UITableViewCell
        cell.textLabel?.text = self.dataOfCell[indexPath.section].nameCell[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.dataOfCell[section].nameSection
    }
    
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        //print("Row \(indexPath.row) selected")
        return true
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        indexRow = indexPath.row
        
        let request = ApiAI.shared().textRequest()
        
        request?.query = self.dataOfCell[indexPath.section].nameCell[indexPath.row]
        
        request?.setMappedCompletionBlockSuccess({ (request, response) in
            let response = response as! AIResponse
            
            if let textResponse = response.result.fulfillment.speech {
                //print("poulet:", textResponse)
                  
                if let validSession = self.session {
                    let data: [String: Any] = ["Response": textResponse as Any]
                    validSession.transferUserInfo(data)
                }
            }
            
        }, failure: { (request, error) in
            print(error!)
        })
        
        ApiAI.shared().enqueue(request)
    }
}
