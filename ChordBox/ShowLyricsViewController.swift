//
//  ShowLyricsViewController.swift
//  ChordBox
//
//  Created by Minho Choi on 2021/02/19.
//

import UIKit

class ShowLyricsViewController: UIViewController {
    
    var lyricsView = UILabel()
    var nextButton = UIButton()
    var scrollView = UIScrollView()
    var lyrics : String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        lyricsView.text = lyrics.replacingOccurrences(of: "\r\n", with: "\n\n").replacingOccurrences(of: "\n", with: "\n\n").replacingOccurrences(of: "\n\n\n\n", with: "\n\n")
        nextButton.setTitle("Next", for: .normal)
        nextButton.setTitleColor(.blue, for: .normal)
        lyricsView.translatesAutoresizingMaskIntoConstraints = false
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        lyricsView.numberOfLines = 0
        lyricsView.textAlignment = .center
        lyricsView.lineBreakMode = .byCharWrapping
        lyricsView.lineBreakStrategy = .pushOut
        scrollView.addSubview(lyricsView)
        view.addSubview(scrollView)
        view.addSubview(nextButton)

        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -60),
            
            nextButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            nextButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            nextButton.heightAnchor.constraint(equalToConstant: 60),
            
            lyricsView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            lyricsView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            lyricsView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            lyricsView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor)
        ])
    }
    
    

}
