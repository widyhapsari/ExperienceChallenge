//
//  CameraView.swift
//  ExperienceChallenge
//
//  Created by Rastya Widya Hapsari on 09/05/25.
//

import SwiftUI
import AVFoundation

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
                            ))) {
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
                busInfo: plate
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
}


#Preview {
    CameraView(source: .scanner, stop: defaultStop)
}
