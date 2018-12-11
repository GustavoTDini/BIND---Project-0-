//
//  RecordSoundsViewControler.swift
//  Pitch Perfect
//
//  Created by Gustavo Dini on 29/11/18.
//  Copyright © 2018 Gustavo Dini. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewControler: UIViewController, AVAudioRecorderDelegate {
    
    var audioRecorder: AVAudioRecorder!

    @IBOutlet weak var RecordButton: UIButton!
    
    @IBOutlet weak var StopRecordingButton: UIButton!
    
    @IBOutlet weak var RecordLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        StopRecordingButton.isEnabled = false
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func RecordButtonAction(_ sender: Any) {
        RecordLabel.text = "Recording in Progress"
        RecordButton.isEnabled = false
        StopRecordingButton.isEnabled = true
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    
    @IBAction func StopRecordButtonAction(_ sender: Any) {
        RecordLabel.text = "Tap to Record"
        RecordButton.isEnabled = true
        StopRecordingButton.isEnabled = false
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
            print("FinishedRecording")
        } else {
            print("Recording was Not Successful")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording"{
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
    
}

