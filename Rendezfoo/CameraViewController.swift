//
//  CameraViewController.swift
//  RendezWho
//
//  Created by Adil Ansari on 7/3/16.
//  Copyright © 2016 Adil Ansari. All rights reserved.
//

import UIKit

protocol CameraViewControllerDelegate {
    func dismissCameraViewController()
    func dismissCameraVideoMade(videoCont:PFObject)
}

 /*
 Modified code using LLSimpleCamera example, simulate snapchat like camera use timer
 to indicate to user 10 second countdown for video length
 */

class CameraViewController: UIViewController, PreviewVideoViewControllerViewControllerDelegate {
    
    var backButton = UIButton();
    var topic:String!
    var parent:String!
    var errorLabel = UILabel();
    var snapButton = UIButton();
    var switchButton = UIButton();
    var flashButton = UIButton()
    var settingsButton = UIButton()
    var countDownLabel = UILabel()
    var remainingTicks = 10
    var timer:NSTimer?
    var delegate:CameraViewControllerDelegate?
    
    //var segmentedControl = UISegmentedControl();
    var camera = LLSimpleCamera();
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        self.camera.start();
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.navigationController?.setNavigationBarHidden(true, animated: false);
        self.view.backgroundColor = UIColor.blackColor();
        
        let screenRect = UIScreen.mainScreen().bounds;
        
        self.camera = LLSimpleCamera(quality: AVCaptureSessionPresetHigh, position: LLCameraPositionFront, videoEnabled: true)
        self.camera.attachToViewController(self, withFrame: CGRectMake(0, 0, screenRect.size.width, screenRect.size.height))
        self.camera.fixOrientationAfterCapture = true;
        
        
        self.camera.onDeviceChange = {(camera, device) -> Void in
            if camera.isFlashAvailable() {
                self.flashButton.hidden = false
                if camera.flash == LLCameraFlashOff {
                    self.flashButton.selected = false
                }
                else {
                    self.flashButton.selected = true
                }
            }
            else {
                self.flashButton.hidden = true
            }
        }
        
        self.camera.onError = {(camera, error) -> Void in
            if (error.domain == LLSimpleCameraErrorDomain) {
                if error.code == 10 || error.code == 11 {
                    if(self.view.subviews.contains(self.errorLabel)){
                        self.errorLabel.removeFromSuperview()
                    }
                    
                    let label: UILabel = UILabel(frame: CGRectZero)
                    label.text = "We need permission for the camera and microphone."
                    label.numberOfLines = 2
                    label.lineBreakMode = .ByWordWrapping;
                    label.backgroundColor = UIColor.clearColor()
                    label.font = UIFont(name: "AvenirNext-DemiBold", size: 13.0)
                    label.textColor = UIColor.whiteColor()
                    label.textAlignment = .Center
                    label.sizeToFit()
                    label.center = CGPointMake(screenRect.size.width / 2.0, screenRect.size.height / 2.0)
                    self.errorLabel = label
                    self.view!.addSubview(self.errorLabel)
                    
                    let jumpSettingsBtn: UIButton = UIButton(frame: CGRectMake(50, label.frame.origin.y + 50, screenRect.size.width - 100, 50));
                    jumpSettingsBtn.titleLabel!.font = UIFont(name: "AvenirNext-DemiBold", size: 24.0)
                    jumpSettingsBtn.setTitle("Go Settings", forState: .Normal);
                    jumpSettingsBtn.setTitleColor(UIColor.whiteColor(), forState: .Normal);
                    jumpSettingsBtn.layer.borderColor = UIColor.whiteColor().CGColor;
                    jumpSettingsBtn.layer.cornerRadius = 5;
                    jumpSettingsBtn.layer.borderWidth = 2;
                    jumpSettingsBtn.clipsToBounds = true;
                    jumpSettingsBtn.addTarget(self, action: "jumpSettinsButtonPressed:", forControlEvents: .TouchUpInside);
                    jumpSettingsBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
                    
                    self.settingsButton = jumpSettingsBtn;
                    
                    self.view!.addSubview(self.settingsButton);
                    
                    self.switchButton.enabled = false;
                    self.flashButton.enabled = false;
                    self.snapButton.enabled = false;
                }
            }
        }
        
