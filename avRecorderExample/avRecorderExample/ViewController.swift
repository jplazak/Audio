//
//  ViewController.swift
//  avRecorderExample in Swift 2.2
//
//  A simplified demo that captures 3 seconds of audio from the device's microphone, and
//  then immediately plays back the recorded audio.  Not recommended for production use.
//
//  Created by Joe Plazak on 9/4/16.
//  Based on an excellent tutorial by Gene De Lisa
//

//Import Required Frameworks
import UIKit
import AVFoundation

//ViewController Setup
class ViewController: UIViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    
    //AVFoundation Variables
    var recorder: AVAudioRecorder!
    var player:AVAudioPlayer!
    var soundFileURL:NSURL!
    
    //UI Interface Elements
    let recordButton = UIButton()
    
    //Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGUI()
    }
    
    //Programatically draw button in the middle of the screen
    func setupGUI(){
        let screenSize = UIScreen.mainScreen().bounds
        let tap = UITapGestureRecognizer(target: self, action: #selector(ViewController.record))
        recordButton.frame = CGRectMake(0,0,screenSize.width,screenSize.height)
        recordButton.setTitle("Tap to Record & Playback", forState: [])
        recordButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        recordButton.setTitleColor(UIColor.redColor(), forState: .Disabled)
        recordButton.addGestureRecognizer(tap)
        self.view.addSubview(recordButton)
    }
    
    //MARK: - AVRecorder Functions
    //Activate Recording function on Tap Gesture
    func record() {
        //print("recording")
        recordButton.enabled = false                //Turn Off Button
        self.setSessionPlayAndRecord()              //Begin Shared Instance & Check for Errors
        self.setupRecorder()                        //Declare Audio file Settings
        self.recorder.recordForDuration(3.0)        //Record for 3 seconds
    }
    
    //Setup AVAudioSession (Simplified)
    func setSessionPlayAndRecord() {
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        do {
            try session.setActive(true)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    //SetupAVRecorder
    func setupRecorder() {
        let currentFileName = "temporary.m4a"
        let documentsDirectory = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
        self.soundFileURL = documentsDirectory.URLByAppendingPathComponent(currentFileName)
        let recordSettings:[String : AnyObject] = [
            AVFormatIDKey: NSNumber(unsignedInt:kAudioFormatAppleLossless),
            AVEncoderAudioQualityKey : AVAudioQuality.Max.rawValue,
            AVEncoderBitRateKey : 320000,
            AVNumberOfChannelsKey: 1,
            AVSampleRateKey : 44100.0]
        do {
            recorder = try AVAudioRecorder(URL: soundFileURL, settings: recordSettings)
            recorder.delegate = self
            recorder.prepareToRecord()              // creates & overwrites file at soundFileURL
        } catch let error as NSError {
            recorder = nil
            print(error.localizedDescription)
        }
    }
    
    //Finished Recording Function
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        //print("finished recording \(flag)")
        recordButton.enabled = true
        setSessionPlayback()
        play()
    }
    
    //Error Catching
    func audioRecorderEncodeErrorDidOccur(recorder: AVAudioRecorder, error: NSError?) {
        if let e = error {
            print("\(e.localizedDescription)")
        }
    }
    
    //MARK: - AVPlayback Functions
    //Setup AVPlayback
    func setSessionPlayback() {
        let session:AVAudioSession = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(AVAudioSessionCategoryPlayback)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        do {
            try session.setActive(true)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    //Playback Function
    func play() {
        var url:NSURL?
        url = self.soundFileURL!
        //print("playing \(url)")
        do {
            self.player = try AVAudioPlayer(contentsOfURL: url!)
            player.delegate = self
            player.prepareToPlay()
            player.volume = 1.0
            player.play()
        } catch let error as NSError {
            self.player = nil
            print(error.localizedDescription)
        }
    }
    
    //Memory Management Function
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}


