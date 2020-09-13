//
//  NutritionFactsScanner.swift
//  Count
//
//  Created by Michael Phelan on 8/30/20.
//  Copyright © 2020 MichaelPhelan. All rights reserved.
//

import SwiftUI
import Vision
import VisionKit

final class TextRecognizer {
    let cameraScan: VNDocumentCameraScan
     
    init(cameraScan: VNDocumentCameraScan) {
        self.cameraScan = cameraScan
    }
     
    private let queue = DispatchQueue(label: "com.michaelphelan.count", qos: .default, attributes: [], autoreleaseFrequency: .workItem)
     
    func recognizeText(withCompletionHandler completionHandler: @escaping ([String]) -> Void) {
        queue.async {
            let images = (0..<self.cameraScan.pageCount).compactMap({ self.cameraScan.imageOfPage(at: $0).cgImage })
            let imagesAndRequests = images.map({ (image: $0, request: VNRecognizeTextRequest()) })
            let textPerPage = imagesAndRequests.map { image, request -> String in
                let handler = VNImageRequestHandler(cgImage: image, options: [:])
                do {
                    try handler.perform([request])
                    guard let observations = request.results as? [VNRecognizedTextObservation] else { return "" }
                    
                    return observations.compactMap({ $0.topCandidates(1).first?.string }).joined(separator: " ")
                }
                catch {
                    print(error)
                    return ""
                }
            }
            DispatchQueue.main.async {
                completionHandler(textPerPage)
            }
        }
    }
}

struct NutritionFactScanner: UIViewControllerRepresentable {
    private let completionHandler: ([String]?) -> Void
     
    init(completion: @escaping ([String]?) -> Void) {
        self.completionHandler = completion
    }
     
    typealias UIViewControllerType = VNDocumentCameraViewController
     
    func makeUIViewController(context: UIViewControllerRepresentableContext<NutritionFactScanner>) -> VNDocumentCameraViewController {
        let viewController = VNDocumentCameraViewController()
        viewController.delegate = context.coordinator
        return viewController
    }
     
    func updateUIViewController(_ uiViewController: VNDocumentCameraViewController, context: UIViewControllerRepresentableContext<NutritionFactScanner>) {}
     
    func makeCoordinator() -> Coordinator {
        return Coordinator(completion: completionHandler)
    }
     
    final class Coordinator: NSObject, VNDocumentCameraViewControllerDelegate {
        private let completionHandler: ([String]?) -> Void
         
        init(completion: @escaping ([String]?) -> Void) {
            self.completionHandler = completion
        }
         
        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
            print("Document camera view controller did finish with ", scan)
            let recognizer = TextRecognizer(cameraScan: scan)
            recognizer.recognizeText(withCompletionHandler: completionHandler)
            controller.dismiss(animated: true)
        }
         
        func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
            completionHandler(nil)
            controller.dismiss(animated: true)
        }
         
        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
            print("Document camera view controller did finish with error ", error)
            completionHandler(nil)
            controller.dismiss(animated: true)
        }
    }
}
