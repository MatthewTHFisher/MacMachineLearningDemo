import AppKit
import AVFoundation
import Combine
import CoreML
import SwiftUI
import Vision

class PlayerViewController: NSViewController, AVCaptureVideoDataOutputSampleBufferDelegate, ObservableObject {
    let mlModel = ASLModel()

    @Published var handPoseObservation: VNHumanHandPoseObservation?
    @Published var prediction: ASLHandPoseClassifierOutput?

    var previewLayer: AVCaptureVideoPreviewLayer?

    func captureOutput(
        _ output: AVCaptureOutput,
        didOutput sampleBuffer: CMSampleBuffer,
        from connection: AVCaptureConnection
    ) {
        let handPoseRequest = VNDetectHumanHandPoseRequest()
        handPoseRequest.maximumHandCount = 1

        let handler = VNImageRequestHandler(cmSampleBuffer: sampleBuffer, orientation: .up)
        do {
            try handler.perform([handPoseRequest])
        } catch {
            print("⚠️ Failed to make hand pose request")
        }

        guard let handPoses = handPoseRequest.results, !handPoses.isEmpty else {
            return
        }

        self.handPoseObservation = handPoses.first

        guard let keypointsMultiArray = try? self.handPoseObservation?.keypointsMultiArray() else {
            fatalError()
        }

        do {
            prediction = try mlModel.model.prediction(poses: keypointsMultiArray)
        } catch {
            return
        }
    }
}

class PlayerView: NSView {
    var viewModel: PlayerViewController

    init(captureSession: AVCaptureSession, viewModel: PlayerViewController = PlayerViewController()) {
        self.viewModel = viewModel
        self.viewModel.previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        super.init(frame: .zero)

        setupLayer()

        let dataOutput = AVCaptureVideoDataOutput()
        if captureSession.canAddOutput(dataOutput) {
            captureSession.addOutput(dataOutput)
            dataOutput.alwaysDiscardsLateVideoFrames = true
            dataOutput.setSampleBufferDelegate(viewModel, queue: .main)
        } else {
            print("⚠️ Could not add video data output to the session")
        }
    }

    func setupLayer() {
        viewModel.previewLayer?.frame = self.frame
        viewModel.previewLayer?.contentsGravity = .resizeAspectFill
        viewModel.previewLayer?.videoGravity = .resizeAspectFill
        viewModel.previewLayer?.connection?.automaticallyAdjustsVideoMirroring = false
        layer = viewModel.previewLayer
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var prediction: ASLHandPoseClassifierOutput? {
        viewModel.prediction
    }
}

struct PlayerContainerView: NSViewRepresentable {
    typealias NSViewType = PlayerView

    let captureSession: AVCaptureSession
    let viewModel: PlayerViewController

    init(captureSession: AVCaptureSession, viewModel: PlayerViewController = PlayerViewController()) {
        self.captureSession = captureSession
        self.viewModel = viewModel
    }

    func makeNSView(context: Context) -> PlayerView {
        PlayerView(captureSession: captureSession, viewModel: viewModel)
    }

    func updateNSView(_ nsView: PlayerView, context: Context) { }
}

class ContentViewModel: ObservableObject {
    @Published var isGranted = false
    var captureSession: AVCaptureSession!
    private var cancellables = Set<AnyCancellable>()

    init() {
        captureSession = AVCaptureSession()
        setupBindings()
    }

    func setupBindings() {
        $isGranted
            .sink { [weak self] isGranted in
                if isGranted {
                    self?.prepareCamera()
                } else {
                    self?.stopSession()
                }
            }
            .store(in: &cancellables)
    }

    func checkAuthorization() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized: // The user has previously granted access to the camera.
            self.isGranted = true

        case .notDetermined: // The user has not yet been asked for camera access.
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                if granted {
                    DispatchQueue.main.async {
                        self?.isGranted = granted
                    }
                }
            }

        case .denied: // The user has previously denied access.
            self.isGranted = false
            return

        case .restricted: // The user can't grant access due to restrictions.
            self.isGranted = false
            return
        @unknown default:
            fatalError()
        }
    }

    func startSession() {
        guard !captureSession.isRunning else { return }
        captureSession.startRunning()
    }

    func stopSession() {
        guard captureSession.isRunning else { return }
        captureSession.stopRunning()
    }

    func prepareCamera() {
        captureSession.sessionPreset = .high

        if let device = AVCaptureDevice.default(for: .video) {
            startSessionForDevice(device)
        }
    }

    func startSessionForDevice(_ device: AVCaptureDevice) {
        do {
            let input = try AVCaptureDeviceInput(device: device)
            addInput(input)
            startSession()
        } catch {
            print("Something went wrong - ", error.localizedDescription)
        }
    }

    func addInput(_ input: AVCaptureInput) {
        guard captureSession.canAddInput(input) == true else {
            return
        }
        captureSession.addInput(input)
    }
}
