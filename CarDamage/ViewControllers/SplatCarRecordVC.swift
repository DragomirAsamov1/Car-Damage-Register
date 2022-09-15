//
//  SplatCarRecordVC.swift
//  CarDamage
//
//  Created by Darren Asamov on 21/01/2022.
//

import UIKit

class SplatCarRecordVC: UIViewController {
    
    var datePicker: UIDatePicker!

    @IBOutlet weak var registrationTF: UITextField!
    @IBOutlet weak var customerNameTF: UITextField!
    @IBOutlet weak var technicianNameTF: UITextField!
    @IBOutlet weak var dateOfWorkTF: UITextField!
    @IBOutlet weak var carImageView: UIImageView!
    @IBOutlet weak var redDamageButton: UIButton!
    @IBOutlet weak var yellowDamageButton: UIButton!
    @IBOutlet weak var greenDamageButton: UIButton!
    
    var record = Record()
    var damageReport = 0
    var chosenButton = ""
    var localizedButtonsOnImage = [LocalizedDamage]()
    var previousChar = ""
    var allImageSubviews = [UIImageView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registrationTF.delegate = self
        customerNameTF.delegate = self
        technicianNameTF.delegate = self
        dateOfWorkTF.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setupTextFieldsAndButtons()
        loadSubviews()
        initializeHideKeyboard()
    }
    
    @IBAction func didTapRedDamage(_ sender: UIButton) {
        chosenButton = "redDamageButton"
        BlackBorderWith3px(button: redDamageButton)
        BlackBorderWith1px(button: yellowDamageButton)
        BlackBorderWith1px(button: greenDamageButton)
    }
    
    @IBAction func didTapYellowDamage(_ sender: UIButton) {
        chosenButton = "yellowDamageButton"
        BlackBorderWith3px(button: yellowDamageButton)
        BlackBorderWith1px(button: redDamageButton)
        BlackBorderWith1px(button: greenDamageButton)
    }
    
    @IBAction func didTapGreenDamage(_ sender: UIButton) {
        chosenButton = "greenDamageButton"
        BlackBorderWith3px(button: greenDamageButton)
        BlackBorderWith1px(button: redDamageButton)
        BlackBorderWith1px(button: yellowDamageButton)
    }
    
    @IBAction func carImageTapped(_ sender: UITapGestureRecognizer) {
        let myImages = ["redmark", "yellowmark", "greenmark"]
        
        let touchPoint = sender.location(in: carImageView)
        var imageName = ""
        let imageWidth = redDamageButton.frame.width
        let xPoint = touchPoint.x - imageWidth / 2
        let yPoint = touchPoint.y - imageWidth / 2
        
        let subview = UIImageView()
        carImageView.addSubview(subview)
        subview.translatesAutoresizingMaskIntoConstraints = false
        subview.leadingAnchor.constraint(equalTo: carImageView.leadingAnchor, constant: xPoint).isActive = true
        subview.topAnchor.constraint(equalTo: carImageView.topAnchor, constant: yPoint).isActive = true
        subview.widthAnchor.constraint(equalTo: carImageView.widthAnchor, multiplier: 0.07).isActive = true
        subview.heightAnchor.constraint(equalTo: subview.widthAnchor, multiplier: 1).isActive = true
        
        if chosenButton == "redDamageButton" {
            imageName = myImages[0]
        } else if chosenButton == "yellowDamageButton" {
            imageName = myImages[1]
        } else if chosenButton == "greenDamageButton" {
            imageName = myImages[2]
        }
        if chosenButton != "" {
            subview.image = UIImage(named: imageName)
            allImageSubviews.append(subview)
            localizedButtonsOnImage.append(LocalizedDamage(imageColor: imageName,
                                                           CoordinatePointX: xPoint,
                                                           CoordinatePointY: yPoint))
        }
    }
    
    @IBAction func didTapClearAll(_ sender: UIButton) {
        localizedButtonsOnImage.removeAll()
        carImageView.subviews.forEach { $0.removeFromSuperview() }
    }
    
    @IBAction func didTapBack(_ sender: UIButton) {
        dismissWithReturnTransition()
    }
    
