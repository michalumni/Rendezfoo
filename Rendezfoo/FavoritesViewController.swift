//
//  FavoritesViewController.swift
//  Rendezfoo
//
//  Created by Adil Ansari on 7/17/16.
//  Copyright © 2016 Adil Ansari. All rights reserved.
//


 /*
    This class shows the favorite topics for the user -- easy access for the topics the user
    wants to navigate back to constantly.  This view controller will simply be a tableview
 
 */
class FavoritesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UserDelegate {
    
    var dataArray:[PFObject] = []
    var myUser = User()
    
    @IBOutlet var mainTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.contentInset = UIEdgeInsetsZero;
        myUser.delegate = self
        myUser.queryFavorites()
        
        let root = UIBarButtonItem(title: "R", style: .Plain, target: self, action: #selector(rootTapped))
        let messages = UIBarButtonItem(title: "M", style: .Plain, target: self, action: #selector(messagesTapped))
        navigationItem.leftBarButtonItems = [root, messages]

        
    }
    
    func messagesTapped() {
        
    }
    
    func rootTapped() {
        self.navigationController?.popToRootViewControllerAnimated(false)
    }
    

    //MARK TableViewDelegate methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        return dataArray.count
    }
    
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell:UITableViewCell = UITableViewCell()
        let topic:PFObject = dataArray[indexPath.row]
        cell.textLabel?.text = topic["topic"] as? String
        
        return cell
        
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let myTopic:PFObject = dataArray[indexPath.row]
        let myDict = ["topic": myTopic]
        NSNotificationCenter.defaultCenter().postNotificationName("favoriteSelected", object: myDict)
        
        
    }

    //MARK UserDelegate methods
    
    func userFavoriteTopics(topics:[PFObject]) {
        dataArray = topics
        mainTableView.reloadData()
    }

}
