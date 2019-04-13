import UIKit
import MessageUI
import KYCircularProgress
import FontAwesome_swift
import SwiftyJSON


class Utils {
	
	// MARK: Data
	/////////////////////////////////////////// */
	class func getCurrentDateString() -> String {
		let date = Date()
		let formatter = DateFormatter()
		formatter.dateFormat = "dd.MM.yyyy"
		return formatter.string(from: date)
	}
	
	class func bool(key: String) -> Bool {
		return UserDefaults.standard.bool(forKey: key)
	}
	
	class func double(key: String) -> Double {
		if Utils.contains(key: key) {
			return UserDefaults.standard.double(forKey:key)
		}
		else {
			return 0.0
		}
	}
	
	class func int(key: String) -> Int {
		if Utils.contains(key: key) {
			return UserDefaults.standard.integer(forKey:key)
		}
		else {
			return 0
		}
	}
	
	class func object(key: String) -> Any {
		return UserDefaults.standard.object(forKey: key)!
	}
	
	class func string(key: String) -> String {
		return UserDefaults.standard.string(forKey: key)!
	}
	
	class func contains(key: String) -> Bool {
		return UserDefaults.standard.object(forKey: key) != nil
	}
	
	class func set(key: String, value: Any) {
		UserDefaults.standard.set(value, forKey: key)
	}
	
	class func remove(key: String) {
		UserDefaults.standard.removeObject(forKey: key)
	}
	
	class func appData() -> JSON {
		var appData = JSON()
		
		if Utils.contains(key: Constants.Defaults.APP_DATA) {
			if let dataFromString = Utils.string(key: Constants.Defaults.APP_DATA).data(using: .utf8, allowLossyConversion: false) {
				do {
					appData = try JSON(data: dataFromString)
				} catch let error {
					print(error.localizedDescription)
				}
			}
		}
		
		return appData
	}
	
	class func setAppData(key: String, json: JSON) {
		var appData = Utils.appData()
		appData[key] = json
		Utils.set(key: Constants.Defaults.APP_DATA, value: appData.rawString()!)
	}
	
	
	
