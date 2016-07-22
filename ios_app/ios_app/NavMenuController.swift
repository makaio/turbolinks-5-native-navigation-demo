import UIKit
import SwiftyJSON

/* 
 We'll use a simple TableView to render our menu. It may not be the best way to get things done, but it does a great job of showing a list of menu items and letting us know when someone taps on one (when the selected index changes). That's all we need for a basic menu!
 */

class NavMenuController: UITableViewController {
    var navItems = JSON([])
    var applicationController: ApplicationController!
    
    func initNav(applicationController: ApplicationController, json: JSON) {
        navItems = json
        self.applicationController = applicationController

        tableView.reloadData()
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return navItems.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)

        // For each rendered row, pull an item out of our navItems array (from the JSON) and use it's `title` property as the cell's textLabel.
        cell.textLabel!.text = navItems[indexPath.row]["title"].stringValue
        return cell
    }

    // When someone selects a row from our menu, figure out the URL for the selected item index and tell our applicationController to visit it, and don't forget to toggle the nav menu off.
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let navPath = navItems[indexPath.row]["path"].stringValue

        let navUrl = NSURL(string: navPath)!
        applicationController.visit(navUrl)
        applicationController.toggleNav()
    }

}
