//
//  ShowLyricsViewController.swift
//  ChordBox
//
//  Created by Minho Choi on 2021/02/19.
//

import UIKit

class ShowLyricsViewController: UIViewController {
    
    @IBOutlet weak var lyricsViewOutlet: UILabel!
    var lyrics : String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        lyricsViewOutlet.text = lyrics.replacingOccurrences(of: "\r\n", with: "\n\n").replacingOccurrences(of: "\n", with: "\n\n").replacingOccurrences(of: "\n\n\n\n", with: "\n\n")
        // Do any additional setup after loading the view.
    }

}
