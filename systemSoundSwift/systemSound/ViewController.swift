//
//  ViewController.swift
//  Using the SystemSound Library via Swift
//
//  Note from iOS Developer Library:  "System Sound Services is intended for user-interface
//  sound effects and user alerts.  It is not intended for sound effects in games.
//
//  Created by Joe Plazak on 8/30/16.
//

//Import Required Frameworks
import UIKit
import AudioToolbox

//ViewController Setup
class ViewController: UIViewController {
    
    //systemSound Variables
    var soundID: SystemSoundID = 0
    let mainBundle: CFBundleRef = CFBundleGetMainBundle()
    
    //UI Interface Variables
    let playSystemSoundButton = UIButton()  //Without Vibration
    let playAlertSoundButton = UIButton()   //With Vibration
    
    //Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGUI()
        setupAudio()
    }
    
    //Memory Method
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //GUI Setup (Programmatically)
    func setupGUI() {
        //Play System Sound Button (WITHOUT Vibration)
        playSystemSoundButton.frame = CGRectMake(20,60, 161,20)
        playSystemSoundButton.setTitleColor(UIColor .blackColor(), forState: [])
        playSystemSoundButton.setTitle("Play SystemSound", forState: [])
        playSystemSoundButton.addTarget(self, action: #selector(self.playSound), forControlEvents: .TouchUpInside)
        self.view.addSubview(playSystemSoundButton)
        
        //Play System Alert Button (WITH Vibration)
        playAlertSoundButton.frame = CGRectMake(20,100, 140, 20)
        playAlertSoundButton.setTitleColor(UIColor .blackColor(), forState: [])
        playAlertSoundButton.setTitle("Play AlertSound", forState: [])
        playAlertSoundButton.addTarget(self, action: #selector(self.playSoundAndVibrate), forControlEvents: .TouchUpInside)
        self.view.addSubview(playAlertSoundButton)
    }

    //MARK: - systemSoundMethods
    //systemSound Setup
    func setupAudio() {
        if let ref: CFURLRef = CFBundleCopyResourceURL(mainBundle,"sillySound", "wav", nil){
            AudioServicesCreateSystemSoundID(ref, &soundID)
            print("\(ref) was properly loaded")
        } else {
            print("Audio file not found")
        }
    }
    
    //Play systemSound Method (WITHOUT Vibration)
    func playSound() {
        AudioServicesPlaySystemSound(soundID)
        print("Playing System Sound")
    }
    
    //Play alertSound Method (WITH Vibration)
    func playSoundAndVibrate() {
        AudioServicesPlayAlertSound(soundID)
        print("Playing Alert Sound \nNote: Simulator does not vibrate")
    }
    
    //Release manual systemSound Resource (Deallocate method)
    deinit {
        AudioServicesDisposeSystemSoundID(soundID)
    }
}

