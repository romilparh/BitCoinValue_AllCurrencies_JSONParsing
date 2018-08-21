//
//  TableViewController.swift
//  BitCoinApp
//
//  Created by Romil on 2018-07-26.
//  Copyright © 2018 Romil. All rights reserved.
//

import UIKit
import Alamofire            // 1. Import AlamoFire and SwiftyJson
import SwiftyJSON

class TableViewController: UITableViewController {

    var dataDictionary = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        getCurrencyArray(url: "https://api.coindesk.com/v1/bpi/supported-currencies.json")
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.dataDictionary.count
    }

   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)

        cell.textLabel?.text = self.dataDictionary[indexPath.row]

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // show the row number
        print(indexPath.row)
        
        // show what's actually in the row
        print(self.dataDictionary[indexPath.row])
        let url = "https://api.coindesk.com/v1/bpi/historical/close.json?start=2017-11-01&end=2018-02-12&currency=" + self.dataDictionary[indexPath.row]
        getCoinApp(url: url)
        
    }
    
    func getCoinApp(url:String) {
        
        Alamofire.request(url, method: .get, parameters: nil).responseJSON {
            
            (response) in
            
            if response.result.isSuccess {
                if let dataFromServer = response.data {
                    
                    do {
                        let json = try JSON(data: dataFromServer)
                        
                        print(json)
                        
                        
                        let dataDictionary = json["bpi"].dictionaryValue
                        
                        for (key, value) in dataDictionary{
                            print("------------------")
                            print(key)
                            print(value)
                            print("------------------")
                        }
                        
                        print("------------------")
                        print("Maximum Value over Time Period")
                        print(dataDictionary.values.max()!)
                        print("------------------")
                        
                        print("------------------")
                        print("Minimum Value over Time Period")
                        print(dataDictionary.values.min()!)
                        print("------------------")
                        
                        var average: Double = 0;
                        for (key, value) in dataDictionary{
                            average = average + Double(value.stringValue)!
                        }
                        print(average)
                        average = average/Double(dataDictionary.count)
                        
                        print("------------------")
                        print("Average Value over Time Period")
                        print(average)
                        print("------------------")
                    }
                    catch {
                        print("error")
                    }
                    
                }
                else {
                    print("Error when getting JSON from the response")
                }
            }
            else {
                print("Error while fetching data from URL")
            }
            
        }
        
        
    }
    
    func getCurrencyArray(url:String) {
        
        Alamofire.request(url, method: .get, parameters: nil).responseJSON {
            
            (response) in
            
            if response.result.isSuccess {
                if let dataFromServer = response.data {
                    
                    do {
                        let json = try JSON(data: dataFromServer)
                        
                        print(json)
                        
                        let jsonArray = try JSONSerialization.jsonObject(with: dataFromServer) as! [[String: String]]
                    
                        
                        
                        for j in jsonArray{
                            let x = j["currency"]
                            self.dataDictionary.append(x!)
                            print("Value:" + x!)
                        
                        }
                        
                        
                        
                      /*  for (key, value) in dataDictionary{
                            print("------------------")
                            print(key)
                            print(value)
                            print("------------------")
                        } */
                        
                        
                    }
                    catch {
                        print("error")
                    }
                    
                }
                else {
                    print("Error when getting JSON from the response")
                }
            }
            else {
                print("Error while fetching data from URL")
            }
            self.tableView.reloadData()
        }
        
        
    }

}
