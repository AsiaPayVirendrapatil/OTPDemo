//
//  ScanView.swift
//  Mobilewallet
//
//  Created by Virendra patil on 04/12/19.
//  Copyright © 2019 Virendra patil. All rights reserved.
//

import UIKit
import AVFoundation

class ScanView: UIViewController,AVCaptureMetadataOutputObjectsDelegate {
    
    @IBOutlet var videoPreview : UIView!
    var stringURL = String()
    
    enum error : Error {
        case noCameraAvailable
        case videoInputInitFail
    }

    @IBOutlet weak var menubutton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            try scanQRcode()
        } catch {
            print("Failed to Scan the QR/Barcode.")
        }

        if revealViewController() != nil {
            //revealViewController().rearViewRevealWidth = 62
            menubutton.target = revealViewController()
            menubutton.action = #selector(SWRevealViewController.revealToggle(_:))
            revealViewController().rightViewRevealWidth = 150
            //extraButton.target = revealViewController()
            //extraButton.action = "rightRevealToggle:"
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    func captureoutput(_captureoutput :AVCaptureOutput! ,didOutputMetadataObjects MetadataObjects : [Any]! , fromConnection  : AVCaptureConnection!)  {
        
        if MetadataObjects.count > 0  {
            
            let machineredablecode = MetadataObjects[0] as!  AVMetadataMachineReadableCodeObject
            if machineredablecode.type == AVMetadataObject.ObjectType.qr {
                stringURL = machineredablecode.stringValue!
                performSegue(withIdentifier: "openLink", sender: self)
            }
        }
    }
    
    func scanQRcode() throws {
        
        let avCaptureSession = AVCaptureSession()
        
        guard let avCaptureDevice = AVCaptureDevice.default(for: AVMediaType.video) else {
            print("No Camera.")
            throw error.noCameraAvailable
        }
        
        guard let avCaptureInput = try? AVCaptureDeviceInput(device: avCaptureDevice) else {
            print("Failed to init Camera.!")
            throw error.videoInputInitFail
        }
        let avcCaptureMetadataOutput = AVCaptureMetadataOutput()
        avcCaptureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)

        avCaptureSession.addInput(avCaptureInput)
        avCaptureSession.addOutput(avcCaptureMetadataOutput)

        avcCaptureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
        let avCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session: avCaptureSession)
        avCaptureVideoPreviewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        avCaptureVideoPreviewLayer.frame = videoPreview.bounds
        self.videoPreview.layer .addSublayer(avCaptureVideoPreviewLayer)

        avCaptureSession.startRunning()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if  segue.identifier == "openLink" {
            
            let destination = segue.destination as! WebViewController
            destination.url = URL(string: stringURL)
            
        }
    }

    
}
