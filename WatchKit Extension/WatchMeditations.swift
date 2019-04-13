import WatchKit
import Foundation
import UIKit


class WatchMeditations: WKInterfaceController {
	
	@IBOutlet var table: WKInterfaceTable!
	
	
	
	/* MARK: Initialising
	/////////////////////////////////////////// */
	override func awake(withContext context: Any?) {
		super.awake(withContext: context)
		
		table.setNumberOfRows(Constants.Meditations.MEDITATIONS_ALL.count, withRowType: "MeditationRow")
		
		for index in 0..<Constants.Meditations.MEDITATIONS_ALL.count{
			guard let controller = table.rowController(at: index) as? MeditationRow else { continue }
			
			let meditation = Constants.Meditations.MEDITATIONS_ALL[index] as [Any]
			controller.meditation = meditation
		}
	}
	
	
	
	/* MARK: Table Functionality
	/////////////////////////////////////////// */
	override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
		let meditation = Constants.Meditations.MEDITATIONS_ALL[rowIndex] as [Any]
		presentController(withName: "WatchMeditation", context: meditation)
	}
}



class MeditationRow: NSObject {
	
	@IBOutlet var titleLabel: WKInterfaceLabel!
	@IBOutlet var imageGroup: WKInterfaceGroup!
	@IBOutlet var image: WKInterfaceImage!
	
	
	var meditation: [Any]? {
		didSet {
			guard let meditation = meditation else { return }
			
			titleLabel.setText((meditation[2] as! String))
			imageGroup.setCornerRadius(5)
			image.setImage(UIImage(named: (meditation[0] as! String)))
		}
	}
}
