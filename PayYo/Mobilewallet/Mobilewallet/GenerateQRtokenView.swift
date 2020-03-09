//  GenerateQRtokenView.swift
//  Mobilewallet
//  Created by Virendra patil on 25/11/19.
//  Copyright © 2019 Virendra patil. All rights reserved.

import UIKit

class GenerateQRtokenView: UIViewController {

    @IBOutlet weak var sharebtn: UIButton!
    @IBOutlet weak var cancelbtn: UIButton!
    @IBOutlet weak var imageview: UIImageView!
    var qrcodeImage: CIImage!
    @IBOutlet weak var qrcodeName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        qrcodeName.text = "Virendra Pramodrao Patil"
        let strSample = "Virendra Pramodrao Patil"

        if qrcodeImage == nil {
            if strSample == "" {
                return
            }
            let data = strSample.data(using: String.Encoding.isoLatin1, allowLossyConversion: false)
            let filter = CIFilter(name: "CIQRCodeGenerator")
            filter!.setValue(data, forKey: "inputMessage")
            filter!.setValue("Q", forKey: "inputCorrectionLevel")
            
            qrcodeImage = filter!.outputImage
            //textField!.resignFirstResponder()
            //btnAction.setTitle("Clear", for: UIControl.State.normal)
            
            displayQRCodeImage()
        }
        else {
            imageview.image = nil
            qrcodeImage = nil
            //btnAction.setTitle("Generate", for: UIControl.State.normal)
        }
        //textField?.isEnabled = !textField!.isEnabled
        //slider.isHidden = !slider.isHidden
        cancelbtn.addUIViewborder(color: .lightGray, cornerradius: 6, borderwidth: 2)
        sharebtn.addUIViewborder(color: .lightGray, cornerradius: 6, borderwidth: 2)
    }
    
    func displayQRCodeImage() {
        let scaleX = imageview.frame.size.width / qrcodeImage.extent.size.width
        let scaleY = imageview.frame.size.height / qrcodeImage.extent.size.height
        let transformedImage = qrcodeImage.transformed(by: CGAffineTransform(scaleX: scaleX, y: scaleY))
        imageview.image = UIImage(ciImage: transformedImage)
    }
}
