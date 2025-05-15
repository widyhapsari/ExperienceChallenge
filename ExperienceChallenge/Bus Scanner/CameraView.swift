//
//  CameraView.swift
//  ExperienceChallenge
//
//  Created by Rastya Widya Hapsari on 09/05/25.
//

import SwiftUI
import AVFoundation
import Vision
import CoreImage

enum CameraViewSource {
    case home
    case scanner
}

struct CameraView: View {
    @State private var showRouteFinderView = false
    @State private var recognizedPlate: String?
    @State private var showScanResult = false
    @State private var isShowingManualInput = false
    @State private var isCameraAuthorized = false
    @State private var capturedImage: CVPixelBuffer?
    @State private var isPlateDetected = false
    @State private var isProcessing = false
    @State private var detectedPlateText = ""
    @State private var scanFrameRect = CGRect(x: 0, y: 0, width: 250, height: 150)
//    @State private var showRouteHistory = false
    @Environment(\.presentationMode) var presentationMode
    let source: CameraViewSource
    let stop: BusStop
    @State private var searchText: String = ""
    @FocusState private var isSearchFocused: Bool
    @Environment(\.dismiss) var dismiss
    @State private var showSearch = false
    @State private var selectedPlate: BusInfo? = nil
    
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Camera view
                CameraScanner(recognizedPlate: $recognizedPlate,
                        showScanResult: $showScanResult,
                        capturedImage: $capturedImage,
                        isPlateDetected: $isPlateDetected,
                        detectedPlateText: $detectedPlateText,
                        scanFrameRect: $scanFrameRect,
                        manualCapture: false)
                .edgesIgnoringSafeArea(.all)

                VStack {
                    // Search bar
                    if source == .home {
                        SearchBarIsland(
                            searchText: $searchText,
                            isFocused: $isSearchFocused,
                            mode: .changeDestination,
                            onTap: {
                                dismiss()
                            }
                        )
                    }

                    Spacer()

                    // Frame & Instructions
                    VStack(spacing: 104) {
                        VStack(spacing: 20) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.ecOrange, lineWidth: 3)
                                    .frame(width: 300, height: 180)
                                    .foregroundColor(isPlateDetected ? .green : .white)
                                    .background(Color.clear)
                                    .overlay(
                                        GeometryReader { geometry in
                                            Color.clear
                                                .onAppear {
                                                    scanFrameRect = geometry.frame(in: .global)
                                                }
                                        }
                                    )

                                if isPlateDetected {
                                    Text(detectedPlateText)
                                        .font(.caption)
                                        .padding(4)
                                        .background(Color.black.opacity(0.6))
                                        .foregroundColor(.white)
                                        .cornerRadius(4)
                                        .position(x: 125, y: 130)
                                }
                            }
                            .frame(width: 250, height: 150)

