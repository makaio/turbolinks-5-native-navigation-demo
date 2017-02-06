import UIKit
import SwiftyJSON

/* 
 We'll use a simple TableView to render our menu. It may not be the best way to get things done, but it does a great job of showing a list of menu items and letting us know when someone taps on one (when the selected index changes). That's all we need for a basic menu!
 */

class NavMenuController: UITableViewController {
    var navItems = JSON([])
    var applicationController: ApplicationController!
    
    func initNav(_ applicationController: ApplicationController, json: JSON) {
        navItems = json
        self.applicationController = applicationController

        tableView.reloadData()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return navItems.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        // For each rendered row, pull an item out of our navItems array (from the JSON) and use it's `title` property as the cell's textLabel.
        cell.textLabel!.text = navItems[indexPath.row]["title"].stringValue
        return cell
    }

    // When someone selects a row from our menu, figure out the URL for the selected item index and tell our applicationController to visit it, and don't forget to toggle the nav menu off.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let navPath = navItems[indexPath.row]["path"].stringValue

        let navUrl = URL(string: navPath)!
        applicationController.visit(navUrl)
        applicationController.toggleNav()
    }

}
