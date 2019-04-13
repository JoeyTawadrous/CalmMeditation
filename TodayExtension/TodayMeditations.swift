import UIKit
import NotificationCenter


class TodayMeditations: UIViewController, UITableViewDataSource, UITableViewDelegate, NCWidgetProviding {
	
	@IBOutlet var tableView: UITableView!
	
	
	
	/* MARK: Initialising
	/////////////////////////////////////////// */
	override func viewDidLoad() {
		super.viewDidLoad()
		extensionContext?.widgetLargestAvailableDisplayMode = .expanded
	}
	
	
	func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
		if activeDisplayMode == .expanded {
			preferredContentSize = CGSize(width: 0.0, height: 220.0)
		}
		else {
			preferredContentSize = CGSize(width: 0.0, height: 180.0)
		}
	}
	
	
	func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
		completionHandler(NCUpdateResult.newData)
	}

	
	
	/* MARK: Table Functionality
	/////////////////////////////////////////// */
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return Constants.Meditations.MEDITATIONS_ALL.count
	}
	
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TodayMeditationCell
		
		let meditation = Constants.Meditations.MEDITATIONS_ALL[indexPath.row] as [Any]
		
		cell.bgImageView?.image = UIImage(named: meditation[0] as! String)
		
		let goal = meditation[2] as? String
		let title = meditation[3] as? String
		cell.titleLabel?.text = title! + " (" + goal! + ")"
		
		return cell
	}
	
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		self.extensionContext?.open(URL(string: "Meditation" + String(indexPath.row) + "://")!, completionHandler: nil)
	}
}



class TodayMeditationCell : UITableViewCell {
	@IBOutlet var bgImageView: UIImageView?
	@IBOutlet var titleLabel: UILabel?
}
