//
//  PreviewVideoViewController.swift
//  RendezWho
//
//  Created by Adil Ansari on 7/3/16.
//  Copyright © 2016 Adil Ansari. All rights reserved.
//
//
//  PreviewVideoViewController.swift
//  LLSimpleCamera-Swift-Example
//
//  Created by StrawBerry on 20.01.2016.
//  Copyright © 2016 StrawBerry. All rights reserved.



import UIKit
import AVFoundation

protocol PreviewVideoViewControllerViewControllerDelegate
{
    func dismissPreviewCancelled()
    func dismissPreviewVideoMade(videoCont:PFObject)
}

 /*
    Preview the video back to the user, this is a good time to begin upload to server
    use amazon cloudfront/google to speed up response time to cloud.  This is also a 
    good time to save video into local cache
 */

class PreviewVideoViewController: UIViewController, VideoContainerDelegate {
    
    var videoUrl = NSURL();
    var avPlayer:AVPlayer = AVPlayer();
    var avPlayerLayer = AVPlayerLayer();
    var backButton = UIButton();
    var publishButton = UIButton()
    var delegate:PreviewVideoViewControllerViewControllerDelegate?
    var backgroundview:UIView!
    var spinner:UIActivityIndicatorView!
    var publishPushed = false
    var uploadComplete = false
    var fileName:String?
    var videoContainer:VideoContainer = VideoContainer()
    var parent:String!
    var topic:String!

    
    
    convenience init(videoUrl url: NSURL) {
        self.init()
        self.videoUrl = url
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.avPlayerLayer.player?.pause()
        self.avPlayerLayer.removeFromSuperlayer()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        
        self.avPlayer.play();
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //uploadMovie()
        self.view.backgroundColor = UIColor.whiteColor()
        // the video player
        let item = AVPlayerItem(URL: self.videoUrl);
        self.avPlayer = AVPlayer(playerItem: item);
        self.avPlayer.actionAtItemEnd = .None
        self.avPlayerLayer = AVPlayerLayer(player: self.avPlayer);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "playerItemDidReachEnd:", name: AVPlayerItemDidPlayToEndTimeNotification, object: self.avPlayer.currentItem!)
        
        let screenRect: CGRect = UIScreen.mainScreen().bounds
        
        self.avPlayerLayer.frame = CGRectMake(0, 0, screenRect.size.width, screenRect.size.height)
        self.view.layer.addSublayer(self.avPlayerLayer)
        
        self.backButton.addTarget(self, action: #selector(PreviewVideoViewController.backButtonPressed(_:)), forControlEvents: .TouchUpInside)
        self.backButton.frame = CGRectMake(15, 13, 30, 30)
        self.backButton.setImage(UIImage(named: "x_button"), forState: .Normal)
        
        self.publishButton.addTarget(self, action: Selector("publish"), forControlEvents: .TouchUpInside)
        
        self.publishButton.frame = CGRectMake(self.view.bounds.width - 100, self.view.bounds.height - 40, 100, 50)
        self.publishButton.setTitle("Publish", forState: .Normal)
        self.view!.addSubview(publishButton)
        
        
        
        self.view!.addSubview(self.backButton)
        self.backgroundview = UIView(frame: CGRectMake(0,0,screenRect.size.width, screenRect.size.height))
        backgroundview.backgroundColor = UIColor(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.1)
        self.spinner = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
        backgroundview!.addSubview(spinner!)
        spinner.center = backgroundview!.center
        view.addSubview(backgroundview)
        backgroundview.hidden = true
        spinner.hidesWhenStopped = true
    }
    
    /*
    func uploadMovie() {
        if let user = PFUser.currentUser() {
            let aws:AwsHandler = AwsHandler()
            aws.delegate = self
            let now = round(NSDate().timeIntervalSince1970)
            aws.uploadVidToS3("test1.mov", uploadedName: (user.objectId)! + now.description + ".mov")
            
        }
    }
    */
    
    func publish() {
        videoContainer.delegate = self
        videoContainer.create(parent, topic:topic)
        
        
    }
    
    func uploadComplete(fileName:String) {
        
        
        
    }
    
    func playerItemDidReachEnd(notification: NSNotification) {
        self.avPlayer.seekToTime(kCMTimeZero);
    }
    
    func backButtonPressed(button: UIButton) {
        delegate?.dismissPreviewCancelled()
        //self.navigationController!.popViewControllerAnimated(true)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func videoContainerCreated(videoContainer:PFObject) {
        delegate?.dismissPreviewVideoMade(videoContainer)
    }
 
    
}
