import UIKit


class LCircleButton: UIButton {
	override open func layoutSubviews() {
		super.layoutSubviews()
		layer.cornerRadius = self.frame.width / 2
		clipsToBounds = true
		layer.masksToBounds = true
	}
}


class LCircleImageView: UIImageView {
	override open func layoutSubviews() {
		super.layoutSubviews()
		layer.cornerRadius = self.frame.width / 2
		clipsToBounds = true
		layer.masksToBounds = true
	}
}
