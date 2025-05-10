//
//  CameraView.swift
//  ExperienceChallenge
//
//  Created by Rastya Widya Hapsari on 09/05/25.
//

import SwiftUI
import AVFoundation

struct CameraView: View {
    @State private var showRouteFinderView = false
    @State private var recognizedPlate: String?
    @State private var showScanResult = false
    @State private var isShowingManualInput = false
    @State private var isCameraAuthorized = false
    @State private var showTutorial = false
    @State private var capturedImage: CVPixelBuffer?
    @State private var isPlateDetected = false
    @State private var isProcessing = false
    @State private var detectedPlateText = ""
    @State private var scanFrameRect = CGRect(x: 0, y: 0, width: 250, height: 150)
    @State private var showRouteHistory = false
    
    var body: some View {
        ZStack {
            // Camera view
            CamView(recognizedPlate: $recognizedPlate,
                       showScanResult: $showScanResult,
                       capturedImage: $capturedImage,
                       isPlateDetected: $isPlateDetected,
                       detectedPlateText: $detectedPlateText,
                       scanFrameRect: $scanFrameRect,
                       manualCapture: false)
            .edgesIgnoringSafeArea(.all)
            
            // Tutorial button
            VStack {
                HStack {
                    Spacer(minLength: 100)
                    
                    Button(action: {
                        showTutorial = true
                    }) {
                        Image(systemName: "questionmark.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 28, height: 28)
                            .foregroundStyle(.white)
                            .background(Circle().fill(Color.black))
                    }
                    .padding(.trailing, 40)
                }
                Spacer()
                
                // Scanning frame with instructions
                VStack(spacing: 25) {
                    
                    // Scanning frame - this will be positioned over the camera view
                    ZStack {
                        Rectangle()
                            .stroke(style: StrokeStyle(lineWidth: 3, dash: [10, 5]))
                            .frame(width: 250, height: 150)
                            .foregroundColor(isPlateDetected ? .green : .white)
                            .background(Color.clear)
                            .overlay(
                                GeometryReader { geometry in
                                    Color.clear
                                        .onAppear {
                                            // Store the frame's position for region of interest
                                            let frame = geometry.frame(in: .global)
                                            scanFrameRect = frame
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
                    .padding(60)
                    
                    
                    
                    
                    //scanning instruction
                    Text("Place the bus plate number\ninside the box and snap")
                        .font(.system(size: 15, weight: .medium))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                        .padding(11)
                        .background(Color.gray.opacity(0.3))
                        .cornerRadius(10)
                    
                    
                        // input bus plate option
                        Button(action: {
                            isShowingManualInput = true
                        }) {
                            Text("Enter Bus Plate Manually")
                                .font(.system(size: 18))
                                .foregroundColor(Color("BlueColor"))
                                .underline()
                                //.frame(width: 330, height: 43)
                                //.background(Color("BlueColor"))
                                //.cornerRadius(7)
                        }
                    
                    //.padding(.vertical, 20)
                    //.padding(.horizontal, 15)
                    //.padding(.horizontal, 20)
                    .padding(.bottom, 80)
                }
            }
        }
    }
}
struct CamView: UIViewRepresentable {
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
        
        let camView = context.coordinator.setupCamera()
        view.addSubview(camView)
        camView.frame = view.bounds
        
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
        var parent: CamView
        var captureSession: AVCaptureSession?
        var previewLayer: AVCaptureVideoPreviewLayer?
        private var lastProcessingTime: Date = Date()
        private let processingInterval: TimeInterval = 0.2 // Process frames more frequently
        private var plateDetectionHistory: [String: Int] = [:]
        private let confidenceThreshold = 3
        var scanFrameRect: CGRect = .zero
        private var screenSize: CGSize = UIScreen.main.bounds.size
        
        init(_ parent: CamView) {
            self.parent = parent
            super.init()
        }
        
        func setupCamera() -> UIView {
            let camView = UIView(frame: UIScreen.main.bounds)
            screenSize = camView.bounds.size
            
            // Initialize capture session
            let captureSession = AVCaptureSession()
            self.captureSession = captureSession
            
            // Set up camera input
            guard let camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
                print("No camera available")
                return camView
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
                previewLayer.frame = camView.bounds
                camView.layer.addSublayer(previewLayer)
                
                // Start session in background
                DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                    self?.captureSession?.startRunning()
                }
                
            } catch {
                print("Camera setup error: \(error.localizedDescription)")
            }
            
            return camView
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

#Preview {
    CameraView()
}
