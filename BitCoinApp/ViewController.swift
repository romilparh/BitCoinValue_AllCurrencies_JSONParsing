//
//  ViewController.swift
//  BitCoinApp
//
//  Created by Romil on 2018-07-26.
//  Copyright © 2018 Romil. All rights reserved.
//

import UIKit
import Alamofire            // 1. Import AlamoFire and SwiftyJson
import SwiftyJSON

class ViewController: UIViewController {

    @IBOutlet weak var switchCurrency: UISwitch!

    var objectDictionary = [String: String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func printData(_ sender: UIButton) {
        if(switchCurrency.isOn){
            let URL = "https://api.coindesk.com/v1/bpi/historical/close.json?start=2017-11-01&end=2018-02-12&currency=CNY"
            getCoinApp(url: URL)
            
        } else{
            let URL = "https://api.coindesk.com/v1/bpi/historical/close.json?start=2017-11-01&end=2018-02-12"
            getCoinApp(url: URL)
        }
    }
    
    func getCoinApp(url:String) {
        
        Alamofire.request(url, method: .get, parameters: nil).responseJSON {
            
            (response) in
            
            if response.result.isSuccess {
                if let dataFromServer = response.data {
                    
                    do {
                        let json = try JSON(data: dataFromServer)
                        
                        //print(json)
                        
                        
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


}

