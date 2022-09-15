//
//  ViewController.swift
//  CarDamage
//
//  Created by Darren Asamov on 20/01/2022.
//

import UIKit

class TableCell: UITableViewCell {
    @IBOutlet weak var registrationLabelInCell: UILabel!
    @IBOutlet weak var customerNameLabelInCell: UILabel!
    @IBOutlet weak var technicianNameLabelInCell: UILabel!
    @IBOutlet weak var dateOfWorkLabelInCell: UILabel!
    @IBOutlet weak var damageReportLabelInCell: UILabel!
    @IBOutlet weak var technicianSignatureImageInCell: UIImageView!
}

class ListVC: UIViewController {
    
    var damageRecords: [Record] = [Record]()

    @IBOutlet weak var registrationsTable: UITableView!
    @IBOutlet weak var noRecordsView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registrationsTable.delegate = self
        registrationsTable.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        damageRecords = Record.getAllRecords()!
        registrationsTable.reloadData()
        if damageRecords.isEmpty {
            noRecordsView.isHidden = false
        } else {
            noRecordsView.isHidden = true
        }
    }
    
    func onNewRecordDialog(isConfirmed: Bool, indexPath: IndexPath?) {
        if isConfirmed {
            goToNextScreen(identifier: "splatCarRecordVC")
        }
    }
        
    @IBAction func didTapAddNewRecord(_ sender: UIButton) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "popUpVC") as! PopUpVC
        vc.handler = onNewRecordDialog
        vc.receivedText = "Are you sure you want to add new record?"
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: false)
    }
    
    @IBAction func deleteThisRow(_ sender: UIButton) {
        let point = sender.convert(CGPoint.zero, to: registrationsTable)
        guard let indexPath = registrationsTable.indexPathForRow(at: point) else {
            return
        }
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "popUpVC") as! PopUpVC
        
        vc.receivedText = "Are you sure you want to delete this record?"
        vc.indexPath = indexPath
        vc.handler = onDeleteConfirm
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: false)
    }
    
    func onDeleteConfirm(confirmed: Bool, indexPath: IndexPath?) {
        if confirmed {
            Record.deleteRecord(record: damageRecords[indexPath!.row])
            damageRecords.remove(at: indexPath!.row)
            registrationsTable.deleteRows(at: [indexPath!], with: .fade)
            registrationsTable.reloadData()
        }
    }
    
    func convertBase64StringToImage (imageBase64String:String) -> UIImage? {
        let imageData = Data.init(base64Encoded: imageBase64String, options: .init(rawValue: 0))
        let image = UIImage(data: imageData!)
        return image
    }
    
    func colorStringForDamageReport(input: String) -> NSAttributedString {
        var coloredString = NSMutableAttributedString(string: input)
        coloredString = NSMutableAttributedString(string: input)
        var color = UIColor()
        if input == "1" {
            color = UIColor.green
        } else if input == "2" {
            color = UIColor.yellow
        } else if input == "-" {
            color = UIColor.black
        } else {
            color = UIColor.red
        }
        if Int(input)! < 10 || input == "-" {
            coloredString.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: NSRange(location: 0, length: 1))
        } else {
            coloredString.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: NSRange(location: 0, length: 2))
        }
        return coloredString
    }
}

extension ListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "splatCarRecordVC") as! SplatCarRecordVC
        vc.record = damageRecords[indexPath.row]
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: false)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
extension ListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        damageRecords.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableCell
        let currentImageAsString = damageRecords[indexPath.row].technicianSignature
        let currentSignatureAsImage = convertBase64StringToImage(imageBase64String: currentImageAsString)
        cell.registrationLabelInCell.text = damageRecords[indexPath.row].registration
        cell.customerNameLabelInCell.text = damageRecords[indexPath.row].customerName
        cell.technicianNameLabelInCell.text = damageRecords[indexPath.row].technicianName
        cell.dateOfWorkLabelInCell.text = damageRecords[indexPath.row].dateOfWork
        cell.damageReportLabelInCell.text = damageRecords[indexPath.row].damageReport
        cell.technicianSignatureImageInCell.image = currentSignatureAsImage
        
        cell.dateOfWorkLabelInCell.attributedText = colorString(input: damageRecords[indexPath.row].dateOfWork)
        cell.damageReportLabelInCell.attributedText = colorStringForDamageReport(input: damageRecords[indexPath.row].damageReport)
        return cell
    }
}
