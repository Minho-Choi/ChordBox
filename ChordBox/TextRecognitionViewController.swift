//
//  TextRecognitionViewController.swift
//  ChordBox
//
//  Created by Minho Choi on 2021/02/10.
//

import UIKit
import Vision
import VisionKit

class TextRecognitionViewController: UIViewController {

    private var scanButton = ScanButton(frame: .zero)
    private var scanImageView = ScanImageView(frame: .zero)
    private var ocrTextView = OcrTextView(frame: .zero, textContainer: nil)
    private var ocrRequest = VNRecognizeTextRequest(completionHandler: nil)

    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
        configureOCR()
        // Do any additional setup after loading the view.
    }

    private func configure() {
        view.addSubview(scanImageView)
        view.addSubview(ocrTextView)
        view.addSubview(scanButton)

        let padding: CGFloat = 16
        NSLayoutConstraint.activate([
            scanButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: padding),
            scanButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -padding),
            scanButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -padding),
            scanButton.heightAnchor.constraint(equalToConstant: 50),
            ocrTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: padding),
            ocrTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -padding),
            ocrTextView.bottomAnchor.constraint(equalTo: scanButton.topAnchor, constant: -padding),
            ocrTextView.heightAnchor.constraint(equalToConstant: 200),
            scanImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: padding),
            scanImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
            scanImageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -padding),
            scanImageView.bottomAnchor.constraint(equalTo: ocrTextView.topAnchor, constant: -padding)
        ])

        scanButton.addTarget(self, action: #selector(scanDocument), for: .touchUpInside)
    }

    @objc private func scanDocument() {
        let scanVC = VNDocumentCameraViewController()
        scanVC.delegate = self
        present(scanVC, animated: true)
    }

    private func processImage(_ image: UIImage) {
        guard let cgImage = image.cgImage else { return }

        ocrTextView.text = ""
        scanButton.isEnabled = false
        let requestHander = VNImageRequestHandler(cgImage: cgImage, options: [:])
        do {
            try requestHander.perform([self.ocrRequest])
        } catch {
            print(error)
        }
    }

    private func configureOCR() {
        ocrRequest = VNRecognizeTextRequest { (request, _) in
            guard let observations = request.results as? [VNRecognizedTextObservation] else { return }
            var ocrText = ""
            for observation in observations {
                guard let topCandidate = observation.topCandidates(1).first else { return }

                ocrText += topCandidate.string + "\n"
            }

            DispatchQueue.main.async {
                self.ocrTextView.text = ocrText
                self.scanButton.isEnabled = true
            }
        }

        ocrRequest.recognitionLevel = .accurate
        ocrRequest.recognitionLanguages = ["en-US"]
        ocrRequest.usesLanguageCorrection = false
        ocrRequest.customWords = ["13",
                                  "7(#9)",
                                  "9",
                                  "9b5",
                                  "maj13",
                                  "7",
                                  "dim7",
                                  "aug",
                                  "maj",
                                  "13(#11)",
                                  "11",
                                  "maj9",
                                  "sus2",
                                  "7(b13)",
                                  "m11",
                                  "add9",
                                  "m7b5",
                                  "m",
                                  "7b5",
                                  "9(#11)",
                                  "m7",
                                  "dim",
                                  "6",
                                  "7(#5)",
                                  "7sus4",
                                  "maj7",
                                  "5",
                                  "7(#11)",
                                  "13(#9)",
                                  "m6",
                                  "7(b9)",
                                  "m9",
                                  "13(b9)",
                                  "sus4",
                                  "6add9"]
    }

}

extension TextRecognitionViewController: VNDocumentCameraViewControllerDelegate {
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        guard scan.pageCount >= 1 else {
            controller.dismiss(animated: true)
            return
        }
        // code for text recognition

        scanImageView.image = scan.imageOfPage(at: 0)
        processImage(scan.imageOfPage(at: 0))
        controller.dismiss(animated: true)

        controller.dismiss(animated: true)
    }

    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
        // handle property error
        controller.dismiss(animated: true)
    }

    func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
        controller.dismiss(animated: true)
    }
}
