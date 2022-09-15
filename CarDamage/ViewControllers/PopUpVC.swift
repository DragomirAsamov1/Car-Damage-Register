//
//  PopUpVC.swift
//  CarDamage
//
//  Created by Darren Asamov on 25/01/2022.
//

import UIKit

class PopUpVC: UIViewController {

    @IBOutlet weak var popUpWindow: UIView!
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var titleLabel: UILabel!
    var isConfirmed = false
    
    var receivedText = String()
    var indexPath = IndexPath()
    
    typealias ConfirmResult = (Bool, IndexPath?) -> Void
    
    var handler: ConfirmResult = {_,_  in }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        blurView.animateIn()
        popUpWindow.animateIn()
        titleLabel.text = receivedText
    }
    
    @IBAction func didTapConfirmButton(_ sender: UIButton) {
        isConfirmed = true
        dismiss(animated: false)
        handler(isConfirmed, indexPath)
    }
    @IBAction func didTapCancelButton(_ sender: UIButton) {
        isConfirmed = false
        handler(isConfirmed, indexPath)
        
        blurView.animateOut()
        popUpWindow.animateOut()
    }
}
