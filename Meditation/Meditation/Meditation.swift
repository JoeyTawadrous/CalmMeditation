import UIKit


class Meditation: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
	
	@IBOutlet var collectionView: UICollectionView!
	@IBOutlet var exerciseLabel: UILabel!
	@IBOutlet var goalLabel: UILabel!
	@IBOutlet var titleLabel: UILabel!
	@IBOutlet var textLabel: UILabel!
	@IBOutlet var goButton: UIButton!
	@IBOutlet var achievementsButton: UIButton!
	@IBOutlet var menuButton: UIBarButtonItem!
	
	
	
	/* MARK: Initialising
	/////////////////////////////////////////// */
	override func viewDidLoad() {
		// Styling
		goButton.layer.borderColor = UIColor.white.cgColor
		goButton.layer.borderWidth = 6.0
		achievementsButton.layer.borderColor = UIColor.white.cgColor
		achievementsButton.layer.borderWidth = 6.0
		
		Utils.createFontAwesomeBarButton(button: menuButton, icon: .bars, style: .solid)
		Utils.createFontAwesomeButton(button: achievementsButton, size: 15.0, icon: .gem, style: .regular)
	}
	
	
	override func viewWillAppear(_ animated: Bool) {
		// Reset
		Utils.remove(key: Constants.Defaults.SELECTED_MEDITATION_SOUND)
		Utils.remove(key: Constants.Defaults.PREVIOUS_VIEW)
		
		if Utils.contains(key: Constants.Defaults.SELECTED_MEDITATION) {
			setMeditation(index: Utils.int(key: Constants.Defaults.SELECTED_MEDITATION))
		}
		else {
			setMeditation(index: 0)
		}
		
		// Has the user reached an achievement?
		ProgressManager.checkAndSetAchievementReached(view: self, type: Constants.Achievements.POINTS_TYPE)
		ProgressManager.checkAndSetAchievementReached(view: self, type: Constants.Achievements.SESSIONS_TYPE)
		ProgressManager.checkAndSetAchievementReached(view: self, type: Constants.Achievements.TIME_MEDITATING_TYPE)

		// TODO: JOEY: show level up dialog
//		let points = Utils.int(key: Constants.Defaults.APP_DATA_TOTAL_POINTS)
//		if(ProgressManager.shouldLevelUp(points: (points - 3))) {
//			Dialogs.showLevelUpDialog(view: self, level: String(ProgressManager.getLevel(points: (points - 3))))
//		}
	}
	
	
	override var prefersStatusBarHidden: Bool {
		return true
	}
	
	
	
	/* MARK: Button Actions
	/////////////////////////////////////////// */
	@IBAction func achievementsButtonPressed() {
		Utils.presentView(self, viewName: Constants.Views.ACHIEVEMENTS)
	}
	
	@IBAction func goButtonPressed() {
		Utils.presentView(self, viewName: Constants.Views.RUN_MEDITATION)
	}
	
	@IBAction func menuButtonPressed(_ sender: AnyObject) {
		Utils.presentView(self, viewName: Constants.Views.SETTINGS_NAV_CONTROLLER)
	}
	
	
	
	/* MARK: Core
	/////////////////////////////////////////// */
	func setMeditation(index: Int) {
		let meditation = Constants.Meditations.MEDITATIONS_ALL[index] as [Any]
		exerciseLabel.text = meditation[1] as? String
		goalLabel.text = "• " + (meditation[2] as? String)! + " •"
		titleLabel.text = meditation[3] as? String
		
		let attributedString = NSMutableAttributedString(string: meditation[4] as! String)
		let paragraphStyle = NSMutableParagraphStyle()
		paragraphStyle.lineSpacing = 8
		attributedString.addAttribute(kCTParagraphStyleAttributeName as NSAttributedStringKey, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
		textLabel.attributedText = attributedString
		
		Utils.set(key: Constants.Defaults.SELECTED_MEDITATION, value: index)
	}
	
	
	/* MARK: Collection View
	/////////////////////////////////////////// */
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return Constants.Meditations.MEDITATIONS_ALL.count
	}
	
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "meditationCollectionViewCell", for: indexPath) as! MeditationCollectionViewCell
		
		let meditation = Constants.Meditations.MEDITATIONS_ALL[indexPath.row] as [Any]
		
		cell.containerImageView.image = UIImage(named: meditation[0] as! String)
		
		return cell
	}
	
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		setMeditation(index: indexPath.row)
	}
	
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let width = collectionView.bounds.width / 5
		return CGSize(width: width, height: width)
	}
	
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
		return UIEdgeInsets.zero
	}
	
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
		return 0
	}
	
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return 0
	}
}



class MeditationCollectionViewCell: UICollectionViewCell {
	@IBOutlet var containerImageView: UIImageView!
}
