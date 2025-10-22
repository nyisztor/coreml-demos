//
//  ImageClassifierViewModel.swift
//  DogBreedClassifier
//
//  Created by Karoly Nyisztor on 10/22/25.
//

import SwiftUI
import Vision
import Combine

@MainActor
class ImageClassifierViewModel: ObservableObject {
    @Published var classificationLabel: String = ""
    @Published var confidence: String = ""
    
    private lazy var classificationRequest: VNCoreMLRequest = {
        do {
            let model = try VNCoreMLModel(for: DogClassifier().model)
            let request = VNCoreMLRequest(model: model)
            request.imageCropAndScaleOption = .centerCrop
            return request
        } catch {
            fatalError("Failed to load Vision ML model: \(error)")
        }
    }()
    
    func classify(image: UIImage) {
        guard let ciImage = CIImage(image: image) else {
            classificationLabel = "Unable to process image."
            return
        }
        
        Task {
            let handler = VNImageRequestHandler(ciImage: ciImage, orientation: .up)
            
            do {
                try handler.perform([classificationRequest])
                processClassifications(for: classificationRequest, error: nil)
            } catch {
                processClassifications(for: classificationRequest, error: error)
            }
        }
    }
    
    private func processClassifications(for request: VNRequest, error: Error?) {
        guard let results = request.results else {
            self.classificationLabel = "Unable to classify image.\n\(error?.localizedDescription ?? "Unknown error")"
            self.confidence = ""
            return
        }
        
        let classifications = results as! [VNClassificationObservation]
        
        if classifications.isEmpty {
            self.classificationLabel = "Nothing recognized."
            self.confidence = ""
        } else {
            let topClassifications = classifications.prefix(2)
            let descriptions = topClassifications.map{ classification in "\(classification.identifier): \(Int(classification.confidence * 100))%"}
            
            self.classificationLabel = "Classification:\n" + descriptions.joined(separator: "\n")
        }
    }
}
