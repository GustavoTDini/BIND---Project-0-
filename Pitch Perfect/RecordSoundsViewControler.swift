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
    
    // MARK: Outlets

    @IBOutlet weak var RecordButton: UIButton!
    @IBOutlet weak var StopRecordingButton: UIButton!
    @IBOutlet weak var RecordLabel: UILabel!
    
    
    // MARK: Actions

    @IBAction func RecordButtonAction(_ sender: Any) {
        showUI(recording: true)
        createSoundFlie()
    }
    
    @IBAction func StopRecordButtonAction(_ sender: Any) {
        showUI(recording: false)
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
   // MARK: LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showUI(recording: false)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording"{
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        } else {
            createAlertMessage(message: "Recording was not Successful")
        }
    }
    
    // MARK: Helper Functions
    
    func showUI(recording: Bool){
        if recording{
            RecordLabel.text = "Recording in Progress"
            RecordButton.isEnabled = false
            StopRecordingButton.isEnabled = true
        } else{
            RecordLabel.text = "Tap to Record"
            RecordButton.isEnabled = true
            StopRecordingButton.isEnabled = false
        }
    }
    
    func createSoundFlie(){
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options:AVAudioSession.CategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    func createAlertMessage(message: String){
        let alert = UIAlertController(title: "Ops!", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}

