//
//  SignatureVC.swift
//  CarDamage
//
//  Created by Darren Asamov on 21/01/2022.
//

import UIKit

class SignatureVC: UIViewController{

    @IBOutlet weak var signatureView: UIView!
    let canvas = Signature()
    
    let record = Record()
    
    var splatCarRecordVCReference: SplatCarRecordVC!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupCanvas()
        setupView()
    }
    
    func setupView() {
        signatureView.layer.borderWidth = 1.0
        signatureView.layer.borderColor = UIColor.black.cgColor
    }
    
    func setupCanvas() {
        signatureView.addSubview(canvas)
        canvas.backgroundColor = .white
        canvas.translatesAutoresizingMaskIntoConstraints = false
        canvas.topAnchor.constraint(equalTo: signatureView.topAnchor, constant: 0).isActive = true
        canvas.leadingAnchor.constraint(equalTo: signatureView.leadingAnchor, constant: 0).isActive = true
        canvas.widthAnchor.constraint(equalTo: signatureView.widthAnchor, multiplier: 1).isActive = true
        canvas.heightAnchor.constraint(equalTo: signatureView.heightAnchor, multiplier: 1).isActive = true
    }
    
    @IBAction func didTapClear(_ sender: UIButton) {
        canvas.clear()
    }
    
    
    @IBAction func didTapDone(_ sender: UIButton) {
        if !canvas.lines.isEmpty {
            if record.recordID.isEmpty {
                record.recordID = UUID().uuidString
            }
            signatureView.layer.borderWidth = 0
            
            let image = canvas.createImage()!
            
//            let renderer = UIGraphicsImageRenderer(size: signatureView.bounds.size)
//            let image = renderer.image { ctx in
//                view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
//            }
            
            let imageAsString = convertImageToBase64String(image: image)
            
            record.technicianSignature = imageAsString
            
            let existingRecord = Record.lookingForRecord(record: record)
            if existingRecord != nil {
                Record.deleteRecord(record: existingRecord!)
                Record.createRecord(record: record)
            } else {
              Record.createRecord(record: record)
            }
            self.view.window?.rootViewController?.dismiss(animated: false)
        }
    }
    
    @IBAction func didTapBack(_ sender: UIButton) {
        dismissWithReturnTransition()
        dismiss(animated: false)
    }
    
    func convertImageToBase64String (image: UIImage) -> String {
        return image.jpegData(compressionQuality: 0.5)?.base64EncodedString() ?? ""
        
    }
}
