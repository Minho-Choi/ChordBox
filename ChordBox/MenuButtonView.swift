//
//  MenuButtonView.swift
//  ChordBox
//
//  Created by Minho Choi on 2021/02/22.
//

import UIKit

class MenuButtonView: UIView {

    var textLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
//        fatalError("init(coder:) has not been implemented")
    }

    func updateView(title: String, imageName: String) {
        self.layer.sublayers?.remove(at: 0)
        self.subviews.forEach { view in
            view.removeFromSuperview()
        }
        self.clipsToBounds = true

        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = [UIColor.CustomPalette.backgroundColor.cgColor, UIColor.CustomPalette.textColor.cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)

        self.layer.insertSublayer(gradient, at: 0)

        layer.cornerRadius = 10

        textLabel.textColor = UIColor.CustomPalette.backgroundColor
        let attrTitle = NSMutableAttributedString(string: title)
        attrTitle.addAttribute(.font, value: UIFont.preferredFont(forTextStyle: .title1), range: (title as NSString).range(of: title))
        attrTitle.addAttribute(.foregroundColor, value: UIColor.CustomPalette.backgroundColor, range: (title as NSString).range(of: title))
        textLabel.attributedText = attrTitle
        textLabel.textAlignment = .center
        textLabel.numberOfLines = 0
        let textLabelSize = self.bounds.width * 0.8
        textLabel.frame = CGRect(
            x: self.bounds.midX - textLabelSize/2,
            y: 0.75 * self.bounds.height,
            width: textLabelSize,
            height: self.bounds.height * 0.2)
        addSubview(textLabel)

        let iconImage = UIImage(systemName: imageName)
        let imageView = UIImageView(image: iconImage)
        imageView.contentMode = .scaleAspectFit
        let imageViewSize = min(self.bounds.height * 0.5, self.bounds.width * 0.8)
        imageView.frame = CGRect(
            x: self.bounds.midX - imageViewSize/2,
            y: self.bounds.midY - imageViewSize/2,
            width: imageViewSize,
            height: imageViewSize)
        imageView.tintColor = .white
        addSubview(imageView)
    }

}
