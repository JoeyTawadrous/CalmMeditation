import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	
	// MARK: Initialising
	/////////////////////////////////////////// */
	func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
		
		// Purchases
		Purchase.supportStorePurchase()
		Purchase.completeTransactions()
//		Purchase.verifyReceiptCheck()
		
		if (url.scheme != nil) {
			let selectedMeditation = url.scheme?.split(separator: "n") // e.g. Meditation0
			Utils.set(key: Constants.Defaults.SELECTED_MEDITATION, value: Int(selectedMeditation![1])!)
			
			let storyboard = UIStoryboard(name: "Main", bundle: nil)
			let viewController = storyboard.instantiateViewController(withIdentifier: "Meditation")
			self.window?.rootViewController = viewController
		}
		
		return true
	}
	
	func applicationWillEnterForeground(_ application: UIApplication) {
		//		Purchase.restorePurchases(view: self.inputViewController!, showDialog: false)
//		Purchase.verifyReceiptCheck()
	}
	
	func applicationDidFinishLaunching(_ application: UIApplication) {
		UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor(hex: Constants.Colors.PRIMARY_PURPLE)]
	}
}
