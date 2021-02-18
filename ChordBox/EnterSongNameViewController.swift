//
//  EnterSongNameViewController.swift
//  ChordBox
//
//  Created by Minho Choi on 2021/02/11.
//

import UIKit

class EnterSongNameViewController: UIViewController, UITextFieldDelegate {
    

    @IBOutlet weak var songTitleOutlet: UITextField!
    @IBOutlet weak var artistNameOutlet: UITextField!
    var lyrics: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func fetchLyricsDataFromFreeAPI(title: String, artist: String) {
        let url = URL(string: "https://api.lyrics.ovh/v1/\(artist)/\(title)")
        let session = URLSession.shared
        DispatchQueue.global(qos: .userInitiated).async {
            if let validURL = url {
                let dataTask = session.dataTask(with: validURL) { (data, response, error) in
                    guard error == nil else {
                        print("Error occur: \(String(describing: error))")
                        return
                    }
                    guard let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                        print("Not Found")
                        return
                    }
                    do {
                        let lyricsJSON = try JSONDecoder().decode(LyricsJSON.self, from: data)
                        self.lyrics = lyricsJSON.lyrics
                        print("lyrics: \(self.lyrics)")
                    } catch {
                        print("JSON Parsing Error")
                        print(error.localizedDescription)
                    }
                }
                dataTask.resume()
            } else {
                print("invalid url : \(String(describing: url?.absoluteString))")
            }
            }
        }
        
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        print("button pressed")
        if let title = songTitleOutlet.text, let artist = artistNameOutlet.text {
            fetchLyricsDataFromFreeAPI(title: title.replacingOccurrences(of: " ", with: "%20"), artist: artist)
        }
    }
}

struct LyricsJSON : Codable {
    var lyrics: String
}