	// MARK: Social
	/////////////////////////////////////////// */
	class func openURL(url: String) {
		let url = URL(string: url)!
		if #available(iOS 10.0, *) {
			UIApplication.shared.open(url, options: [:], completionHandler: nil)
		} else {
			UIApplication.shared.openURL(url)
		}
	}
	
	
	class func openShareView(viewController: UIViewController) {
		let share = Constants.Strings.SHARE
		let link : NSURL = NSURL(string: Constants.Strings.LINK_IOS_STORE)!
		let logo: UIImage = UIImage(named: Constants.Design.LOGO)!
		
		let activityViewController : UIActivityViewController = UIActivityViewController(activityItems: [share, link, logo], applicationActivities: nil)
		
		// This lines is for the popover you need to show in iPad
		activityViewController.popoverPresentationController?.sourceView = viewController.view
		
		// This line remove the arrow of the popover to show in iPad
		activityViewController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection()
		activityViewController.popoverPresentationController?.sourceRect = CGRect(x: 150, y: 150, width: 0, height: 0)
		
		// Anything you want to exclude
		activityViewController.excludedActivityTypes = [
			UIActivityType.postToWeibo,
			UIActivityType.print,
			UIActivityType.assignToContact,
			UIActivityType.saveToCameraRoll,
			UIActivityType.addToReadingList,
			UIActivityType.postToFlickr,
			UIActivityType.postToVimeo,
			UIActivityType.postToTencentWeibo
		]
		
		viewController.present(activityViewController, animated: true, completion: nil)
	}
	
	
	
	// MARK: Visual: Images
	/////////////////////////////////////////// */
	class func createHexagonImageView(imageView: UIImageView, lineWidth: CGFloat, lineColor: UIColor) {
		let path = Utils.roundedPolygonPath(rect: imageView.bounds, lineWidth: lineWidth, sides: 6, cornerRadius: 10, rotationOffset: CGFloat(M_PI / 2.0))
		
		let mask = CAShapeLayer()
		mask.path = path.cgPath
		mask.lineWidth = lineWidth
		mask.strokeColor = UIColor.clear.cgColor
		mask.fillColor = UIColor.white.cgColor
		imageView.layer.mask = mask
		
		let border = CAShapeLayer()
		border.path = path.cgPath
		border.lineWidth = lineWidth
		border.strokeColor = lineColor.cgColor
		border.fillColor = UIColor.clear.cgColor
		imageView.layer.addSublayer(border)
	}
	
	class func roundedPolygonPath(rect: CGRect, lineWidth: CGFloat, sides: NSInteger, cornerRadius: CGFloat, rotationOffset: CGFloat = 0)
		-> UIBezierPath {
			let path = UIBezierPath()
			let theta: CGFloat = CGFloat(2.0 * M_PI) / CGFloat(sides) // How much to turn at every corner
			let offset: CGFloat = cornerRadius * tan(theta / 2.0)     // Offset from which to start rounding corners
			let width = min(rect.size.width, rect.size.height)        // Width of the square
			
			let center = CGPoint(x: rect.origin.x + width / 2.0, y: rect.origin.y + width / 2.0)
			
			// Radius of the circle that encircles the polygon
			// Notice that the radius is adjusted for the corners, that way the largest outer
			// dimension of the resulting shape is always exactly the width - linewidth
			let radius = (width - lineWidth + cornerRadius - (cos(theta) * cornerRadius)) / 2.0
			
			// Start drawing at a point, which by default is at the right hand edge
			// but can be offset
			var angle = CGFloat(rotationOffset)
			
			let corner = CGPoint(x: center.x + (radius - cornerRadius) * cos(angle), y: center.y + (radius - cornerRadius) * sin(angle))
			path.move(to: CGPoint(x: corner.x + cornerRadius * cos(angle + theta), y: corner.y + cornerRadius * sin(angle + theta)))
			
			for _ in 0 ..< sides {
				angle += theta
				
				let corner = CGPoint(x: center.x + (radius - cornerRadius) * cos(angle), y: center.y + (radius - cornerRadius) * sin(angle))
				let tip = CGPoint(x: center.x + radius * cos(angle), y: center.y + radius * sin(angle))
				let start = CGPoint(x: corner.x + cornerRadius * cos(angle - theta), y: corner.y + cornerRadius * sin(angle - theta))
				let end = CGPoint(x: corner.x + cornerRadius * cos(angle + theta), y: corner.y + cornerRadius * sin(angle + theta))
				
				path.addLine(to: start)
				path.addQuadCurve(to: end, controlPoint: tip)
			}
			
			path.close()
			
			// Move the path to the correct origins
			let bounds = path.bounds
			let transform = CGAffineTransform(translationX: -bounds.origin.x + rect.origin.x + lineWidth / 2.0,
											  y: -bounds.origin.y + rect.origin.y + lineWidth / 2.0)
			path.apply(transform)
			
			return path
	}
	
	
	
	// MARK: Visual: UI Elements
	/////////////////////////////////////////// */
	class func createProgressView(progressView: KYCircularProgress, color: String, guideColor: String) -> KYCircularProgress {
		progressView.colors = [UIColor(hex: color)]
		progressView.guideColor = UIColor(hex: guideColor)
		progressView.lineCap = kCALineCapRound
		progressView.guideLineWidth = 6.0
		return progressView
	}
	
	
	
	// MARK: Visual
	/////////////////////////////////////////// */
	class func getViewController(_ viewName: String) -> UIViewController {
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		let vc = storyboard.instantiateViewController(withIdentifier: viewName) as UIViewController
		return vc
	}
	
	class func presentView(_ view: UIViewController, viewName: String) {
		view.present(getViewController(viewName), animated: true, completion: nil)
	}
	
	class func popView(view: UIViewController) {
		view.navigationController?.popViewController(animated: true)
		view.dismiss(animated: true, completion: nil)
	}
	
	class func createFontAwesomeBarButton(button: UIBarButtonItem, icon: FontAwesome, style: FontAwesomeStyle) {
		var attributes = [NSAttributedStringKey : Any]()
		attributes = [.font: UIFont.fontAwesome(ofSize: 21, style: style)]
		button.setTitleTextAttributes(attributes, for: .normal)
		button.setTitleTextAttributes(attributes, for: .selected)
		button.title = String.fontAwesomeIcon(name: icon)
	}
	
	class func createFontAwesomeButton(button: UIButton, size: CGFloat, icon: FontAwesome, style: FontAwesomeStyle) {
		button.titleLabel?.font = UIFont.fontAwesome(ofSize: size, style: style)
		button.setTitle(String.fontAwesomeIcon(name: icon), for: .normal)
	}
}