        if(LLSimpleCamera.isFrontCameraAvailable() && LLSimpleCamera.isRearCameraAvailable()){
            self.snapButton = UIButton(type: .Custom)
            self.snapButton.frame = CGRectMake(0, 0, 70.0, 70.0)
            self.snapButton.clipsToBounds = true
            self.snapButton.layer.cornerRadius = self.snapButton.frame.width / 2.0
            self.snapButton.layer.borderColor = UIColor.whiteColor().CGColor
            self.snapButton.layer.borderWidth = 3.0
            self.snapButton.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.6);
            self.snapButton.layer.rasterizationScale = UIScreen.mainScreen().scale
            self.snapButton.layer.shouldRasterize = true
            self.snapButton.addTarget(self, action: "snapButtonPressed:", forControlEvents: .TouchUpInside)
            self.view!.addSubview(self.snapButton)
            
            self.backButton.addTarget(self, action: #selector(CameraViewController.backButtonPressed(_:)), forControlEvents: .TouchUpInside)
            self.backButton.frame = CGRectMake(15, 13, 30, 30)
            self.backButton.setImage(UIImage(named: "x_button"), forState: .Normal)
            self.view!.addSubview(self.backButton)

            
            self.flashButton = UIButton(type: .System)
            self.flashButton.frame = CGRectMake(0, 0, 16.0 + 20.0, 24.0 + 20.0)
            self.flashButton.tintColor = UIColor.whiteColor()
            self.flashButton.setImage(UIImage(named: "camera-flash"), forState: .Normal)
            self.flashButton.imageEdgeInsets = UIEdgeInsetsMake(10, 10.0, 10.0, 10.0)
            self.flashButton.addTarget(self, action: "flashButtonPressed:", forControlEvents: .TouchUpInside)
            self.flashButton.hidden = true;
            self.view!.addSubview(self.flashButton)
            
            //self.flashButton = UIButton(type: .System)
            self.countDownLabel.frame = CGRectMake(0, 0, 50, 40)
            self.countDownLabel.font = UIFont(name: "catamaran", size: 22)
            self.countDownLabel.textAlignment = .Center
            
            self.countDownLabel.textColor = UIColor.whiteColor()
            
            //self.flashButton.tintColor = UIColor.whiteColor()
            //self.flashButton.setImage(UIImage(named: "camera-flash"), forState: .Normal)
            //self.flashButton.imageEdgeInsets = UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0)
            //self.flashButton.addTarget(self, action: "flashButtonPressed:", forControlEvents: .TouchUpInside)
            //self.flashButton.hidden = true;
            self.view!.addSubview(self.countDownLabel)
            
            self.switchButton = UIButton(type: .System)
            self.switchButton.frame = CGRectMake(0, 0, 29.0 + 20.0, 22.0 + 20.0)
            self.switchButton.tintColor = UIColor.whiteColor()
            self.switchButton.setImage(UIImage(named: "camera-switch"), forState: .Normal)
            self.switchButton.imageEdgeInsets = UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0)
            self.switchButton.addTarget(self, action: "switchButtonPressed:", forControlEvents: .TouchUpInside)
            self.view!.addSubview(self.switchButton)
            
