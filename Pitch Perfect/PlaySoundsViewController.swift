//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Gustavo Dini on 10/12/18.
//  Copyright © 2018 Gustavo Dini. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet weak var snailButton: UIButton!
    @IBOutlet weak var rabbitButton: UIButton!
    @IBOutlet weak var chipmunkButton: UIButton!
    @IBOutlet weak var vaderButton: UIButton!
    @IBOutlet weak var echoButton: UIButton!
    @IBOutlet weak var reverbButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    var recordedAudioURL:URL!
    var audioFile:AVAudioFile!
    var audioEngine:AVAudioEngine!
    var audioPlayerNode: AVAudioPlayerNode!
    var stopTimer: Timer!
    
    enum ButtonType: Int, CaseIterable {
        case snailButton = 1, rabbitButton, chipmunkButton, vaderButton, echoButton, reverbButton
    }
    
    // MARK: Actions
    
    @IBAction func playSoundForButton(_ sender: UIButton) {
        switch(ButtonType(rawValue: sender.tag)!) {
        case .snailButton:
            playSound(rate: 0.5)
        case .rabbitButton:
            playSound(rate: 1.5)
        case .chipmunkButton:
            playSound(pitch: 1000)
        case .vaderButton:
            playSound(pitch: -1000)
        case .echoButton:
            playSound(echo: true)
        case .reverbButton:
            playSound(reverb: true)
        }
        
        configureUI(.playing)
    }
    
    @IBAction func stopButtonPressed(_ sender: AnyObject) {
        stopAudio()
    }
    
        // MARK: LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupAudio()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureUI(.notPlaying)
        scaleFitButtons()
    }
    
    func scaleFitButtons(){
        for thisButton in ButtonType.allCases{
            let button = self.view.viewWithTag(thisButton.rawValue) as? UIButton
            button?.imageView?.contentMode = .scaleAspectFit
        }
    }

}
