//
//  VideoContainer.swift
//  Rendezfoo
//
//  Created by Adil Ansari on 7/18/16.
//  Copyright © 2016 Adil Ansari. All rights reserved.
//

import UIKit
@objc protocol VideoContainerDelegate
{
    optional func videoContainerCreated(videoContainer:PFObject)
    optional func videoContainersForTopic(videoContainers:[PFObject])
    optional func isRoot()
}


/*
 Generic class to hold the video container stack the first
 VideoContainer will have no parent and subsequently we will 
 create a tree off the root node .
 */

class VideoContainer: NSObject {
    var delegate:VideoContainerDelegate?
    
    func create(parent:String, topic:String) {
        guard let user = PFUser.currentUser() else {
            return
        }
        
        let videoContainer = PFObject(className: "VideoContainer")
        videoContainer["owner"] = user.objectId
        videoContainer["parent"] = parent
        videoContainer["upvoted"] = 0
        videoContainer["topic"] = topic 
        videoContainer.saveInBackgroundWithBlock({(success, error) in
            if (success) {
                self.delegate?.videoContainerCreated!(videoContainer)
            }
        
        })
        
    }
    
    func queryPosition(vidContainer:PFObject) {
        guard let parent = vidContainer["parent"] as? String else {
            return
        }
        
        if (parent == "None") {
            delegate?.isRoot!()
        }
        
        /* Add code here to provide position if a child node */
        
    }
    
    /* This needs to be reworked so its sorted by day 
    -- perhaps we use a hashtable to do this temporary fix */
    
    func queryByTopic(topic:String) {
        let query = PFQuery(className:"VideoContainer")
        query.whereKey("topic", equalTo:topic)
        query.orderByDescending("createdAt,upvoted")
        query.findObjectsInBackgroundWithBlock({(containers, error) in
            if (error == nil) {
                if let vidConts = containers {
                    self.delegate?.videoContainersForTopic!(vidConts)
                }
                
            }
        
        
        })

    }
}
