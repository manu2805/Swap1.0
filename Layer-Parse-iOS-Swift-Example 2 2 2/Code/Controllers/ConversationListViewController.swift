import UIKit

class ConversationListViewController: ATLConversationListViewController, ATLConversationListViewControllerDelegate, ATLConversationListViewControllerDataSource {
    
    var tmp = "lol"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.dataSource = self
        self.delegate = self
        
        //self.navigationController!.navigationBar.tintColor = ATLBlueColor()
        configureNavigationBar()
        
        let title = NSLocalizedString("Logout", comment: "")
        let logoutItem = UIBarButtonItem(title: title, style: UIBarButtonItemStyle.Plain, target: self, action: Selector("logoutButtonTapped:"))
        self.navigationItem.setLeftBarButtonItem(logoutItem, animated: false)

        //let composeItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Compose, target: self, action: Selector("composeButtonTapped:"))
        //self.navigationItem.setRightBarButtonItem(composeItem, animated: false)
        self.layerClient = mainLayerClient.layerClient
        
    }
    
    func configureNavigationBar() {
        navigationController?.navigationBar.barTintColor = UIColor(red: 239/255, green: 76/255, blue: 42/255, alpha: 1.0)
        navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "HelveticaNeue-Thin", size: 30)!,NSForegroundColorAttributeName : UIColor.whiteColor()]
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    init() {
        super.init(layerClient: mainLayerClient.layerClient)
    }

    required init(coder: NSCoder) {
        super.init(coder: coder)
    }

    
    func testing() {
        self.tabBarController?.selectedIndex = 3
        let controller = ConversationViewController(layerClient: mainLayerClient.layerClient)
        //controller.conversation = conversation
        controller.displaysAddressBar = true
        controller.hidesBottomBarWhenPushed = true
        self.navigationController!.pushViewController(controller, animated: true)
    }
    // MARK - ATLConversationListViewControllerDelegate Methods

    func conversationListViewController(conversationListViewController: ATLConversationListViewController, didSelectConversation conversation:LYRConversation) {
        let unresolvedParticipants: NSArray = UserManager.sharedManager.unCachedUserIDsFromParticipants(Array(conversation.participants))
        /* if unresolvedParticipants.count == 0 {
            let controller = ConversationViewController(layerClient: mainLayerClient.layerClient)
            controller.conversation = conversation
            controller.displaysAddressBar = true
            controller.hidesBottomBarWhenPushed = true
            self.navigationController!.pushViewController(controller, animated: true)
            println("Tapped")

        } else {
            let controller = ConversationViewController(layerClient: mainLayerClient.layerClient)
            controller.conversation = conversation
            controller.displaysAddressBar = true
            controller.hidesBottomBarWhenPushed = true
            self.navigationController!.pushViewController(controller, animated: true)
            println("Tapped")
        } */
        
        let controller = ConversationViewController(layerClient: mainLayerClient.layerClient)
        controller.conversation = conversation
        controller.displaysAddressBar = true
        controller.hidesBottomBarWhenPushed = true
        self.navigationController!.pushViewController(controller, animated: true)
    }
    
    func conversationListViewController(conversationListViewController: ATLConversationListViewController, didDeleteConversation conversation: LYRConversation, deletionMode: LYRDeletionMode) {
        println("Conversation deleted")
    }

    func conversationListViewController(conversationListViewController: ATLConversationListViewController, didFailDeletingConversation conversation: LYRConversation, deletionMode: LYRDeletionMode, error: NSError?) {
        println("Failed to delete conversation with error: \(error)")
    }

    func conversationListViewController(conversationListViewController: ATLConversationListViewController, didSearchForText searchText: String, completion: ((Set<NSObject>!) -> Void)?) {
        UserManager.sharedManager.queryForUserWithName(searchText) { (participants: NSArray?, error: NSError?) in
            if error == nil {
                if let callback = completion {
                    callback(NSSet(array: participants as! [AnyObject]) as Set<NSObject>)
                }
            } else {
                if let callback = completion {
                    callback(nil)
                }
                println("Error searching for Users by name: \(error)")
            }
        }
    }
    

    // MARK - ATLConversationListViewControllerDataSource Methods

    func conversationListViewController(conversationListViewController: ATLConversationListViewController, titleForConversation conversation: LYRConversation) -> String {
        if conversation.metadata["title"] != nil {
            return conversation.metadata["title"] as! String
        } else {
            let listOfParticipant = Array(conversation.participants)
            let unresolvedParticipants: NSArray = UserManager.sharedManager.unCachedUserIDsFromParticipants(listOfParticipant)
            let resolvedNames: NSArray = UserManager.sharedManager.resolvedNamesFromParticipants(listOfParticipant)
            
            if (unresolvedParticipants.count > 0) {
                UserManager.sharedManager.queryAndCacheUsersWithIDs(unresolvedParticipants as! [String]) { (participants: NSArray?, error: NSError?) in
                    if (error == nil) {
                        if (participants?.count > 0) {
                            self.reloadCellForConversation(conversation)
                        }
                    } else {
                        println("Error querying for Users: \(error)")
                    }
                }
            }
            
            if (resolvedNames.count > 0 && unresolvedParticipants.count > 0) {
                let resolved = resolvedNames.componentsJoinedByString(", ")
                return "\(resolved) and \(unresolvedParticipants.count) others"
            } else if (resolvedNames.count > 0 && unresolvedParticipants.count == 0) {
                return resolvedNames.componentsJoinedByString(", ")
            } else {
                return "Conversation with \(conversation.participants.count) users..."
            }
        }
    }

    // MARK - Actions

    func composeButtonTapped(sender: AnyObject) {
       /* let controller = ConversationViewController(layerClient: self.layerClient)
        controller.displaysAddressBar = true
        self.navigationController!.pushViewController(controller, animated: true) */
    }

    func logoutButtonTapped(sender: AnyObject) {
        println("logOutButtonTapAction")
        
        self.layerClient.deauthenticateWithCompletion { (success: Bool, error: NSError?) in
            if error == nil {
                PFUser.logOut()
                //var  appDelegateTemp = UIApplication.sharedApplication().delegate
                var rootController: UIViewController! = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("ViewController") as! UIViewController
                self.switchRootViewController(rootController, animated: true, completion: nil)
                
                
            } else {
                println("Failed to deauthenticate: \(error)")
            }
        }
    }
    
    
    func switchRootViewController(rootViewController: UIViewController, animated: Bool, completion: (() -> Void)?) {
        if animated {
            UIView.transitionWithView(UIApplication.sharedApplication().keyWindow!, duration: 0.5, options: .TransitionCrossDissolve, animations: {
                let oldState: Bool = UIView.areAnimationsEnabled()
                UIView.setAnimationsEnabled(false)
                UIApplication.sharedApplication().keyWindow!.rootViewController = rootViewController
                UIView.setAnimationsEnabled(oldState)
                }, completion: { (finished: Bool) -> () in
                    if (completion != nil) {
                        completion!()
                    }
            })
        } else {
            UIApplication.sharedApplication().keyWindow!.rootViewController = rootViewController
        }
    }
}
