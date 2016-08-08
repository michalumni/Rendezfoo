//
//  MainViewController.swift
//  Rendezfoo
//
//  Created by Adil Ansari on 7/15/16.
//  Copyright © 2016 Adil Ansari. All rights reserved.
//


 /*
    Landing page for app -- currently searchbar + tableview 
    TODO add list of trending topics
    Change to use searchbarviewcontroller 
 
 */

class MainViewController: UIViewController, CreateTopicViewControllerDelegate, UISearchBarDelegate, UITableViewDelegate, TopicDelegate, UITableViewDataSource {
    var storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)

    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var mainTableView: UITableView!
    var dataArray:[PFObject] = []
    var topic:Topic = Topic() 

    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MainViewController.favoriteSelected(_:)), name: "favoriteSelected", object: nil)

        searchBar.delegate = self
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.contentInset = UIEdgeInsetsZero;
        topic.delegate = self
        

        
        
        let createChannel = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(addTapped))
        let chat = UIBarButtonItem(title: "M", style: .Plain, target: self, action: #selector(chatTapped))
        let favorites = UIBarButtonItem(title: "F", style: .Plain, target: self, action: #selector(favoritesTapped))

        navigationItem.rightBarButtonItems = [createChannel]
        navigationItem.leftBarButtonItems = [chat, favorites]
        
        

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        searchBar.becomeFirstResponder()
    }
    
    func chatTapped() {
        
    }
    
    func favoritesTapped() {
        let favoritesViewController = self.storyBoard.instantiateViewControllerWithIdentifier("FavoritesViewController") as! FavoritesViewController
        self.navigationController?.pushViewController(favoritesViewController, animated: false)


    }
    

    
    func addTapped() {
        let createTopicViewController = self.storyBoard.instantiateViewControllerWithIdentifier("CreateTopicViewController") as! CreateTopicViewController
        
       
        createTopicViewController.delegate = self
        createTopicViewController.modalPresentationStyle = UIModalPresentationStyle.OverFullScreen

        self.presentViewController(createTopicViewController, animated: true, completion: nil)

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
        presentTopicViewController(myTopic)
        
    }
    
    // Mark -- SearchBarDelegate methods
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchText != "") {
            topic.queryTopicStartingWith(searchText)
        }
            //print(searchBar.text)

    }
    
    // Mark -- TopicDelegate Methods
    
    func topicQueryResults(topics:[PFObject]) {
        dataArray = topics
        mainTableView.reloadData()
    }
    
    func favoriteSelected(notification:NSNotification) {
        guard let myDict = notification.object as? [String:AnyObject] else {
            return
        }
        
        guard let myTopic = myDict["topic"] as? PFObject else {
            return
        }
        
        self.navigationController?.popToRootViewControllerAnimated(false)
        self.presentTopicViewController(myTopic)
    }

    
    
   // MARK -- CreateTopicViewControllerDelegate methods
    
    func dismissAndShowTopic(myTopic:PFObject) {
        dismissViewControllerAnimated(true, completion: {
            self.presentTopicViewController(myTopic)
        })
    }
    
    func dismissCreateTopic() {
        dismissViewControllerAnimated(false, completion: nil)
    }
    
    func presentTopicViewController(myTopic:PFObject) {
        let topicViewController = self.storyBoard.instantiateViewControllerWithIdentifier("TopicViewController") as! TopicViewController
        topicViewController.myTopic = myTopic
        self.navigationController?.pushViewController(topicViewController, animated: false)
        

        
        
    }
    
    
    
}
