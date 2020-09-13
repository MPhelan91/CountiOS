//
//  CameraEntryPrototype.swift
//  Count
//
//  Created by Michael Phelan on 8/29/20.
//  Copyright © 2020 MichaelPhelan. All rights reserved.
//

import UIKit
import Vision
import VisionKit

class ViewController: UIViewController, VNDocumentCameraViewControllerDelegate {
    var textRecognitionRequest = VNRecognizeTextRequest(completionHandler: nil)
    let textRecognitionWorkQueue = DispatchQueue(label: "TextRecognitionQueue", qos: .userInitiated, attributes: [], autoreleaseFrequency: .workItem)
    
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        // Process the scanned pages
        for pageNumber in 0..<scan.pageCount {
            let image = scan.imageOfPage(at: pageNumber)
        }

        // You are responsible for dismissing the controller.
        controller.dismiss(animated: true)
    }
    
    func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
        // You are responsible for dismissing the controller.
        controller.dismiss(animated: true)
    }
    
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
        // You should handle errors appropriately in your app.
        print(error)

        // You are responsible for dismissing the controller.
        controller.dismiss(animated: true)
    }
}
