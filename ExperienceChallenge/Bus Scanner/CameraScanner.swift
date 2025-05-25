//
//  CameraScanner.swift
//  ExperienceChallenge
//
//  Created by Rastya Widya Hapsari on 15/05/25.
//

import SwiftUI
import AVFoundation
import Vision
import CoreImage


// Camera view using UIViewRepresentable
struct CameraScanner: UIViewRepresentable {
    @Binding var recognizedPlate: String?
    @Binding var showScanResult: Bool
    @Binding var capturedImage: CVPixelBuffer?
    @Binding var isPlateDetected: Bool
    @Binding var detectedPlateText: String
    @Binding var scanFrameRect: CGRect
    var manualCapture: Bool
    
    // Create the UIView
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = .black
        
        let CameraScanner = context.coordinator.setupCamera()
        view.addSubview(CameraScanner)
        CameraScanner.frame = view.bounds
        
        return view
    }
    
    // Update the view if needed
    func updateUIView(_ uiView: UIView, context: Context) {
        context.coordinator.scanFrameRect = scanFrameRect
    }
    
    // Create the coordinator
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    // Coordinator class to handle camera setup and text recognition
    class Coordinator: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
        var parent: CameraScanner
        var captureSession: AVCaptureSession?
        var previewLayer: AVCaptureVideoPreviewLayer?
        private var lastProcessingTime: Date = Date()
        private let processingInterval: TimeInterval = 0.2 // Process frames more frequently
        private var plateDetectionHistory: [String: Int] = [:]
        private let confidenceThreshold = 3
        var scanFrameRect: CGRect = .zero
        private var screenSize: CGSize = UIScreen.main.bounds.size
        
        init(_ parent: CameraScanner) {
            self.parent = parent
            super.init()
        }
        
        func setupCamera() -> UIView {
            let CameraScanner = UIView(frame: UIScreen.main.bounds)
            screenSize = CameraScanner.bounds.size
            
            // Initialize capture session
            let captureSession = AVCaptureSession()
            self.captureSession = captureSession
            
            // Set up camera input
            guard let camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
                print("No camera available")
                return CameraScanner
            }
            
            do {
                // Configure camera for high resolution
                try camera.lockForConfiguration()
                if camera.isAutoFocusRangeRestrictionSupported {
                    camera.autoFocusRangeRestriction = .near
                }
                
                // Enable auto-focus
                if camera.isFocusModeSupported(.continuousAutoFocus) {
                    camera.focusMode = .continuousAutoFocus
                }
                
                // Enable auto-exposure
                if camera.isExposureModeSupported(.continuousAutoExposure) {
                    camera.exposureMode = .continuousAutoExposure
                }
                
                camera.unlockForConfiguration()
                
                // Add camera input to session
                let input = try AVCaptureDeviceInput(device: camera)
                if captureSession.canAddInput(input) {
                    captureSession.addInput(input)
                }
                
                // Set up video output
                let videoOutput = AVCaptureVideoDataOutput()
                videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
                videoOutput.alwaysDiscardsLateVideoFrames = true
                
                if captureSession.canAddOutput(videoOutput) {
                    captureSession.addOutput(videoOutput)
                }
                
                // Configure session for high resolution
                captureSession.sessionPreset = .high
                
                // Set up preview layer
                let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                self.previewLayer = previewLayer
                previewLayer.videoGravity = .resizeAspectFill
                previewLayer.frame = CameraScanner.bounds
                CameraScanner.layer.addSublayer(previewLayer)
                
                // Start session in background
                DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                    self?.captureSession?.startRunning()
                }
                
            } catch {
                print("Camera setup error: \(error.localizedDescription)")
            }
            
            return CameraScanner
        }
        
        // Process video frames
        func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
            guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
            
            // Store the current frame for manual capture
            DispatchQueue.main.async {
                self.parent.capturedImage = pixelBuffer
            }
            
            // Check if enough time has passed since last processing
            let currentTime = Date()
            if currentTime.timeIntervalSince(lastProcessingTime) < processingInterval {
                return
            }
            
            lastProcessingTime = currentTime
            
            // Perform real-time text detection
            detectPlateInFrame(pixelBuffer)
        }
        
        private func detectPlateInFrame(_ pixelBuffer: CVPixelBuffer) {
            // Skip if scan frame is not set yet
            if scanFrameRect == .zero {
                return
            }
            
            // Convert UI coordinates to normalized coordinates for Vision
            let normalizedRect = convertToNormalizedRect(scanFrameRect, pixelBuffer: pixelBuffer)
            
            // Safely expand region without going out of bounds
//                let padding: CGFloat = 0.05
//            
//                let x = max(0, normalizedRect.origin.x - padding)
//                let y = max(0, normalizedRect.origin.y - padding)
//                var width = normalizedRect.width + (padding * 2)
//                var height = normalizedRect.height + (padding * 2)
//            
//                if x + width > 1.0 {
//                    width = 1.0 - x
//                }
//                if y + height > 1.0 {
//                    height = 1.0 - y
//                }

//                let expandedRect = CGRect(x: x, y: y, width: width, height: height)

                // Create the text recognition request
                let request = VNRecognizeTextRequest { [weak self] request, error in
                    guard let self = self, error == nil else {
                        print("Failed to perform text recognition: \(error?.localizedDescription ?? "Unknown error")")
                        return
                    }

                
                if let results = request.results as? [VNRecognizedTextObservation] {
                    // Process text observations
                    let recognizedStrings = results.compactMap { observation in
                        // Get more candidates to improve chances of finding the plate
                        observation.topCandidates(10).map { $0.string }
                    }.flatMap { $0 }
                    
                    // Debug: Print all recognized strings
                    print("Recognized text candidates: \(recognizedStrings)")
                    
                    var plateDetected = false
                    var plateText = ""
                    
                    // Look for Indonesian license plate pattern with more flexibility
                    // Format: B 7366 JE (1-2 letters + space + 1-4 digits + space + 1-3 letters)
                    let platePattern = "\\b[A-Z]{1,2}\\s*\\d{1,4}\\s*[A-Z]{1,3}\\b"
                    
                    // Also try a more lenient pattern that might catch partial plates
                    let lenientPattern = "[A-Z]{1,2}\\s*\\d{1,4}"
                    
                    for string in recognizedStrings {
                        // Clean up the string - remove unwanted characters and trim
                        let cleanedString = string
                            .replacingOccurrences(of: "BSDCITY", with: "")
                            .replacingOccurrences(of: "BSD", with: "")
                            .replacingOccurrences(of: "CITY", with: "")
                            .trimmingCharacters(in: .whitespacesAndNewlines)
                            .uppercased() // Ensure uppercase for consistent matching
                        
                        // Try the full plate pattern first
                        if let regex = try? NSRegularExpression(pattern: platePattern) {
                            let range = NSRange(location: 0, length: cleanedString.utf16.count)
                            if let match = regex.firstMatch(in: cleanedString, range: range) {
                                let matchRange = match.range
                                if let range = Range(matchRange, in: cleanedString) {
                                    let candidate = String(cleanedString[range])
                                    
                                    // Additional validation
                                    let hasCorrectFormat = candidate.range(of: "^[A-Z]{1,2}\\s*\\d{1,4}\\s*[A-Z]{1,3}$", options: .regularExpression) != nil
                                    
                                    // Check if it's not a common bus text
                                    let commonBusText = ["BSDCITY", "BSD", "CITY", "BUS", "BUSWAY", "TRANS"]
                                    let isNotCommonText = !commonBusText.contains { candidate.uppercased().contains($0) }
                                    
                                    if hasCorrectFormat && isNotCommonText {
                                        plateDetected = true
                                        plateText = candidate
                                        
                                        // Format the plate number consistently
                                        if let formattedPlate = self.formatPlateNumber(plateText) {
                                            plateText = formattedPlate
                                        }
                                        
                                        break
                                    }
                                }
                            }
                        }
                        
                        // If no full plate detected, try the lenient pattern
                        if !plateDetected {
                            if let regex = try? NSRegularExpression(pattern: lenientPattern) {
                                let range = NSRange(location: 0, length: cleanedString.utf16.count)
                                if let match = regex.firstMatch(in: cleanedString, range: range) {
                                    let matchRange = match.range
                                    if let range = Range(matchRange, in: cleanedString) {
                                        let candidate = String(cleanedString[range])
                                        
                                        // If we find a partial plate (like "B 7366")
                                        plateDetected = true
                                        plateText = candidate
                                        
                                        // Try to find the identifier part separately
                                        let letterPattern = "\\b[A-Z]{2,3}\\b"
                                        if let letterRegex = try? NSRegularExpression(pattern: letterPattern) {
                                            let letterRange = NSRange(location: 0, length: cleanedString.utf16.count)
                                            let letterMatches = letterRegex.matches(in: cleanedString, range: letterRange)
                                            
                                            for letterMatch in letterMatches {
                                                if let letterMatchRange = Range(letterMatch.range, in: cleanedString) {
                                                    let letters = String(cleanedString[letterMatchRange])
                                                    if letters != "BS" && letters != "SD" && !plateText.contains(letters) {
                                                        plateText += " " + letters
                                                        break
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                    // Implement confidence-based detection with history tracking
                    if plateDetected {
                        // Update confidence for this plate
                        let currentConfidence = self.plateDetectionHistory[plateText] ?? 0
                        self.plateDetectionHistory[plateText] = currentConfidence + 1
                        
                        // Decay confidence for other plates
                        for (plate, confidence) in self.plateDetectionHistory where plate != plateText {
                            self.plateDetectionHistory[plate] = max(0, confidence - 1)
                        }
                        
                        // Find the plate with the highest confidence
                        if let (mostConfidentPlate, confidence) = self.plateDetectionHistory.max(by: { $0.value < $1.value }) {
                            // Lower the confidence threshold to 2 (was 3)
                            if confidence >= 2 {
                                plateDetected = true
                                plateText = mostConfidentPlate
                                print("Detected plate with confidence \(confidence): \(plateText)")
                            } else {
                                plateDetected = false
                            }
                        } else {
                            plateDetected = false
                        }
                    } else {
                        // Decay all confidences when no plate is detected
                        for plate in self.plateDetectionHistory.keys {
                            self.plateDetectionHistory[plate] = max(0, (self.plateDetectionHistory[plate] ?? 0) - 1)
                        }
                        
                        // Remove plates with zero confidence
                        self.plateDetectionHistory = self.plateDetectionHistory.filter { $0.value > 0 }
                    }
                    
                    // Store the detected plate text for capture button use
                    DispatchQueue.main.async {
                        if plateDetected {
                            self.parent.detectedPlateText = plateText
                            self.parent.isPlateDetected = true
                            print("✅ Plate detected: \(plateText)")
                        } else {
                            self.parent.isPlateDetected = false
                        }
                    }
                }
            }
            
            // Configure the request for optimal text recognition
            request.recognitionLevel = .accurate
            request.usesLanguageCorrection = false
            request.revision = 3
//            request.regionOfInterest = expandedRect
            
            
            
//            // Use a slightly larger region of interest to catch more text
//            let expandedRect = CGRect(
//                x: max(0, normalizedRect.origin.x - 0.05),
//                y: max(0, normalizedRect.origin.y - 0.05),
//                width: min(1.0, normalizedRect.width + 0.1),
//                height: min(1.0, normalizedRect.height + 0.1)
//            )
//            request.regionOfInterest = expandedRect
            
            
            
            // Create a handler to perform the request
            let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:])
            
            do {
                try handler.perform([request])
            } catch {
                print("Failed to perform text recognition: \(error)")
            }
        }
        
        // Helper function to format plate numbers consistently
        private func formatPlateNumber(_ plateText: String) -> String? {
            // Try to extract the components of the plate number
            let cleaned = plateText.uppercased().filter { !$0.isWhitespace }
            
            // Try to extract components
            var regionCode = ""
            var numbers = ""
            var identifier = ""
            
            var index = cleaned.startIndex
            
            // Extract region code (first 1-2 letters)
            while index < cleaned.endIndex && cleaned[index].isLetter {
                regionCode.append(cleaned[index])
                index = cleaned.index(after: index)
            }
            
            // Extract numbers
            while index < cleaned.endIndex && cleaned[index].isNumber {
                numbers.append(cleaned[index])
                index = cleaned.index(after: index)
            }
            
            // Extract identifier (remaining letters)
            while index < cleaned.endIndex && cleaned[index].isLetter {
                identifier.append(cleaned[index])
                index = cleaned.index(after: index)
            }
            
            // Format with proper spacing
            if !regionCode.isEmpty && !numbers.isEmpty {
                if !identifier.isEmpty {
                    return "\(regionCode) \(numbers) \(identifier)"
                } else {
                    return "\(regionCode) \(numbers)"
                }
            }
            
            return plateText
        }
        
        // Convert UI coordinates to normalized coordinates for Vision framework
        private func convertToNormalizedRect(_ rect: CGRect, pixelBuffer: CVPixelBuffer) -> CGRect {
            let pixelBufferWidth = CGFloat(CVPixelBufferGetWidth(pixelBuffer))
            let pixelBufferHeight = CGFloat(CVPixelBufferGetHeight(pixelBuffer))
            
            // Calculate the scale factors
            let scaleX = pixelBufferWidth / screenSize.width
            let scaleY = pixelBufferHeight / screenSize.height
            
            // Convert to pixel buffer coordinates
            let x = rect.origin.x * scaleX
            let y = rect.origin.y * scaleY
            let width = rect.size.width * scaleX
            let height = rect.size.height * scaleY
            
            // Normalize coordinates (Vision uses normalized coordinates)
            let normalizedX = x / pixelBufferWidth
            let normalizedY = 1.0 - ((y + height) / pixelBufferHeight) // Flip Y coordinate
            let normalizedWidth = width / pixelBufferWidth
            let normalizedHeight = height / pixelBufferHeight
            
            // Create normalized rect with minimal padding to focus on the frame
            let padding = 0.02 // 2% padding
            return CGRect(
                x: max(0, normalizedX - padding),
                y: max(0, normalizedY - padding),
                width: min(1.0, normalizedWidth + (padding * 2)),
                height: min(1.0, normalizedHeight + (padding * 2))
            )
        }
    }
}
