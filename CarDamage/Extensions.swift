//
//  Extensions.swift
//  CarDamage
//
//  Created by Darren Asamov on 21/01/2022.
//

import UIKit

extension UIViewController: UITextFieldDelegate {
    public func textFieldDidChangeSelection(_ textField: UITextField) {
        textField.layer.borderWidth = 0.0
    }
}

func changeBorderToRed(textField: UITextField) {
    textField.layer.borderWidth = 1.0
    textField.layer.borderColor = UIColor.red.cgColor
}

func colorString(input: String) -> NSAttributedString {
    var coloredString = NSMutableAttributedString(string: input)
    coloredString = NSMutableAttributedString(string: input)
    if input.count == 18 {
            coloredString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: NSRange(location: 0, length: 10))
        coloredString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.green, range: NSRange(location: 11, length: 7))
    } else if input.count == 19 {
        coloredString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: NSRange(location: 0, length: 11))
    coloredString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.green, range: NSRange(location: 12, length: 7))
    }
    return coloredString
}

extension UIViewController {
    
    func goToNextScreen(identifier: String) {
        let vc = self.storyboard?.instantiateViewController(identifier: identifier)
        let transition = CATransition()
        transition.duration = 1
        transition.type = CATransitionType.push
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.subtype = CATransitionSubtype.fromRight
        self.view.window!.layer.add(transition, forKey: kCATransition)
        vc!.modalPresentationStyle = .fullScreen
        present(vc!,animated: false, completion: nil)
    }
    
    func dismissWithReturnTransition() {
        let transition = CATransition()
        transition.duration = 1
        transition.type = CATransitionType.push
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.subtype = CATransitionSubtype.fromLeft
        view.window!.layer.add(transition, forKey: kCATransition)
        dismiss(animated: false)
    }
    
    func initializeHideKeyboard(){
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissMyKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissMyKeyboard(){
        view.endEditing(true)
    }
}

extension UIView {
    func createImage() -> UIImage? {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { context in
            layer.render(in: context.cgContext)
        }
    }
    
    func animateIn() {
        self.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.alpha = 0

        UIView.animate(withDuration: 0.8) {
            self.transform = CGAffineTransform.identity
            self.alpha = 1
        }
    }
    
    func animateOut() {
        UIView.animate(withDuration: 0.8, animations: {
            self.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.alpha = 0

        }, completion: { _ in
            guard let parent = self.parentContainerViewController() else { return }
            parent.dismiss(animated: false)
        })
    }
}
 