    @IBAction func didTapSaveAndExit(_ sender: UIButton) {
        
        if registrationTF.text!.count >= 7 && !customerNameTF.text!.isEmpty && !technicianNameTF.text!.isEmpty && !dateOfWorkTF.text!.isEmpty {
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "popUpVC") as! PopUpVC
            vc.handler = onSaveAndExitDialog
            vc.receivedText = "Are you sure you want to finish the work on this record?"
            vc.modalPresentationStyle = .overFullScreen
            present(vc, animated: false)
        } else {
            if registrationTF.text!.count < 7 {
                changeBorderToRed(textField: registrationTF)
            }
            if customerNameTF.text!.isEmpty {
                changeBorderToRed(textField: customerNameTF)
            }
            if technicianNameTF.text!.isEmpty {
                changeBorderToRed(textField: technicianNameTF)
            }
            if dateOfWorkTF.text!.isEmpty {
                changeBorderToRed(textField: dateOfWorkTF)
            }
        }
    }
    @IBAction func didTapUndo(_ sender: UIButton) {
        if !localizedButtonsOnImage.isEmpty && !allImageSubviews.isEmpty {
            localizedButtonsOnImage.removeLast()
            allImageSubviews.last!.removeFromSuperview()
            allImageSubviews.removeLast()
        }
    }
    
    func onSaveAndExitDialog(isConfirmed: Bool, indexPath: IndexPath?) {
        if isConfirmed {
            let vc = storyboard?.instantiateViewController(withIdentifier: "signatureVC") as! SignatureVC
            
            vc.record.recordID = record.recordID
            vc.record.registration = registrationTF.text!
            vc.record.customerName = customerNameTF.text!
            vc.record.technicianName = technicianNameTF.text!
            vc.record.dateOfWork = dateOfWorkTF.text!
            vc.record.damageReport = "\(localizedButtonsOnImage.count)"
            if localizedButtonsOnImage.count == 0 {
                vc.record.damageReport = "-"
            }
            vc.record.localizedButtonsOnImage = LocalizedDamage.toString(record:localizedButtonsOnImage)
            
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: false)
        }
    }
    
    func onDatePickerDialog(isConfirmed: Bool, dateTime: String) {
        if isConfirmed {
            dateOfWorkTF.text = dateTime
            dateOfWorkTF.attributedText = colorString(input: dateOfWorkTF.text!)
        }
    }
    
    @IBAction func didTapDateOfWorkCoverView(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
        let vc = storyboard?.instantiateViewController(withIdentifier: "datePickerPopUpVC") as! DatePickerPopUpVC
        vc.handler = onDatePickerDialog
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: false)
    }
    
    func setupTextFieldsAndButtons() {
        if record.recordID != "" {
            registrationTF.text = record.registration
            customerNameTF.text = record.customerName
            technicianNameTF.text = record.technicianName
            dateOfWorkTF.text = record.dateOfWork
            
            localizedButtonsOnImage = LocalizedDamage.fromString(json: record.localizedButtonsOnImage)
            
            dateOfWorkTF.attributedText = colorString(input: dateOfWorkTF.text!)
        }
        
        registrationTF.layer.cornerRadius = 5.0
        carImageView.layer.borderWidth = 1.0
        carImageView.layer.borderColor = UIColor.black.cgColor
        BlackBorderWith1px(button: redDamageButton)
        BlackBorderWith1px(button: yellowDamageButton)
        BlackBorderWith1px(button: greenDamageButton)
    }
    
    func loadSubviews() {
        for singleDamage in localizedButtonsOnImage {
            let currentSubview = UIImageView()
            carImageView!.addSubview(currentSubview)
            currentSubview.translatesAutoresizingMaskIntoConstraints = false
            currentSubview.leadingAnchor.constraint(equalTo: carImageView.leadingAnchor, constant: singleDamage.CoordinatePointX).isActive = true
            currentSubview.topAnchor.constraint(equalTo: carImageView.topAnchor, constant: singleDamage.CoordinatePointY).isActive = true
            currentSubview.widthAnchor.constraint(equalTo: carImageView.widthAnchor, multiplier: 0.07).isActive = true
            currentSubview.heightAnchor.constraint(equalTo: currentSubview.widthAnchor, multiplier: 1).isActive = true
            currentSubview.image = UIImage(named: singleDamage.imageColor)
            allImageSubviews.append(currentSubview)
        }
    }
    
    func BlackBorderWith1px (button: UIButton) {
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor.black.cgColor
    }
    
    func BlackBorderWith3px (button: UIButton) {
        carImageView.isUserInteractionEnabled = true
        button.layer.borderWidth = 3.0
        button.layer.borderColor = UIColor.black.cgColor
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        switch textField {
        
        case registrationTF:
            
            if let _ = string.rangeOfCharacter(from: .lowercaseLetters){
                if textField.text!.count < 10 {
                    textField.insertText(string.uppercased())
                }
            return false
            }
            let allowedCharacters = NSCharacterSet.init(charactersIn: "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz").inverted
            let newLength: Int = textField.text!.count + string.count - range.length
            let strValid = string.rangeOfCharacter(from: allowedCharacters) == nil
                return (strValid && newLength <= 10)
            
        case customerNameTF:
            
            let checkCharacters = CharacterSet.init(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz ")
            if let _ = string.rangeOfCharacter(from: checkCharacters) {
                var handled: Bool = false
                if textField.text!.isEmpty {
                    textField.insertText(string.uppercased())
                    handled = true
                } else if previousChar == " " {
                    handled = true
                    if textField.text!.count < 50 {
                        textField.insertText(string.uppercased())
                    }
                } else if previousChar != " " {
                    handled = true
                    if textField.text!.count < 50 {
                        textField.insertText(string.lowercased())
                    }
                }
                previousChar = string
                return !handled
            }
            
            let allowedCharacters = checkCharacters.inverted
            let strValid = string.rangeOfCharacter(from: allowedCharacters) == nil
            let newLength: Int = textField.text!.count + string.count - range.length
            return (strValid && newLength <= 50)
            
        case technicianNameTF:
            
            if let _ = string.rangeOfCharacter(from: .lowercaseLetters) {
                if textField.text!.isEmpty {
                    textField.insertText(string.uppercased())
                    return false
                } else {
                    if textField.text!.count < 50 {
                        return true
                    } else {
                        return false
                    }
                }
            }
            
            let allowedCharacters = NSCharacterSet.init(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz ").inverted
            let strValid = string.rangeOfCharacter(from: allowedCharacters) == nil
            let newLength: Int = textField.text!.count + string.count - range.length
            return (strValid && newLength <= 50)
            
        default:
            return true
        }
    }
}
