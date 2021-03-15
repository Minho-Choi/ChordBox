//
//  EnterSongNameViewController.swift
//  ChordBox
//
//  Created by Minho Choi on 2021/02/11.
//

import UIKit

class EnterSongNameViewController: UIViewController {

    // TextFields (must be replaced by code definition)
    @IBOutlet weak var songTitleOutlet: UITextField!
    @IBOutlet weak var artistNameOutlet: UITextField!
    
    var lyrics: String = ""
    let loadingView = LoadingView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        songTitleOutlet.autocorrectionType = .no
        artistNameOutlet.autocorrectionType = .no

    }
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        print("button pressed")
        view.endEditing(true)
        if let title = songTitleOutlet.text?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
           let artist = artistNameOutlet.text?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            fetchLyricsDataFromFreeAPI(title: title, artist: artist, identifier: "FoundLyricsSegue", sender: sender)
        }
    }
    
    // fetches lyrics data from lyrics api by urlsession
    func fetchLyricsDataFromFreeAPI(title: String, artist: String, identifier: String, sender: UIButton) {
        self.view.addSubview(loadingView)
        NSLayoutConstraint.activate([
            loadingView.topAnchor.constraint(equalTo: view.topAnchor),
            loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            loadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        loadingView.addViews(frame: view.frame, title: "Searching Lyrics".localized + "\r\n\(artist.removingPercentEncoding!) -  \(title.removingPercentEncoding!)")
        loadingView.startAnimating()

        let url = URL(string: "https://api.lyrics.ovh/v1/\(artist)/\(title)")
        let session = URLSession.shared
        DispatchQueue.global(qos: .utility).async {
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
                        DispatchQueue.main.async {
                            self.loadingView.stopAnimating()
                            self.performSegue(withIdentifier: identifier, sender: sender)
                        }

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
    
    // segue data preparation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FoundLyricsSegue" {
            let vc = segue.destination as! ShowLyricsViewController
            vc.songInfo = Sheet(title: songTitleOutlet.text!, singer: artistNameOutlet.text!, lyricsString: self.lyrics.replacingOccurrences(of: "\r\n", with: "\n").replacingOccurrences(of: "\n\n", with: "\n"))
        }
    }
}

// JSON parser struct
struct LyricsJSON: Codable {
    var lyrics: String
}
