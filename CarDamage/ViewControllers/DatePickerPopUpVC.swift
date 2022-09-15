//
//  DatePickerPopUpVC.swift
//  CarDamage
//
//  Created by Darren Asamov on 27/01/2022.
//

import UIKit

class DatePickerPopUpVC: UIViewController {
    
    var isConfirmed = false
    
    typealias ConfirmResult = (Bool, String) -> Void
    
    var handler: ConfirmResult = {_,_ in}

    @IBOutlet weak var blurEfectView: UIVisualEffectView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var popUpWindow: UIView!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        datePicker.minimumDate = Date()
        blurEfectView.animateIn()
        popUpWindow.animateIn()
    }
    
    func dateTimeChanged() -> String {
        isConfirmed = true
        var dateTime = ""
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "DD/MM/YYYY - HH/mm"
        dateTime = dateFormat.string(from: datePicker.date)
        return dateTime
    }
    
    @IBAction func didTapSave(_ sender: UIButton) {
        isConfirmed = false
        let dateTime = dateTimeChanged()
        dismiss(animated: false)
        handler(isConfirmed, dateTime)
    }
    
    @IBAction func didTapCancel(_ sender: UIButton) {
        blurEfectView.animateOut()
        popUpWindow.animateOut()
    }
}
