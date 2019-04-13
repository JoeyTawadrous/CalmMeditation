import UIKit
import FontAwesome_swift
import KYCircularProgress
import SwiftySound


class RunMeditation: UIViewController {
	
	@IBOutlet var bgImageView: UIImageView!
	@IBOutlet var titleLabel: UILabel!
	@IBOutlet var soundButton: UIButton!
	@IBOutlet var chooseSoundButton: UIButton!
	
	// Timer
	private var circularProgressView: KYCircularProgress!
	private var circularProgressValue: Double = 0.0
	private var timer: Timer!
	
	// To measure length of meditation
	var startTime: CFAbsoluteTime = 0.0
	var endTime: CFAbsoluteTime?
	
	private var meditation: [Any] = []
	private var sound: String!
	
	
	
	/* MARK: Initialising
	/////////////////////////////////////////// */
	override func viewWillAppear(_ animated: Bool) {
		meditation = Constants.Meditations.MEDITATIONS_ALL[Utils.int(key: Constants.Defaults.SELECTED_MEDITATION)]
		
		// Background
		bgImageView.image = UIImage(named: meditation[0] as! String)
		let overlay: UIView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
		overlay.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.1)
		bgImageView.addSubview(overlay)
		
		// Styling
		soundButton.layer.borderWidth = 2
		soundButton.layer.borderColor = UIColor.white.cgColor
		chooseSoundButton.layer.borderWidth = 2
		chooseSoundButton.layer.borderColor = UIColor.white.cgColor
		Utils.createFontAwesomeButton(button: soundButton, size: 30, icon: .volumeUp, style: .solid)
		Utils.createFontAwesomeButton(button: chooseSoundButton, size: 21, icon: .music, style: .solid)
		
		// Music
		playSound()
		
		initProgressView()
		initPhaseOne()
		
		startTime = CFAbsoluteTimeGetCurrent()
	}
	
	override var prefersStatusBarHidden: Bool {
		return true
	}
	

	
	/* MARK: Core
	/////////////////////////////////////////// */
	func playSound() {
		sound = meditation[5] as! String
		if Utils.contains(key: Constants.Defaults.SELECTED_MEDITATION_SOUND) { // Avoid sound break
			sound = Utils.string(key: Constants.Defaults.SELECTED_MEDITATION_SOUND)
		}
		else {
			if !Utils.contains(key: Constants.Defaults.PREVIOUS_VIEW) { // If ChooseSound is opened & closed without choosing
				Sound.enabled = true
				Sound.play(file: sound, fileExtension: "mp3", numberOfLoops: -1)
			}
		}
	}
	
	func stop() -> CFAbsoluteTime {
		endTime = CFAbsoluteTimeGetCurrent()
		return duration!
	}
	
	var duration: CFAbsoluteTime? {
		if let endTime = endTime {
			return endTime - startTime
		} else {
			return nil
		}
	}
	
	
	
	/* MARK: Button Actions
	/////////////////////////////////////////// */
	@IBAction func backButtonPressed() {
		Sound.stopAll()
		
		let timeElapsed = stop()
		
		// sessions
		var sessions = Utils.int(key: Constants.Defaults.APP_DATA_TOTAL_SESSIONS)
		var totalPoints = Utils.int(key: Constants.Defaults.APP_DATA_TOTAL_POINTS)
		if timeElapsed >= 180.0 { // default of 3 minutes to earn reward
			sessions += 1
			totalPoints += 3
		}
		Utils.set(key: Constants.Defaults.APP_DATA_TOTAL_SESSIONS, value: sessions)
		Utils.set(key: Constants.Defaults.APP_DATA_TOTAL_POINTS, value: totalPoints)
		
		
		// total time meditating
		var totalTimeMeditating = Utils.double(key: Constants.Defaults.APP_DATA_TOTAL_TIME_MEDITATING)
		totalTimeMeditating += (timeElapsed / 60)
		Utils.set(key: Constants.Defaults.APP_DATA_TOTAL_TIME_MEDITATING, value: totalTimeMeditating)
		
		
		Utils.presentView(self, viewName: Constants.Views.MEDITATION)
	}
	
	@IBAction func soundButtonPressed() {
		Sound.enabled = !Sound.enabled
		Sound.play(file: sound, fileExtension: "mp3", numberOfLoops: -1)
		
		if Sound.enabled {
			soundButton.setTitle(String.fontAwesomeIcon(name: .volumeUp), for: .normal)
		}
		else {
			soundButton.setTitle(String.fontAwesomeIcon(name: .volumeOff), for: .normal)
		}
	}
	
	@IBAction func chooseSoundButtonPressed() {
		Utils.presentView(self, viewName: Constants.Views.CHOOSE_SOUND_NAV_CONTROLLER)
	}
	
	
	
	/* MARK: Progress Functionality
	/////////////////////////////////////////// */
	func initProgressView() {
		let progressView = KYCircularProgress(frame: CGRect(x: (UIScreen.main.bounds.width / 2) - 75, y: (UIScreen.main.bounds.height / 3) - 50, width: 150, height: 150), showGuide: true)
		circularProgressView = Utils.createProgressView(progressView: progressView, color: "fff", guideColor: Constants.Colors.CIRCULAR_MEDITATION_GRAY)
		self.view.addSubview(circularProgressView)
	}
	
	
	func initPhaseOne() {
		let phaseLength = meditation[7] as! Double
		Utils.set(key: Constants.Defaults.MEDITATION_PHASE_LENGTH, value: phaseLength)
		
		titleLabel.text = meditation[6] as? String
		
		circularProgressValue = 0
		
		if timer != nil {
			timer.invalidate()
			timer = nil
		}
		timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(self.forwardProgress), userInfo: nil, repeats: true)
		
		DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
			self.initPhaseTwo()
		}
	}
	
	
	func initPhaseTwo() {
		let phaseLength = meditation[9] as! Double
		Utils.set(key: Constants.Defaults.MEDITATION_PHASE_LENGTH, value: phaseLength)
		
		titleLabel.text = meditation[8] as? String
		
		DispatchQueue.main.asyncAfter(deadline: .now() + phaseLength) {
			self.initPhaseThree()
		}
	}
	
	
	func initPhaseThree() {
		let phaseLength = meditation[11] as! Double
		Utils.set(key: Constants.Defaults.MEDITATION_PHASE_LENGTH, value: phaseLength)

		titleLabel.text = meditation[10] as? String

		circularProgressValue = 1

		timer.invalidate()
		timer = nil
		timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(self.reverseProgress), userInfo: nil, repeats: true)

		DispatchQueue.main.asyncAfter(deadline: .now() + phaseLength) {
			self.initPhaseFour()
		}
	}


	func initPhaseFour() {
		let phaseLength = meditation[9] as! Double
		Utils.set(key: Constants.Defaults.MEDITATION_PHASE_LENGTH, value: phaseLength)

		titleLabel.text = meditation[8] as? String

		DispatchQueue.main.asyncAfter(deadline: .now() + phaseLength) {
			self.initPhaseOne()
		}
	}
	
	
	@objc private func forwardProgress() {
		circularProgressValue += 0.01 / Utils.double(key: Constants.Defaults.MEDITATION_PHASE_LENGTH)
		circularProgressView.progress = circularProgressValue
	}
	
	
	@objc private func reverseProgress() {
		circularProgressValue -= 0.01 / Utils.double(key: Constants.Defaults.MEDITATION_PHASE_LENGTH)
		circularProgressView.progress = circularProgressValue
	}
}
