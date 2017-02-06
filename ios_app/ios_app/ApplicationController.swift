import UIKit
import Turbolinks
import SwiftyJSON
import WebKit

class ApplicationController: UINavigationController, UINavigationControllerDelegate, SessionDelegate, WKScriptMessageHandler {

    var visitableViewController: VisitableViewController!
    var navMenuController: NavMenuController!

    override func viewDidLoad() {
        super.viewDidLoad()

        delegate = self
        setupNavMenuSubview()

        startApplication()
    }

    // Turbolinks boilerplate
    func startApplication() {
        visit(URL(string: "http://localhost:3000")!)
    }
    
    // When Turbolinks trigers a page visit, create a new VisitableViewController (think of this like a Turbolinks page),
    // push it on to this controller's navigation stack, and visit the url.
    func visit(_ URL: Foundation.URL) {
        visitableViewController = VisitableViewController(url: URL)
        pushViewController(visitableViewController, animated: true)
        session.visit(visitableViewController)
    }
    
    
    // This delegate method is called when a new viewController is pushed on / popped off the navigation stack (including the initial view render).
    // We'll use it to programatically add our menu button to the view's navigationItem property so it shows up on the right side of the nav bar.
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        let callback = #selector(toggleNav)
        let menuButton = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: callback)
        viewController.navigationItem.rightBarButtonItem = menuButton
    }


    // This custom webViewConfiguration will tell Turbolinks to dispatch messages that JavaScript sends with `window.webkit.messageHandlers.ApplicationController.postMessage` to this class's userContentController delegate method below
    fileprivate lazy var webViewConfiguration: WKWebViewConfiguration = {
        let configuration = WKWebViewConfiguration()
        configuration.applicationNameForUserAgent = "iOSApp"
        configuration.userContentController.add(self, name: "ApplicationController")
        return configuration
    }()

    // Tell Turbolinks to use our custom webViewConfiguration
    fileprivate lazy var session: Session = {
        let session = Session(webViewConfiguration: self.webViewConfiguration)
        session.delegate = self
        return session
    }()

    // Whenever we receive a message from JavaScript, assume it's Nav data and update our Nav items
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if let dataFromString = (message.body as AnyObject).data(using: String.Encoding.utf8.rawValue, allowLossyConversion: false) {
            let json = JSON(data: dataFromString)
            navMenuController.initNav(self, json: json)
        }
    }
    
    
    // MARK: Session Delegate
    
    // Boilerplate Turbolinks setup
    func session(_ session: Session, didProposeVisitToURL URL: Foundation.URL, withAction action: Action) {
        visit(URL)
    }

    // Boilerplate Turbolinks setup
    func session(_ session: Session, didFailRequestForVisitable visitable: Visitable, withError error: NSError) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

        present(alert, animated: true, completion: nil)
    }
    

    // MARK: Navigation
    
    // This just toggles the nav menu visibility. It gets called when someone taps on a menu item in the nav view.
    func toggleNav() {
        navMenuController.view.isHidden = !navMenuController.view.isHidden
    }
    
    // This function creates an instance of NavMenuController and adds its view (the nav menu) as a child to this view.
    // It hides the view by default, and sets up some constraints to position it below this view's navigationBar.
    fileprivate func setupNavMenuSubview() {
        navMenuController = storyboard!.instantiateViewController(withIdentifier: "Nav") as! NavMenuController
        
        view.addSubview(navMenuController.view)
        navMenuController.view.layer.isHidden = true
        
        navMenuController.view.translatesAutoresizingMaskIntoConstraints = false
        navMenuController.view.layer.borderWidth = 1.0
        navMenuController.view.layer.borderColor = UIColor.black.cgColor
        
        view.addConstraint(NSLayoutConstraint(item: navMenuController.view,
            attribute: .height,
            relatedBy: .equal,
            toItem: nil,
            attribute: .height,
            multiplier: 1,
            constant: 400))
        
        view.addConstraint(NSLayoutConstraint(item: navMenuController.view,
            attribute: .leading,
            relatedBy: .equal,
            toItem: view,
            attribute: .leading,
            multiplier: 1,
            constant: 0))
        
        view.addConstraint(NSLayoutConstraint(item: navMenuController.view,
            attribute: .trailing,
            relatedBy: .equal,
            toItem: view,
            attribute: .trailing,
            multiplier: 1,
            constant: 0))
        
        view.addConstraint(NSLayoutConstraint(item: navMenuController.view,
            attribute: .top,
            relatedBy: .equal,
            toItem: navigationBar,
            attribute: .bottom,
            multiplier: 1,
            constant: 0))
    }
}

