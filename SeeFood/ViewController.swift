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

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var thinkLabel: UILabel!
    
    @IBOutlet weak var oobeLabel: UILabel!
    @IBOutlet weak var oobeArrow: UIImageView!
    
    @IBOutlet weak var scanButton: ButtonStyle!
    @IBOutlet weak var cameraButton: ButtonStyle!
    @IBOutlet weak var buttonStackView: UIStackView!
    
    
    let imagePicker = UIImagePickerController()

    
    
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
        
        
        imageView.layer.cornerRadius = 10
    }

    

    //MARK: - IBActions
    @IBAction func cameraButtonTapped(_ sender: UIButton) {
        
        present(imagePicker, animated: true, completion: nil)
        //l
    }
    
    @IBAction func scanButtonTapped(_ sender: Any) {
        
        
        UIView.animate(withDuration: 0.3) { [self] in
            if cameraButton.alpha == 0{
                
                //camera button shown
                cameraButton.alpha = 1
                scanButton.topGradient = "StartTop"
                scanButton.bottomGradient = "StartBottom"
                scanButton.setTitle("Start Scanning", for: .normal)
                scanButton.setTitleColor(UIColor.black, for: .normal)
                scanButton.setNeedsDisplay()
            
            }else{
            
                //camera button hidden
                cameraButton.alpha = 0
                scanButton.topGradient = "StopTop"
                scanButton.bottomGradient = "StopBottom"
                scanButton.setTitleColor(UIColor.white, for: .normal)
                scanButton.setTitle("Stop Scanning", for: .normal)
                scanButton.setNeedsDisplay()
            
            }
        }
        
        UIView.animate(withDuration: 0.3) { [self] in
            cameraButton.isHidden.toggle()
            buttonStackView.layoutIfNeeded()
            
        }
        
        
    }
    

    
    //MARK: - Imagepickercontroller
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let userPickedImage = info[.originalImage] as? UIImage{
        
            imageView.image = userPickedImage
            
            oobeArrow.isHidden = true
            oobeLabel.isHidden = true
            
            
            guard let ciimage = CIImage(image: userPickedImage) else {
                fatalError("Could not convert")
            }
            
            detect(image: ciimage)
            
            
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
        UIView.animate(withDuration: 50, delay: 5) { [self] in
            imageViewTopConstraint.constant = 130
            
        }
        
        
    }
    
    
    
    //MARK: - Detect
    
    func detect(image: CIImage){
        
        guard let model = try? VNCoreMLModel(for: Food101(configuration: MLModelConfiguration()).model) else {
            fatalError("Broken coreml")
        }
        
        let request = VNCoreMLRequest(model: model) { [self] (request, error) in
            
            guard let results = request.results as? [VNClassificationObservation] else{
                fatalError("vnrequest error")
            }
            
            if let result = results.first{
                if Int(result.confidence * 100) > 1 {
                    thinkLabel.text = "I think this is \(result.identifier)"
                }
                
            }
            
            
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        
        
        do{
            try handler.perform([request])
        }catch{
            print("Error handler")
        }
    }
    
    
    
    
    
    
    
    
    
}

