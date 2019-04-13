import UIKit
import SwiftySound


class ChooseSound: UITableViewController {
	
	@IBOutlet var backButton: UIBarButtonItem!
	private var selectedSound: String!


	
	/* MARK: Initialising
	/////////////////////////////////////////// */
	override func viewDidLoad() {
		// Styling
		Utils.createFontAwesomeBarButton(button: backButton, icon: .arrowLeft, style: .solid)
	}
	
	override func viewWillAppear(_ animated: Bool) {
		
	}
	
	override var prefersStatusBarHidden: Bool {
		return true
	}
	
	
	
	/* MARK: Actions
	/////////////////////////////////////////// */
	@IBAction func backButtonPressed() {
		Utils.presentView(self, viewName: Constants.Views.RUN_MEDITATION)
	}
	
	
	
	/* MARK: Table
	/////////////////////////////////////////// */
	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return Constants.Meditations.MEDITATION_SOUNDS.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		var cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
		if(cell == nil) { cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "Cell") }
		
		let sound = Constants.Meditations.MEDITATION_SOUNDS[indexPath.row][0] as? String
		cell!.textLabel!.text = sound?.replacingOccurrences(of: "_", with: " ")
		
		// Style
		cell!.backgroundColor = UIColor.clear
		cell!.textLabel?.font = UIFont.GothamProMedium(size: 15.0)
		cell!.textLabel?.textColor = UIColor(hex: Constants.Colors.PRIMARY_TEXT_GRAY)
		cell!.tintColor = UIColor(hex: Constants.Colors.PRIMARY_TEXT_GRAY)
		cell!.selectionStyle = .none
		
		// Add tick
		cell!.accessoryType = UITableViewCellAccessoryType.none
		if Utils.contains(key: Constants.Defaults.SELECTED_MEDITATION_SOUND) {
			selectedSound = Utils.string(key: Constants.Defaults.SELECTED_MEDITATION_SOUND)
		}
		if cell!.textLabel!.text == selectedSound {
			cell!.accessoryType = UITableViewCellAccessoryType.checkmark
		}
		
		return cell!
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let cell = tableView.cellForRow(at: indexPath)
		
		if (Constants.Meditations.MEDITATION_SOUNDS[indexPath.row][1] as? Bool)! && !Purchase.hasUpgraded() { // Premium sound
			Utils.set(key: Constants.Defaults.PREVIOUS_VIEW, value: Constants.Views.CHOOSE_SOUND_NAV_CONTROLLER)
			Utils.presentView(self, viewName: Constants.Views.UPGRADE)
		}
		else {
			selectedSound = cell?.textLabel?.text!.replacingOccurrences(of: " ", with: "_")
			Utils.set(key: Constants.Defaults.SELECTED_MEDITATION_SOUND, value: selectedSound)
			
			// Music
			Sound.stopAll()
			Sound.play(file: (Constants.Meditations.MEDITATION_SOUNDS[indexPath.row][0] as? String)!, fileExtension: "mp3", numberOfLoops: -1)
			
			// Add tick
			cell?.accessoryType = UITableViewCellAccessoryType.checkmark
			
			// Remove tick
			let cells = tableView.visibleCells
			for c in cells {
				let section = tableView.indexPath(for: c)?.section
				if (section == indexPath.section && c != cell) {
					c.accessoryType = UITableViewCellAccessoryType.none
				}
			}
		}
	}
}
