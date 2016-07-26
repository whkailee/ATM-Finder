//
//  MainMenuTableViewController.swift
//  ATMFinder
//
//  Created by Steven Li on 21/07/16.
//  Copyright © 2016 Xinc. All rights reserved.
//

import UIKit

class MainMenuTableViewController: UITableViewController {
    
    private var menus = Array<String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Menu"

        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false

        menus.append("Settings")
        menus.append("Map")
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
        
        self.view.backgroundColor = UIColor.blackColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return menus.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)
        
        cell.backgroundColor = UIColor(patternImage: UIImage(named: "bg")!)

        cell.textLabel?.text = menus[indexPath.row]
        cell.textLabel?.textColor = UIColor.whiteColor()
        
        let selectedBackgroundView = UIView()
        selectedBackgroundView.backgroundColor = UIColor(white: 0.1, alpha: 0.4)
        
        cell.selectedBackgroundView = selectedBackgroundView

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch menus[indexPath.row] {
        case "Settings":
            self.performSegueWithIdentifier("showSettings", sender: self)
            break
        case "Map":
            self.performSegueWithIdentifier("showMap", sender: self)
            break
        default:
            break
            
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
}
