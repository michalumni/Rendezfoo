//
//  CreateTopicViewController.swift
//  Rendezfoo
//
//  Created by Adil Ansari on 7/15/16.
//  Copyright © 2016 Adil Ansari. All rights reserved.
//
protocol CreateTopicViewControllerDelegate {
    func dismissCreateTopic()
    func dismissAndShowTopic(myTopic:PFObject)
}

 /*
    Class to create a new topic, this is the equivalent of a subreddit --  show simple
    warning if topic exists otherwise go ahead and create. If topic is created immidiately 
    take them to TopicViewController for that topic.
 
 */

class CreateTopicViewController: UIViewController, UITextFieldDelegate, TopicDelegate {
    
    
    
    @IBOutlet var bottomLabel: UILabel!
    @IBOutlet var mainView: UIView!
    @IBOutlet var topic: UITextField!
    var delegate:CreateTopicViewControllerDelegate?
    let topicClass:Topic = Topic()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.endEditing(true)
        mainView.endEditing(true)
        topic.delegate = self
        topicClass.delegate = self
        
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        guard let myTopic = textField.text else {
            return true
        }
        
        if (myTopic == "") {
            return true
        }
        
        let trimmedString = myTopic.stringByTrimmingCharactersInSet(
            NSCharacterSet.whitespaceAndNewlineCharacterSet()
        )
        
        
        topicClass.queryForTopic(trimmedString)
        
        
        
        /*if let myTopic = textField.text {
            topicClass.queryTopic(textField.text!)
        }*/
        
        return true
    }
    
    @IBAction func gestureSwiped(sender: UISwipeGestureRecognizer) {
        delegate?.dismissCreateTopic()

    }

    func topicFound(topicField:String) {
        //
        bottomLabel.text = topicField + " already exists"
    }
    
    func topicNotFound(topicField:String) {
        //
        topicClass.createTopic(topicField)
    }

    func topicCreated(myTopic:PFObject) {
        delegate?.dismissAndShowTopic(myTopic)
    }
    
    func topicNotCreated(topicField:String) {
        bottomLabel.text = "Error creating " + topicField
        
    }

}
