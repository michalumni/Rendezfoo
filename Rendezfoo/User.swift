//
//  User.swift
//  Rendezfoo
//
//  Created by Adil Ansari on 7/17/16.
//  Copyright © 2016 Adil Ansari. All rights reserved.
//

@objc protocol UserDelegate {
    optional func topicNotInFavorites(myTopic:PFObject)
    optional func topicIsInFavorites(myTopic:PFObject)
    optional func userFavoriteTopics(topics:[PFObject])
}

 /* 
 Use the Parse PFUser wherever possible, but items such as
 queries on the user belong here.  This includes the user's favorite
 Topics.
 */

class User: NSObject, TopicDelegate {
    var delegate:UserDelegate?
    var topicClass:Topic = Topic()
    
    func topicInFavorites(topic:PFObject) {
        guard let user = PFUser.currentUser() else {
            delegate?.topicNotInFavorites!(topic)
            return
        }
        
        guard let favorites:[String] = user["favorites"] as? [String] else {
            user["favorites"] = []
            saveUser(user, type: "not_in_favorites", topic: topic)
            return
        }
        
        
        if favorites.contains(topic.objectId!) {
            delegate?.topicIsInFavorites!(topic)
        }
        
    }
    
    func saveUser(user:PFUser, type:String, topic:PFObject) {
        user.saveInBackgroundWithBlock({(success, error) in
            if (success) {
                user.pinInBackgroundWithBlock({(success, error) in
                    if (success) {
                        if (type == "not_in_favorites") {
                            self.delegate?.topicNotInFavorites!(topic)
                        } else if (type == "in_favorites") {
                            self.delegate?.topicIsInFavorites!(topic)
                        }
                    }
                    
                })
            }
            
        })

    }
    
    
    func queryFavorites() {
        guard let user = PFUser.currentUser() else {
            return
        }
        
        guard let favorites:[String] = user["favorites"] as? [String] else {
            user["favorites"] = []
            user.saveInBackground()
            user.pinInBackground()
            return
        }
        
        topicClass.delegate = self
        topicClass.queryForTopics(favorites)
        
        
               
        
    }
    
    
    
    func addFavorite(topic:PFObject) {
        guard let user = PFUser.currentUser() else {
            return
        }
        
        guard var favorites:[String] = user["favorites"] as? [String] else {
            var myArray:[String] = []
            myArray.append(topic.objectId!)
            user["favorites"] = myArray
            saveUser(user, type: "in_favorites", topic: topic)
            return
        }
        
        favorites.append(topic.objectId!)
        user["favorites"] = favorites
        saveUser(user, type: "in_favorites", topic: topic)
        
    }
    
    func topicsQueryResults(topics: [PFObject]) {
        delegate?.userFavoriteTopics!(topics)
    }
}
