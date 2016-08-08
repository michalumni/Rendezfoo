//
//  Topic.swift
//  Rendezfoo
//
//  Created by Adil Ansari on 7/16/16.
//  Copyright © 2016 Adil Ansari. All rights reserved.
//

@objc protocol TopicDelegate {
    optional func topicFound(topicField:String)
    optional func topicNotFound(topicField:String)
    optional func topicCreated(myTopic:PFObject)
    optional func topicNotCreated(topicField:String)
    optional func topicQueryResults(topics:[PFObject])
    optional func topicsQueryResults(topics:[PFObject])
}

/*
 Class to deal with things pertaining to topics, including creating
 and various queries on topics.  All topic related code should be 
 managed by this class 
 */

class Topic: NSObject {
    var delegate:TopicDelegate?
    
    func queryForTopic(topic:String) {
        let query = PFQuery(className:"Topic")
        query.whereKey("topic", equalTo:topic)
        query.countObjectsInBackgroundWithBlock({(count, error) in
            if (error == nil) {
                if (count == 0) {
                    self.delegate?.topicNotFound!(topic)
                    
                } else if (count == 1) {
                    self.delegate?.topicFound!(topic)
                }
            }
            
        
        })
        
    }
    
    func queryForTopics(topics:[String]) {
        
        let query = PFQuery(className: "Topic")
        query.whereKey("objectId", containedIn: topics)
        query.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
            if (error == nil) {
                if let myTopics = objects {
                    self.delegate?.topicsQueryResults!(myTopics)
                }
            }
        })

        
    }
    
    func createTopic(topic:String) {
        let myTopic = PFObject(className: "Topic")
        myTopic["topic"] = topic
        myTopic.saveInBackgroundWithBlock({(success, error) in
            if (success) {
                self.delegate?.topicCreated!(myTopic)
            } else {
                self.delegate?.topicNotCreated!(topic)
            }
        })
    }
    
    func queryTopicStartingWith(myTopic:String) {
        
        //Use NSPredicate to optimize query
        let pred = NSPredicate(format: "topic BEGINSWITH '" + myTopic + "'")
        let query = PFQuery(className: "Topic", predicate: pred)
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                if let objects = objects {
                    self.delegate?.topicQueryResults!(objects)
                    
                }
            }
            
        }
        
    }

}
