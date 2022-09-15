//
//  SplatCarRecord.swift
//  CarDamage
//
//  Created by Darren Asamov on 21/01/2022.
//

import UIKit
import RealmSwift

let REALM_QUEUE = DispatchQueue(label: "realmQueue")

class Record: Object {
    @objc dynamic var recordID: String = ""
    @objc dynamic var registration: String = ""
    @objc dynamic var customerName: String = ""
    @objc dynamic var technicianName: String = ""
    @objc dynamic var dateOfWork: String = ""
    @objc dynamic var damageReport: String = ""
    @objc dynamic var localizedButtonsOnImage: String = ""
    @objc dynamic var technicianSignature: String = ""
    
    convenience init(registration: String, customerName: String, technicianName: String, dateOfWork: String, damageReport: String, localizedButtonsOnImage: String , technicianSignature: String) {
        self.init()
        self.recordID = UUID().uuidString
        self.registration = registration
        self.customerName = customerName
        self.technicianName = technicianName
        self.dateOfWork = dateOfWork
        self.damageReport = damageReport
        self.localizedButtonsOnImage = localizedButtonsOnImage
        self.technicianSignature = technicianSignature
    }
    
    
    static func createRecord(record: Record) {
        REALM_QUEUE.sync {
            do {
                let realm = try Realm(configuration: RealmConfig.runDataConfig)
                try realm.write {
                    realm.add(record)
                    try realm.commitWrite()
                }
            } catch let error{
                print(error.localizedDescription)
            }
        }
    }
    
    static func deleteRecord(record: Record) {
        REALM_QUEUE.sync {
            do {
                let searchForID = record.recordID
                let realm = try Realm(configuration: RealmConfig.runDataConfig)
                let predicate = NSPredicate(format: "recordID == %@", searchForID)
                let allRecords = realm.objects(Record.self).filter(predicate).first
                if allRecords?.recordID == record.recordID {
                    try! realm.write {
                        realm.delete(record)
                        try realm.commitWrite()
                    }
                }
            } catch {
                print(error)
            }
        }
    }
    
    static func getAllRecords() -> [Record]? {
        REALM_QUEUE.sync {
            var allDamageReports: [Record] = [Record]()
            do {
                let realm = try Realm(configuration: RealmConfig.runDataConfig)
                let allRecords = realm.objects(Record.self)
                for report in allRecords {
                    allDamageReports.append(report)
                }
                return allDamageReports
            } catch {
                return nil
            }
        }
    }
    
    static func lookingForRecord(record: Record) -> Record? {
        REALM_QUEUE.sync {
            do {
                let searchForID = record.recordID
                let realm = try Realm(configuration: RealmConfig.runDataConfig)
                let predicate = NSPredicate(format: "recordID == %@", searchForID)
                let allRecords = realm.objects(Record.self).filter(predicate).first
                    return allRecords
            } catch {
                print(error)
                return nil
            }
        }
    }
}
