//
//  CustomRightSegue.swift
//  ChordBox
//
//  Created by Minho Choi on 2021/02/19.
//

import UIKit

class right: UIStoryboardSegue {
    
    override init(identifier: String?, source: UIViewController, destination: UIViewController) {
        super.init(identifier: identifier, source: source, destination: destination)
    }
    
    override func perform() {
        let src = self.source as UIViewController
        let dst = self.destination as UIViewController
        src.view.superview?.insertSubview(dst.view, aboveSubview: src.view)
        dst.view.transform = CGAffineTransform(translationX: src.view.frame.size.width, y: 0)
        UIView.animate(
            withDuration: 0.25,
            delay: 0,
            options: .curveEaseInOut,
            animations: {
                dst.view.transform = CGAffineTransform(translationX: 0, y: 0)
                src.view.transform = CGAffineTransform(translationX: -src.view.frame.size.width/3, y: 0)
            },
            completion: { finished in
                src.present(dst, animated: false, completion: nil)
            })
    }
}

class unwind_right: UIStoryboardSegue {
    
    override init(identifier: String?, source: UIViewController, destination: UIViewController) {
        super.init(identifier: identifier, source: source, destination: destination)
    }
    
    override func perform() {
        let src = self.source as UIViewController
        let dst = self.destination as UIViewController
        src.view.superview?.insertSubview(dst.view, belowSubview: src.view)
        src.view.transform = CGAffineTransform(translationX: 0, y: 0)
        dst.view.transform = CGAffineTransform(translationX: -src.view.frame.size.width/3, y: 0)
        UIView.animate(
            withDuration: 0.25,
            delay: 0,
            options: .curveEaseInOut,
            animations: {
                src.view.transform = CGAffineTransform(translationX: src.view.frame.size.width, y: 0)
                dst.view.transform = CGAffineTransform(translationX: 0, y: 0)
            },
            completion: { finished in
                src.dismiss(animated: false, completion: nil)
            })
    }
}
