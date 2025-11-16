//
//  ContentView.swift
//  DogBreedClassifier
//
//  Created by Karoly Nyisztor on 10/13/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ImageClassifierViewModel()
    @State private var selectedImage: UIImage?
    @State private var showingImagePicker = false
    @State private var showingCamera = false
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Image Display Area
                if let image = selectedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(maxHeight: 400)
                        .cornerRadius(12)
                        .shadow(radius: 5)
                } else {
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 400)
                        
                        VStack(spacing: 10) {
                            Image(systemName: "photo")
                                .font(.system(size: 60))
                                .foregroundColor(.gray)
                            Text("Select or capture an image")
                                .foregroundColor(.secondary)
                        }
                    }
                }
                
                // Classification Results
                if !viewModel.classificationLabel.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(viewModel.classificationLabel)
                            .font(.system(.body, design: .monospaced))
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(8)
                    }
                    .padding(.horizontal)
                }
                
                Spacer()
                
                // Action Buttons
                HStack(spacing: 20) {
                    Button(action: {
                        showingCamera = true
                    }) {
                        Label("Camera", systemImage: "camera.fill")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    
                    Button(action: {
                        showingImagePicker = true
                    }) {
                        Label("Photo Library", systemImage: "photo.on.rectangle")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
            .navigationTitle("Dog Breed Classifier")
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(image: $selectedImage, sourceType: .photoLibrary)
            }
            .sheet(isPresented: $showingCamera) {
                ImagePicker(image: $selectedImage, sourceType: .camera)
            }
            .onChange(of: selectedImage) { oldValue, newValue in
                if let image = newValue {
                    viewModel.classify(image: image)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
