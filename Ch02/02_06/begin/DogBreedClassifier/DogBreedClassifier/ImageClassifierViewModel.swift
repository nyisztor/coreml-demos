//
//  ImageClassifierViewModel.swift
//  DogBreedClassifier
//
//  Created by Karoly Nyisztor on 10/22/25.
//

import SwiftUI
import Combine
import Vision

class ImageClassifierViewModel: ObservableObject {
    @Published var classificationLabel: String = ""
    @Published var confidence: String = ""
    
    private lazy var classificationRequest: VNCoreMLRequest = {
        do {
            let model = try VNCoreMLModel(for: DogBreedClassifier().model)
            let request = VNCoreMLRequest(model: model)
            request.imageCropAndScaleOption = .centerCrop
            return request
        } catch {
            fatalError("Failed to load Vision ML model: \(error)")
        }
    }()
}
