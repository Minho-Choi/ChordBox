//
//  ExerciseViewController.swift
//  ChordBox
//
//  Created by Minho Choi on 2021/03/06.
//

import UIKit

class ExerciseViewController: UIViewController {

    let metronomeView = MetronomeView(frame: CGRect(x: 30, y: 60, width: 70, height: 300))
    let beatHighlightView = BeatHighlightView()
    override func viewDidLoad() {
        super.viewDidLoad()
        beatHighlightView.frame = self.view.frame
        view.insertSubview(beatHighlightView, at: 0)
        beatHighlightView.fill(frame: self.view.frame)
        view.addSubview(metronomeView)
        view.layer.borderWidth = 2.0
        view.layer.borderColor = UIColor.red.cgColor
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        metronomeView.setConstraints()
    }

}

#if canImport(SwiftUI) && DEBUG
import SwiftUI
@available(iOS 13.0, *)
struct MainVcRepresentble: UIViewRepresentable {
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<MainVcRepresentble>) {
        print("updateUIView")
    }
    
    func makeUIView(context: Context) -> UIView { ExerciseViewController().view }
    
}
@available(iOS 13.0, *)
struct MainVcPreview: PreviewProvider {
    static var previews: some View { Group {
        MainVcRepresentble()
    } }
}
#endif