                            Text("Place the bus plate number\ninside the box and snap")
                                .font(.system(size: 15, weight: .medium))
                                .multilineTextAlignment(.center)
                                .foregroundColor(.white)
                                .padding(11)
                        }

                        // Snap + Manual Button
                        VStack(spacing: 12) {
                            NavigationLink(destination: ResultView(source: source, showResultCard: source == .home, busInfo: BusInfo(
                                plateNumber: "B 1234 XYZ",
                                routeCode: "BC",
                                routeName: "The Breeze - AEON - ICE - The Breeze Loop Line"
                            ), searchText: "Studento")) {
                                Text("Snap!")
                                    .scaledFont(size: 16, weight: .bold)
                                    .foregroundColor(.white)
                                    .frame(width: 280, height: 40)
                                    .background(Color(.ecOrange))
                                    .cornerRadius(12)
                            }
                                

                            Button("Enter bus plate") {
                                showSearch = true
                            }
                            .scaledFont(size: 16, weight: .regular)
                            .foregroundColor(.ecOrange)
                            .frame(width: 280, height: 40)
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(12)
                        }
                        .padding(.bottom, 100)
                    }
                }
            }
            .onAppear {
                searchText = stop.name
            }
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    HStack {
                        Button {
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.white)
                            Text("Back")
                                .foregroundColor(.white)
                                .font(.title3)
                        }
                        TutorialButton()
                    }
                }
            }
            // Invisible navigation trigger
            if let plate = selectedPlate {
                NavigationLink(value: plate) {
                    EmptyView()
                }
            }
        }
        .sheet(isPresented: $showSearch) {
            NavigationStack {
                SearchPlateManually(
                    selectedPlate: $selectedPlate,
                    dismiss: { showSearch = false }
                )
            }
            .presentationDetents([.medium])
            .presentationDragIndicator(.visible)
        }
        .navigationDestination(item: $selectedPlate) { plate in
            ResultView(
                source: source,
                showResultCard: source == .home,
                busInfo: plate,
                searchText: searchText
            )
        }
        .alert(isPresented: .constant(!isCameraAuthorized && AVCaptureDevice.authorizationStatus(for: .video) == .denied)) {
            Alert(
                title: Text("Camera Access Required"),
                message: Text("B-Link needs camera access to scan bus plates. Please enable it in Settings."),
                primaryButton: .default(Text("Settings"), action: {
                    if let url = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(url)
                    }
                }),
                secondaryButton: .cancel()
            )
        }
    }
    private func captureAndAnalyze() {
        if isProcessing { return }
        
        isProcessing = true
        
        if isPlateDetected && isValidIndonesianPlate(detectedPlateText) {
            // If plate is already detected and valid, use the detected text
            recognizedPlate = detectedPlateText
            showScanResult = true
            isProcessing = false
        } else if let pixelBuffer = capturedImage {
            // Otherwise try to analyze the current frame
            analyzeImage(pixelBuffer)
        } else {
            isProcessing = false
        }
    }
    
    private func isValidIndonesianPlate(_ text: String) -> Bool {
        // Check if the text matches the Indonesian plate format
        // 1-2 letters (region) + 1-4 digits (number) + 1-3 letters (identifier)
        let platePattern = "^[A-Z]{1,2}\\s?\\d{1,4}\\s?[A-Z]{1,3}$"
        return text.range(of: platePattern, options: .regularExpression) != nil
    }
    
    private func checkCameraPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            isCameraAuthorized = true
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    self.isCameraAuthorized = granted
                }
            }
        case .denied, .restricted:
            isCameraAuthorized = false
        @unknown default:
            isCameraAuthorized = false
        }
    }
    
    private func analyzeImage(_ pixelBuffer: CVPixelBuffer) {
        // Create a request to recognize text
        let request = VNRecognizeTextRequest { request, error in
            guard error == nil else {
                DispatchQueue.main.async {
                    self.isProcessing = false
                }
                return
            }
            
            if let results = request.results as? [VNRecognizedTextObservation] {
                // Process text observations
                let recognizedStrings = results.compactMap { observation in
                    // Get multiple candidates to improve chances of finding the plate
                    observation.topCandidates(3).map { $0.string }
                }.flatMap { $0 }
                
                print("Recognized text candidates: \(recognizedStrings)")
                
                // Look for patterns that might be bus plate numbers
                var plateFound = false
                
                for string in recognizedStrings {
                    // Try to find a plate number in the recognized text
                    if let plateNumber = self.extractPlateNumber(from: string) {
                        DispatchQueue.main.async {
                            self.recognizedPlate = plateNumber
                            self.showScanResult = true
                            self.isProcessing = false
                        }
                        plateFound = true
                        return
                    }
                }
                
                // If no plate was found, just end processing without showing manual input
                if !plateFound {
                    DispatchQueue.main.async {
                        self.isProcessing = false
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.isProcessing = false
                }
            }
        }
        
        // Configure the request for optimal text recognition
        request.recognitionLevel = .accurate // Use accurate for the final capture
        request.usesLanguageCorrection = false
        request.revision = 3 // Use the latest revision for better accuracy
        
        // Create a handler to perform the request
        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:])
        
        do {
            try handler.perform([request])
        } catch {
            print("Failed to perform text recognition: \(error)")
            DispatchQueue.main.async {
                self.isProcessing = false
            }
        }
    }
    
    // Helper function to check if a string looks like a license plate
    private func looksLikePlate(_ text: String) -> Bool {
        // Must have at least one letter and one number
        let hasLetters = text.rangeOfCharacter(from: .letters) != nil
        let hasNumbers = text.rangeOfCharacter(from: .decimalDigits) != nil
        
        // Must not be too long or too short
        let validLength = text.count >= 5 && text.count <= 10
        
        // Must not be common bus text like "BSDCITY"
        let commonBusText = ["BSDCITY", "BSD", "CITY", "BUS", "BUSWAY", "TRANS"]
        let isCommonText = commonBusText.contains { text.uppercased().contains($0) }
        
        return hasLetters && hasNumbers && validLength && !isCommonText
    }
    
    // Helper function to extract plate number from text
    private func extractPlateNumber(from text: String) -> String? {
        // Standard Indonesian license plate pattern:
        // 1-2 letters (region) + 1-4 digits (number) + 1-3 letters (identifier)
        // Examples: B 7366 JE, DK 1234 AB
        let platePattern = "\\b[A-Z]{1,2}\\s?\\d{1,4}\\s?[A-Z]{1,3}\\b"
        
        if let regex = try? NSRegularExpression(pattern: platePattern) {
            let range = NSRange(location: 0, length: text.utf16.count)
            if let match = regex.firstMatch(in: text, range: range) {
                let matchRange = match.range
                if let range = Range(matchRange, in: text) {
                    let plateNumber = String(text[range])
                    
                    // Additional validation - check if it has the right format
                    // Must have at least one letter, followed by numbers, followed by letters
                    let hasCorrectFormat = plateNumber.range(of: "^[A-Z]{1,2}.*\\d+.*[A-Z]{1,3}$", options: .regularExpression) != nil
                    
                    // Check if it's not a common bus text
                    let commonBusText = ["BSDCITY", "BSD", "CITY", "BUS", "BUSWAY", "TRANS"]
                    let isNotCommonText = !commonBusText.contains { plateNumber.uppercased().contains($0) }
                    
                    if hasCorrectFormat && isNotCommonText {
                        return plateNumber
                    }
                }
            }
        }
        
        return nil
    }
    
}




#Preview {
    CameraView(source: .scanner, stop: defaultStop)
}
