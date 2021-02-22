//
//  LoadingView.swift
//  ChordBox
//
//  Created by Minho Choi on 2021/02/18.
//

import UIKit

class LoadingView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    var spinner = UIActivityIndicatorView()
    let infoTextLabel = UILabel()
    let outerVisualEffectView = UIVisualEffectView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
//        fatalError("init(coder:) has not been implemented")
    }
    
    func addViews(frame: CGRect, title: String) {
        let spinnerSize = frame.width/4
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.style = .large
        spinner.color = UIColor.CustomPalette.pointColor

        let blurEffect = UIBlurEffect(style: .regular)
        outerVisualEffectView.effect = blurEffect
        addSubview(outerVisualEffectView)
        outerVisualEffectView.frame = frame
        
//        let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
//        let innerVisualEffectView = UIVisualEffectView(effect: vibrancyEffect)
//        innerVisualEffectView.frame = frame
//
//        outerVisualEffectView.contentView.addSubview(innerVisualEffectView)
//
//
//        innerVisualEffectView.contentView.addSubview(spinner)
        
        
        infoTextLabel.translatesAutoresizingMaskIntoConstraints = false
        infoTextLabel.text = title
        infoTextLabel.textAlignment = .center
        infoTextLabel.numberOfLines = 2
        infoTextLabel.textColor = UIColor.CustomPalette.textColor
//        infoTextLabel.tintColor = UIColor.CustomPalette.backgroundColor
//        infoTextLabel.backgroundColor = UIColor.CustomPalette.shadeColor1
        infoTextLabel.font = .preferredFont(forTextStyle: .headline)
//        infoTextLabel.layer.borderWidth = 10
//        infoTextLabel.layer.borderColor = UIColor.white.cgColor
        
        outerVisualEffectView.contentView.addSubview(spinner)
        outerVisualEffectView.contentView.addSubview(infoTextLabel)
        
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor),
            spinner.widthAnchor.constraint(equalToConstant: spinnerSize),
            spinner.heightAnchor.constraint(equalToConstant: spinnerSize),
            
            infoTextLabel.bottomAnchor.constraint(equalTo: spinner.topAnchor),
            infoTextLabel.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            infoTextLabel.heightAnchor.constraint(equalToConstant: 80)
        ])
        // view를 addSubView 한 뒤 constraint를 설정해야 함(view hierarchy 때문)
    }
    
    func startAnimating() {
        spinner.startAnimating()
        self.alpha = 1
        self.isHidden = false
    }
    
    func stopAnimating() {
        spinner.stopAnimating()
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
            self.alpha = 0
        }, completion: {_ in
            self.isHidden = true
        })
        infoTextLabel.removeFromSuperview()
    }
}
