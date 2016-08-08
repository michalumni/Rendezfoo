//
//  VideoViewController.swift
//  Rendezfoo
//
//  Created by Adil Ansari on 7/18/16.
//  Copyright © 2016 Adil Ansari. All rights reserved.
//

import UIKit
protocol VideoViewControllerDelegate {
    func displayRoot()
    func displayFavorites()
    func displayTopic()
    
}

 /*
    Main video view controller, will resemble snapchat stories, click to show next video
    swipe in a direction to navigate video tree.
 */

class VideoViewController: UIViewController,  VideoContainerDelegate{
    var videoContainer:PFObject!
    var vidContClass:VideoContainer = VideoContainer()
    var direction:String!
    
    var delegate:VideoViewControllerDelegate?

    @IBOutlet var leftView: UIView!
    
    
    @IBOutlet var rightView: UIView!
    @IBOutlet var bottomView: UIView!
    
    @IBOutlet var topView: UIView!
    @IBOutlet var mainLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vidContClass.delegate = self
        vidContClass.queryPosition(videoContainer)
        mainLabel.text = videoContainer.objectId
        

        


    }
    

    
    @IBAction func rootTapped() {
        delegate?.displayRoot()
    
    }
    
    
    @IBAction func messagesTapped() {
    
    
    }
    
    
    @IBAction func favoritesTapped() {
        delegate?.displayFavorites()

    
    }
    
    
    @IBAction func replyTapped() {
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func dismissToTopic() {
        delegate?.displayTopic()
    }
    
    
    
    // MARK -- VideoContainerDelegate
    
    func isRoot() {
        if (direction == "LR") {
            self.leftView.backgroundColor = UIColor.blueColor()
            self.topView.backgroundColor = UIColor.redColor()
            self.bottomView.backgroundColor = UIColor.redColor()
            
            let swipeRight:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(VideoViewController.dismissToTopic))
            swipeRight.direction = UISwipeGestureRecognizerDirection.Right
            self.view.addGestureRecognizer(swipeRight)
        }
    }

    
   
}
