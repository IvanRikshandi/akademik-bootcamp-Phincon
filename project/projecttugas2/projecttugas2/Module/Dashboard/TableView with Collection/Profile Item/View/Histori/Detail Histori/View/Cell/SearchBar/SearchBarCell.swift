import UIKit
import Speech

protocol SearchBarCellDelegate {
    func searchTextChanged(_ text: String?)
}

class SearchBarCell: UITableViewCell, SFSpeechRecognizerDelegate {
    
    @IBOutlet weak var voiceHistory: UIImageView!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var containerView: UIView!
    
    var delegate: SearchBarCellDelegate?
    let speechRecognizer = SFSpeechRecognizer()
    var request: SFSpeechAudioBufferRecognitionRequest?
    var recognitionTask: SFSpeechRecognitionTask?
    let audioEngine = AVAudioEngine()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupSpeechRecognition()
        style()
        searchField.addTarget(self, action: #selector(searchTextEditedChange), for: .editingChanged)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(searchByVoice))
        voiceHistory.addGestureRecognizer(tapGesture)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func style() {
        containerView.makeCornerRadius(8)
        searchField.makeCornerRadius(3)
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.black.cgColor.copy(alpha: 0.3)
    }
    
    func setupSpeechRecognition() {
        speechRecognizer?.delegate = self
        SFSpeechRecognizer.requestAuthorization { authStatus in
            DispatchQueue.main.async {
                if authStatus == .authorized {
                    self.voiceHistory.isUserInteractionEnabled = true
                }
            }
        }
    }
    
    func startRecording() {
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        let inputNode =  audioEngine.inputNode
        let audioSession = AVAudioSession.sharedInstance()
        try? audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
        try? audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        
        request = SFSpeechAudioBufferRecognitionRequest()
        
        guard let recognitionRequest = request else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        }
        
        recognitionRequest.shouldReportPartialResults = true
        
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest ){
            result, error in
            var isFinal = false
            
            if let result = result {
                let searchText = result.bestTranscription.formattedString
                self.searchField.text = searchText
                isFinal = result.isFinal
                
                
                self.searchVoiceToText(text: searchText)
                
            }
            
            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.request = nil
                self.recognitionTask = nil
            }
        }
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        
        do {
            inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat ) {
                buffer, _ in
                self.request?.append(buffer)
            }
            audioEngine.prepare()
            
            try audioEngine.start()
            searchField.text = "(Listening ....)"
        } catch {
            print("Audio engine couldn't start because of an error: \(error)")
        }
    }
    
    @objc func searchTextEditedChange(_ sender: UITextField) {
        searchVoiceToText(text: sender.text ?? "")
    }
    
    func searchVoiceToText(text: String) {
        delegate?.searchTextChanged(text)
    }
    
    @objc func searchByVoice() {
        if (audioEngine.isRunning) {
            audioEngine.stop()
            request?.endAudio()
            voiceHistory.tintColor = UIColor.black
        } else {
            startRecording()
            voiceHistory.tintColor = UIColor.red
        }
    }
}