            /*
             self.segmentedControl = UISegmentedControl(items: ["Picture", "Video"])
             self.segmentedControl.frame = CGRectMake(12.0, screenRect.size.height - 60, 120.0, 32.0)
             self.segmentedControl.selectedSegmentIndex = 0
             self.segmentedControl.tintColor = UIColor.whiteColor()
             self.segmentedControl.addTarget(self, action: "segmentedControlValueChanged:", forControlEvents: .ValueChanged)
             self.view!.addSubview(self.segmentedControl)*/
        }
        else{
            let label: UILabel = UILabel(frame: CGRectZero)
            label.text = "You must have a camera to take video."
            label.numberOfLines = 2
            label.lineBreakMode = .ByWordWrapping;
            label.backgroundColor = UIColor.clearColor()
            label.font = UIFont(name: "AvenirNext-DemiBold", size: 13.0)
            label.textColor = UIColor.whiteColor()
            label.textAlignment = .Center
            label.sizeToFit()
            label.center = CGPointMake(screenRect.size.width / 2.0, screenRect.size.height / 2.0)
            self.errorLabel = label
            self.view!.addSubview(self.errorLabel)
        }
    }
    
    func segmentedControlValueChanged(control: UISegmentedControl) {
        print("Segment value changed!")
    }
    
    func cancelButtonPressed(button: UIButton) {
        self.navigationController!.popViewControllerAnimated(true)
    }
    
    func jumpSettinsButtonPressed(button: UIButton){
        UIApplication.sharedApplication().openURL(NSURL(string:UIApplicationOpenSettingsURLString)!);
    }
    
    func switchButtonPressed(button: UIButton) {
        if(camera.position == LLCameraPositionRear){
            self.flashButton.hidden = false;
        }
        else{
            self.flashButton.hidden = true;
        }
        
        self.camera.togglePosition()
    }
    
    func updateClock() {
        self.remainingTicks = self.remainingTicks - 1
        self.updateLabel()
        
        
        
        if (remainingTicks == 0) {
            self.countDownLabel.hidden = true
            pictureTaken()
        }
    }
    
    
    func updateLabel() {
        self.countDownLabel.text = NSNumber(integer: self.remainingTicks).stringValue
    }
    
    func pictureTaken() {
        if(self.camera.position == LLCameraPositionRear && self.flashButton.hidden){
            self.flashButton.hidden = false;
        }
        //self.segmentedControl.hidden = false;
        self.switchButton.hidden = false
        self.snapButton.layer.borderColor = UIColor.whiteColor().CGColor
        self.snapButton.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.5);
        //self.camera.stopRecording()
    
        
        self.camera.stopRecording({(camera, outputFileUrl, error) -> Void in
            let vc: PreviewVideoViewController = PreviewVideoViewController(videoUrl: outputFileUrl)
            //self.navigationController!.pushViewController(vc, animated: true)
            vc.delegate = self
            vc.parent = self.parent
            vc.topic = self.topic
            self.presentViewController(vc, animated: false, completion: nil)
        })
        
    }
    
    func snapButtonPressed(button: UIButton) {
        
        if(!camera.recording) {
            if(self.camera.position == LLCameraPositionRear && !self.flashButton.hidden){
                self.flashButton.hidden = true;
            }
            //self.segmentedControl.hidden = true
            self.switchButton.hidden = true
            self.snapButton.layer.borderColor = UIColor.redColor().CGColor
            self.snapButton.backgroundColor = UIColor.redColor().colorWithAlphaComponent(0.5);
            // start recording
            let outputURL: NSURL = self.applicationDocumentsDirectory().URLByAppendingPathComponent("test1").URLByAppendingPathExtension("mov")

            self.camera.startRecordingWithOutputUrl(outputURL)
            
            self.countDownLabel.hidden = false
            self.countDownLabel.textColor = UIColor.whiteColor()
            
            self.timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(CameraViewController.updateClock), userInfo: nil, repeats: true)
            
            
        }
            
        else{
            pictureTaken()
            
            
        }
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.camera.view.frame = self.view.bounds
        self.snapButton.center = self.view.center
        self.snapButton.frame.origin.y = self.view.bounds.height - 90
        self.countDownLabel.frame.origin.y = self.view.bounds.height - 80
        self.countDownLabel.center.x = self.view.center.x
        self.flashButton.frame.origin.x = 40
        self.flashButton.frame.origin.y = 5.0
        self.switchButton.frame.origin.y = 5.0
        self.switchButton.frame.origin.x = self.view.frame.width - 60.0
    }
    
    func flashButtonPressed(button: UIButton) {
        if self.camera.flash == LLCameraFlashOff {
            let done: Bool = self.camera.updateFlashMode(LLCameraFlashOn)
            if done {
                self.flashButton.selected = true
                self.flashButton.tintColor = UIColor.yellowColor();
            }
        }
        else {
            let done: Bool = self.camera.updateFlashMode(LLCameraFlashOff)
            if done {
                self.flashButton.selected = false
                self.flashButton.tintColor = UIColor.whiteColor();
            }
        }
    }
    
    func applicationDocumentsDirectory()-> NSURL {
        return NSFileManager.defaultManager().URLsForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask).last!
    }
    
    override func preferredInterfaceOrientationForPresentation() -> UIInterfaceOrientation {
        return .Portrait
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.timer?.invalidate()
        self.countDownLabel.hidden = true
        self.remainingTicks = 15
        self.updateLabel()
    }
    

    
    override func prefersStatusBarHidden() -> Bool {
        return true;
    }
    
    func dismissPreviewCancelled() {
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    func backButtonPressed(button: UIButton) {
        delegate?.dismissCameraViewController()
        //self.navigationController!.popViewControllerAnimated(true)
    }
    
    func dismissPreviewVideoMade(videoCont:PFObject) {
        self.dismissViewControllerAnimated(false, completion: {
            self.delegate?.dismissCameraVideoMade(videoCont)
        })

    }

    
}
