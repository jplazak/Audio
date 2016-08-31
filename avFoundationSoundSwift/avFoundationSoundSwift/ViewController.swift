//
//  ViewController.swift
//  AVFoundation - AVAudioPlayer Example in Swift 2.2
//
//  Basic Play, Stop, Pause, Loop, Reset, and Playback Rate functions implemented via the AVAudioPlayer
//  A useful class when "systemSound" lacks the necessary functionality
//
//  Created by Joe Plazak on 8/31/16.
//

//Import Required Frameworks
import UIKit
import AVFoundation

//ViewController Setup
class ViewController: UIViewController {
    
    //AVAudioPlayer Variables
    var audioPlayer = AVAudioPlayer()
    let soundURL = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("musicTrack", ofType: "mp3")!)
    
    //UI Interface Variables
    let playAudioButton = UIButton()
    let playBeginningButton = UIButton()
    let stopAudioButton = UIButton()
    let pauseAudioButton = UIButton()
    let volumeSlider = UISlider()
    let rateSlider = UISlider()

    //Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAudio()
        setupGUI()
    }
    
    //MARK: - AVFoundation Setup
    func setupAudio(){
        try! AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, withOptions: [])
        try! AVAudioSession.sharedInstance().setActive(true)
        loadSound()
        audioPlayer.volume = 0.5
        audioPlayer.enableRate = true
    }
    
    //MARK: - AVAudioPlayer Methods
    //preloadSound
    func loadSound() {
        do {
            try audioPlayer = AVAudioPlayer(contentsOfURL: soundURL)
            audioPlayer.prepareToPlay()
        } catch {
            print("there is \(error)")
        }
        loopSound()
    }
    
    //loopSound
    func loopSound() {
        audioPlayer.numberOfLoops = -1;  //Any negative number yields endless looping
    }
    
    //playSound from beginning
    func playFromBeginning(){
        loadSound()
        playSound()
    }
    
    //playSound
    func playSound() {
            audioPlayer.play()
    }
    
    //stopSound
    func stopSound() {
            audioPlayer.stop()
    }

    //Pause / Resume Function
    func pauseSound() {
            audioPlayer.pause()
    }
    
    //Pause & Resume Function : Not Used
    func pauseAndResume() {
        if audioPlayer.playing == true {
            audioPlayer.pause()
        } else {
            audioPlayer.play()
        }
    }

    //Volume Slider Action
    func changeVolume(sender: UISlider) {
        audioPlayer.volume = sender.value
    }
    
    //Rate Slider Action
    func changeRate(sender: UISlider) {
        audioPlayer.rate = sender.value
    }
    
    //MARK: - GUI Setup
    func setupGUI(){
        //Background View
        let background = UIView(frame:CGRectMake(UIScreen.mainScreen().bounds.width * 0.05,UIScreen.mainScreen().bounds.height * 0.05,UIScreen.mainScreen().bounds.width * 0.9,UIScreen.mainScreen().bounds.height * 0.9))
        background.backgroundColor = UIColor.lightGrayColor()
        self.view.addSubview(background)
        
        //Play Audio Button
        playAudioButton.frame = CGRectMake(20,60, 140,20)
        playAudioButton.center = CGPoint(x: view.bounds.midX, y: view.bounds.midY - 150)
        playAudioButton.setTitleColor(UIColor .blackColor(), forState: [])
        playAudioButton.setTitle("Play Audio", forState: [])
        playAudioButton.addTarget(self, action: #selector(self.playSound), forControlEvents: .TouchUpInside)
        self.view.addSubview(playAudioButton)
        
        //Play from Beginning Button
        playBeginningButton.frame = CGRectMake(20,60, 240,20)
        playBeginningButton.center = CGPoint(x: view.bounds.midX, y: view.bounds.midY - 100)
        playBeginningButton.setTitleColor(UIColor .blackColor(), forState: [])
        playBeginningButton.setTitle("Play From Beginning", forState: [])
        playBeginningButton.addTarget(self, action: #selector(self.playFromBeginning), forControlEvents: .TouchUpInside)
        self.view.addSubview(playBeginningButton)
        
        //Stop Audio Button
        stopAudioButton.frame = CGRectMake(20,100, 140, 20)
        stopAudioButton.center = CGPoint(x: view.bounds.midX, y: view.bounds.midY - 50)
        stopAudioButton.setTitleColor(UIColor .blackColor(), forState: [])
        stopAudioButton.setTitle("Stop Audio", forState: [])
        stopAudioButton.addTarget(self, action: #selector(self.stopSound), forControlEvents: .TouchUpInside)
        self.view.addSubview(stopAudioButton)
        
        //Pause Button
        pauseAudioButton.frame = CGRectMake(20,100, 190, 20)
        pauseAudioButton.center = CGPoint(x: view.bounds.midX, y: view.bounds.midY + 0)
        pauseAudioButton.setTitleColor(UIColor .blackColor(), forState: [])
        pauseAudioButton.setTitle("Pause Audio", forState: [])
        pauseAudioButton.addTarget(self, action: #selector(self.pauseSound), forControlEvents: .TouchUpInside)
        self.view.addSubview(pauseAudioButton)
        
        //Volume Label
        let volumeLabel = UILabel(frame: CGRectMake(12,10,100,20))
        volumeLabel.center = CGPoint(x: view.bounds.midX, y: view.bounds.midY + 50)
        volumeLabel.text = "Volume"
        volumeLabel.textAlignment = NSTextAlignment.Center
        self.view.addSubview(volumeLabel)
        
        //Volume Slider
        volumeSlider.frame = CGRectMake(20,100, 200, 20)
        volumeSlider.center = CGPoint(x: view.bounds.midX, y: view.bounds.midY + 80)
        volumeSlider.tintColor = UIColor.init(red: 58/255, green: 163/255, blue: 58/255, alpha: 1)
        volumeSlider.minimumValue = 0.0;
        volumeSlider.maximumValue = 1.0;
        volumeSlider.value = 0.5
        volumeSlider.continuous = true; // false makes it call only once you let go
        volumeSlider.addTarget(self, action: #selector(ViewController.changeVolume(_:)), forControlEvents: .ValueChanged)
        self.view.addSubview(volumeSlider)
        
        //Rate Label
        let rateLabel = UILabel(frame: CGRectMake(12,10,100,20))
        rateLabel.center = CGPoint(x: view.bounds.midX, y: view.bounds.midY + 120)
        rateLabel.text = "Rate"
        rateLabel.textAlignment = NSTextAlignment.Center
        self.view.addSubview(rateLabel)
        
        //Playback Rate Slider
        rateSlider.frame = CGRectMake(20,100, 200, 20)
        rateSlider.center = CGPoint(x: view.bounds.midX, y: view.bounds.midY + 150)
        rateSlider.tintColor = UIColor.init(red: 58/255, green: 163/255, blue: 58/255, alpha: 1)
        rateSlider.minimumValue = 0.75;
        rateSlider.maximumValue = 1.25;
        rateSlider.value = 1.0
        rateSlider.continuous = true; // false makes it call only once you let go
        rateSlider.addTarget(self, action: #selector(ViewController.changeRate(_:)), forControlEvents: .ValueChanged)
        self.view.addSubview(rateSlider)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

