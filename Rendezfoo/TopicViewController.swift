//
//  TopicViewController.swift
//  Rendezfoo
//
//  Created by Adil Ansari on 7/17/16.
//  Copyright © 2016 Adil Ansari. All rights reserved.
//


/* View controller per topic, will list topics in a tableview -- list the root node
 for each topic videocontainer, selecting cell will allow the user to navigate the 
 tree that stems from root.
 */

class TopicViewController: UIViewController, UserDelegate, CameraViewControllerDelegate, UITableViewDelegate, UITableViewDataSource, VideoContainerDelegate, VideoViewControllerDelegate {
    var myTopic:PFObject!
    var addFavorite:UIBarButtonItem!
    var myUser = User()
    var dataArray:[PFObject] = []
    var videoCont:VideoContainer = VideoContainer()
    var storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)

    @IBOutlet var mainTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainTableView.delegate = self
        mainTableView.dataSource = self
        videoCont.delegate = self
        
        videoCont.queryByTopic(myTopic.objectId!)
        let root = UIBarButtonItem(title: "R", style: .Plain, target: self, action: #selector(rootTapped))
        let chat = UIBarButtonItem(title: "M", style: .Plain, target: self, action: #selector(chatTapped))
        let favorites = UIBarButtonItem(title: "F", style: .Plain, target: self, action: #selector(favoritesTapped))
        navigationItem.leftBarButtonItems = [root, chat, favorites]
        
        
        navigationItem.leftBarButtonItems = [root, chat, favorites]
        
        self.addFavorite = UIBarButtonItem(title: "*", style: .Plain, target: self, action: #selector(favoriteAddedTapped))
        navigationItem.rightBarButtonItems = [addFavorite]
        
        
        myUser.delegate = self
        myUser.topicInFavorites(myTopic)
        


        self.navigationItem.title = myTopic["topic"] as? String

        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated) 
    }
    
    func favoriteAddedTapped() {
        myUser.addFavorite(myTopic)
    }

    func rootTapped() {
        self.navigationController?.popToRootViewControllerAnimated(false)
    }
    
    func chatTapped() {
        
    }
    
    func favoritesTapped() {
        let favoritesViewController = self.storyBoard.instantiateViewControllerWithIdentifier("FavoritesViewController") as! FavoritesViewController
        self.navigationController?.pushViewController(favoritesViewController, animated: false)

    }
    
    @IBAction func cameraTapped(sender: AnyObject) {
        let cameraViewController = CameraViewController()
        cameraViewController.delegate = self
        cameraViewController.parent = "None"
        cameraViewController.topic = myTopic.objectId
        self.presentViewController(cameraViewController, animated: true, completion: nil)
    }
    
    func presentVideoViewController(videoCont:PFObject) {
        let videoViewController = self.storyBoard.instantiateViewControllerWithIdentifier("VideoViewController") as! VideoViewController
        videoViewController.videoContainer = videoCont
        videoViewController.delegate = self
        videoViewController.direction = "LR"
        self.presentViewController(videoViewController, animated: false, completion: nil)
        
    }

    
    //MARK -- Table view Delegate methods
    
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
        let videoContainer:PFObject = dataArray[indexPath.row]
        cell.textLabel?.text = videoContainer.objectId
        
        return cell
        
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let myVideoContainer:PFObject = dataArray[indexPath.row]
        presentVideoViewController(myVideoContainer)
        
    }
    
   
    //MARK -- UserDelegate Methods
    
    func topicIsInFavorites(myTopic: PFObject) {
        navigationItem.rightBarButtonItem = nil
        //
    }
    
    func topicNotInFavorites(myTopic: PFObject) {
        //
        navigationItem.rightBarButtonItems = [addFavorite]

    }
    
    func videoContainersForTopic(videoContainers: [PFObject]) {
        self.dataArray = videoContainers
        mainTableView.reloadData()
    }
    
    
    //MARK -- CameraViewControllerDelegate Methods
    
    func dismissCameraViewController() {
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    
    func dismissCameraVideoMade(videoCont: PFObject) {
        self.dismissViewControllerAnimated(false, completion: {
            
            self.presentVideoViewController(videoCont)
           
        })

    }
    
    
    //MARK -- VideoViewController Delegate Methods
    
    func displayRoot() {
        
        dismissViewControllerAnimated(false, completion: {
            self.rootTapped()
        })
    }
    
    func displayFavorites() {
        dismissViewControllerAnimated(false, completion: {
            self.favoritesTapped()
        })
        
    }
    
    func displayTopic() {
        dismissViewControllerAnimated(false, completion: nil)

    }

}
