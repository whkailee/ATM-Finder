//
//  MapViewController.swift
//  ATMFinder
//
//  Created by Steven Li on 21/07/16.
//  Copyright © 2016 Xinc. All rights reserved.
//

import UIKit

class MapViewController: UIViewController {
    
    private var cachedLocations = Array<Location>();

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Map"
        
        getLocations()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getLocations() {
        
        let request = NSMutableURLRequest()
        request.URL = NSURL(string: "https://api.asb.co.nz/public/v1/locations?apikey=l7xxe3e8e66f6fdb47ac830eed54ca875f37&view=geosummary")
        request.HTTPMethod = "GET"
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        session.dataTaskWithRequest(request) { (data: NSData?, response: NSURLResponse?, error: NSError?) in
            
            if let data = data {
                
                do {
                    let json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers)
                    
                    let objects: NSArray = json.valueForKey("value") as! NSArray
                    
                    for obj: AnyObject in objects {
                        if let location = obj as? NSDictionary {
                            if let type = location.objectForKey("type") as? NSString {
                                if (type == "atm") {
                                    let atm: ATM = ATM()
                                    atm.setValuesForKeysWithDictionary(location as! [String : AnyObject])
                                    self.cachedLocations.append(atm)
                                }
                                else if (type == "branch") {
                                    let branch: Branch = Branch()
                                    branch.setValuesForKeysWithDictionary(location as! [String : AnyObject])
                                    self.cachedLocations.append(branch)
                                }
                            }
                        }
                    }
                    
                }
                catch {
                    
                }
            }
        }.resume()

    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
