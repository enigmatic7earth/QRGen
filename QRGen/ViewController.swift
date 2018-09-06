//
//  ViewController.swift
//  QRGen
//
//  Created by NETBIZ on 14/02/18.
//  Copyright © 2018 Netbiz.in. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var imgQRCode: UIImageView!
    
    @IBOutlet weak var btnAction: UIButton!
    
    @IBOutlet weak var btnSave: UIButton!
    

    
    var qrcodeImage:CIImage! //Core Image
    var transformedImage:CIImage!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func displayQRCodeImage(){
        let scaleX = imgQRCode.frame.size.width/qrcodeImage.extent.size.width
        let scaleY = imgQRCode.frame.size.height/qrcodeImage.extent.size.height
        
        transformedImage = qrcodeImage.transformed(by: CGAffineTransform(scaleX: scaleX, y: scaleY))
        imgQRCode.image = UIImage(ciImage: transformedImage)
        
    }
    
    @IBAction func performButtonAction(sender: AnyObject){
        if qrcodeImage == nil {
            if textField.text == "" {
                return
            }
            let data = textField.text?.data(using: .isoLatin1, allowLossyConversion: false)
            let filter = CIFilter(name: "CIQRCodeGenerator")
            filter?.setValue(data, forKey: "inputMessage")
            filter?.setValue("Q", forKey: "inputCorrectionLevel")
            
            qrcodeImage = filter!.outputImage!
            //imgQRCode.image = UIImage(ciImage: qrcodeImage)
            displayQRCodeImage()
            textField.resignFirstResponder()
            btnAction.setTitle("Clear", for: UIControlState.normal)
            btnSave.isHidden = false
            
        }
        else{
            imgQRCode.image = nil
            qrcodeImage = nil
            btnAction.setTitle("Generate", for:UIControlState.normal)
            textField.text = ""
            btnSave.isHidden = true
        }
    }
    
    @IBAction func save(sender: AnyObject){
        
        let success = saveImage(image: UIImage(ciImage: transformedImage))
        print(success)
    
    }
    func saveImage(image:UIImage) -> Bool {
        guard let data = UIImageJPEGRepresentation(image, 1.0) ?? UIImagePNGRepresentation(image) else {
            return false
        }
        guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else {
            return false
        }
        do {
            try data.write(to: directory.appendingPathComponent("fileName.png")!)
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }


}

