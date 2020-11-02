//
//  ViewController.swift
//  SeeFood
//
//  Created by Justyn Henman on 24/07/2020.
//  Copyright © 2020 Justyn Henman. All rights reserved.
//

import UIKit
import CoreML
import Vision
import AVFoundation


class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, AVCapturePhotoCaptureDelegate{
    
    
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var thinkLabel: UILabel!
    
    @IBOutlet weak var oobeLabel: UILabel!
    @IBOutlet weak var oobeArrow: UIImageView!

    
    @IBOutlet weak var scanButton: ButtonStyle!
    @IBOutlet weak var cameraButton: ButtonStyle!
    @IBOutlet weak var cameraButtonWidthConstaint: NSLayoutConstraint!
    @IBOutlet weak var buttonStackView: UIStackView!
    
    
    let imagePicker = UIImagePickerController()
    
    var captureSession: AVCaptureSession!
    var stillImageOutput: AVCapturePhotoOutput!
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!

    var isScanning: Bool = false
    var isShowingPhoto: Bool = false
    
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scanButton.topGradient = "StartTop"
        scanButton.bottomGradient = "StartBottom"
        scanButton.setTitleColor(UIColor.black, for: .normal)
        
        
        cameraButton.topGradient = "CamTop"
        cameraButton.bottomGradient = "CamBottom"
        cameraButton.setContentHuggingPriority(UILayoutPriority.required, for: .horizontal)
        
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
        
        
        previewView.layer.cornerRadius = 10
        imageView.layer.cornerRadius = 10
    }
    
    //MARK: - ViewDidAppear
    //Setup
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = .photo
        //creates capturesession with photo preset
        
        
        guard let backCamera = AVCaptureDevice.default(for: AVMediaType.video) else{ print("Error Accessing Back Camera")
            return
        }
        
        do{
            let cameraInput = try AVCaptureDeviceInput(device: backCamera)
            stillImageOutput = AVCapturePhotoOutput()
            
            let canAddIO = captureSession.canAddInput(cameraInput) && captureSession.canAddOutput(stillImageOutput)
            
            if canAddIO{
                captureSession.addInput(cameraInput)
                captureSession.addOutput(stillImageOutput)
                setupLivePreview()
            }
        }catch{
            print(error.localizedDescription)
        }
        
        
    }
    
    //MARK: - ViewWillDisappear
    //remove capturesession when view disappears

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //kills capture session in background
        self.captureSession.stopRunning()
    }
    

    //MARK: - Camera Button Pressed
    @IBAction func cameraButtonTapped(_ sender: UIButton) {
 

        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5) { [self] in
            
            hideOOBE()
 
            if isShowingPhoto{
                isShowingPhoto = false
                
                //code for button ui
                scanButton.alpha = 1
                cameraButton.topGradient = "CamTop"
                cameraButton.bottomGradient = "CamBottom"
                scanButton.setNeedsDisplay()
                thinkLabel.alpha = 0
                
                //code for action
                videoPreviewLayer.isHidden = false
                imageView.image = nil
            
            }else{
                isShowingPhoto = true
                
                cameraButtonWidthConstaint = nil
                //scanning button hidden
                
                //code for button ui
                scanButton.alpha = 0
                cameraButton.topGradient = "StopTop"
                cameraButton.bottomGradient = "StopBottom"
                scanButton.setNeedsDisplay()
                
                
                //code for action
                videoPreviewLayer.isHidden = true
                let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.hevc])
                stillImageOutput.capturePhoto(with: settings, delegate: self)
                thinkLabel.alpha = 1
                
                

            }
            scanButton.isHidden.toggle()
            //buttonStackView.layoutIfNeeded()

        }
        
        
        
    }
    
    //MARK: - Scan Button Pressed
    
    @IBAction func scanButtonTapped(_ sender: Any) {
        
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5) { [self] in
            
            hideOOBE()

            if isScanning{
                
                isScanning = false
                
                //camera button shown
                cameraButton.alpha = 1
                scanButton.topGradient = "StartTop"
                scanButton.bottomGradient = "StartBottom"
                scanButton.setTitle("Start Scanning", for: .normal)
                scanButton.setTitleColor(UIColor.black, for: .normal)
                scanButton.setNeedsDisplay()
                
                thinkLabel.alpha = 0

            }else{
            
                isScanning = true
                
                //camera button hidden
                cameraButton.alpha = 0
                scanButton.topGradient = "StopTop"
                scanButton.bottomGradient = "StopBottom"
                scanButton.setTitleColor(UIColor.white, for: .normal)
                scanButton.setTitle("Stop Scanning", for: .normal)
                scanButton.setNeedsDisplay()
                
                
                thinkLabel.alpha = 1
                  
                let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.hevc])
                stillImageOutput.capturePhoto(with: settings, delegate: self)
            
            }

            cameraButton.isHidden.toggle()
            buttonStackView.layoutIfNeeded()

        }
        
        
        
    }
    
    //MARK: - Hide info text
    
    func hideOOBE(){
        oobeLabel.alpha = 0
        oobeArrow.alpha = 0
        
    }
    
    //MARK: - Live Preview Setup
    
    func setupLivePreview(){
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer.videoGravity = .resizeAspectFill
        videoPreviewLayer.connection?.videoOrientation = .portrait
        videoPreviewLayer.cornerRadius = 10
        previewView.layer.addSublayer(videoPreviewLayer)
        
        DispatchQueue.global(qos: .userInitiated).async {
            self.captureSession.startRunning()
            
            DispatchQueue.main.async {
                self.videoPreviewLayer.frame = self.previewView.bounds
            }
        }
    }
    

    //MARK: - Set UIImage to Cam Output
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        
        guard let imageData = photo.fileDataRepresentation() else { return }
        let image = UIImage(data: imageData)
        
        if scanButton.isHidden{
            imageView.image = image
        }
        
        detect(image: CIImage(cgImage: image!.cgImage!))
        }
   

    //MARK: - Image scanning function


    func detect(image: CIImage){
        
        guard let model = try? VNCoreMLModel(for: Inceptionv3(configuration: MLModelConfiguration()).model) else {
            fatalError("Broken coreml")
        }
        
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let results = request.results as? [VNClassificationObservation] else{
                fatalError("vnrequest error")
            }
            if let result = results.first{
                if Int(result.confidence * 100) > 1 {
                    self.thinkLabel.text = "I think this is \(result.identifier)"
                }
            }
        }
        let handler = VNImageRequestHandler(ciImage: image)
        do{
            try handler.perform([request])
        }catch{
            print("Error handler")
        }
        
        //jank ass real time tracking
        if cameraButton.isHidden == true{
            let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.hevc])
            stillImageOutput.capturePhoto(with: settings, delegate: self)
        }
    }
    

    
}

    
    
    
    


