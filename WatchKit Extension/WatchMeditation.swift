import WatchKit
import SpriteKit
import AVFoundation


class WatchMeditation: WKInterfaceController {
	
	@IBOutlet var bgImageGroup: WKInterfaceGroup!
	@IBOutlet var overlayGroup: WKInterfaceGroup!
	@IBOutlet var titleLabel: WKInterfaceLabel!
	@IBOutlet var progressGroup: WKInterfaceGroup!
	
	var player: AVAudioPlayer?
	
	
	
	override func awake(withContext context: Any?) {
		super.awake(withContext: context)
		
		let meditation = context as! [Any]
	
		bgImageGroup.setBackgroundImage(UIImage(named: (meditation[0] as? String)!))
		overlayGroup.setBackgroundColor(UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.15))
		progressGroup.setBackgroundImageNamed("progress")
		
		initPhaseOne(meditation: meditation)
		playSound(meditation: meditation)
	}
	
	override func didDeactivate() {
		player?.stop()
	}
	
	
	func playSound(meditation: [Any]) {
		if let path = Bundle.main.path(forResource: (meditation[5] as! String), ofType: "mp3") {
			let fileUrl = URL(fileURLWithPath: path)
			
			do {
				try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
				try AVAudioSession.sharedInstance().setActive(true)
				player = try AVAudioPlayer(contentsOf: fileUrl)
				player?.numberOfLoops = -1
				player?.play()
			}
			catch
			{
				print("Could not play audio file")
			}
		}
	}
	
	func initPhaseOne(meditation: [Any]) {
		let phaseLength = meditation[7] as! Double
		titleLabel.setText((meditation[6] as? String)?.replacingOccurrences(of: "\n\n", with: "\n", options: .literal, range: nil))
		progressGroup.startAnimatingWithImages(in: NSRange(location: 0, length: 100), duration: phaseLength, repeatCount: 0)
		
		DispatchQueue.main.asyncAfter(deadline: .now() + (phaseLength * 0.9)) { // this is not called before images restart showing from 0
			self.progressGroup.stopAnimating()
			self.initPhaseTwo(meditation: meditation)
		}
	}
	
	func initPhaseTwo(meditation: [Any]) {
		let phaseLength = meditation[9] as! Double
		titleLabel.setText((meditation[8] as? String)?.replacingOccurrences(of: "\n\n", with: "\n", options: .literal, range: nil))
		
		DispatchQueue.main.asyncAfter(deadline: .now() + phaseLength) {
			self.initPhaseThree(meditation: meditation)
		}
	}
	
	func initPhaseThree(meditation: [Any]) {
		let phaseLength = meditation[11] as! Double
		titleLabel.setText((meditation[10] as? String)?.replacingOccurrences(of: "\n\n", with: "\n", options: .literal, range: nil))
		progressGroup.startAnimatingWithImages(in: NSRange(location: 0, length: 100), duration: -phaseLength, repeatCount: 1)
		
		DispatchQueue.main.asyncAfter(deadline: .now() + (phaseLength * 0.9)) {
			self.initPhaseFour(meditation: meditation)
		}
	}
	
	func initPhaseFour(meditation: [Any]) {
		let phaseLength = meditation[9] as! Double
		titleLabel.setText((meditation[8] as? String)?.replacingOccurrences(of: "\n\n", with: "\n", options: .literal, range: nil))
		
		DispatchQueue.main.asyncAfter(deadline: .now() + phaseLength) {
			self.initPhaseOne(meditation: meditation)
		}
	}
}
