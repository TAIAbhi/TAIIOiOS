//
//  ContactsInteractor.swift
//  Tagabout
//
//  Created by Karun Pant on 25/02/18.
//  Copyright © 2018 Tagabout. All rights reserved.
//

import Foundation
import Contacts

struct ContactsInteractor{
    
    
    private let contactStore = CNContactStore()
    
    public func getAllContacts(completion: ( [[AnyHashable : Any]] ) -> ()){
        self.requestForAccess { (access : Bool) in
            if access{
                let contactStore = CNContactStore()
                let keysToFetch = [
                    CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
                    CNContactEmailAddressesKey,
                    CNContactPhoneNumbersKey,
                    CNContactOrganizationNameKey,
                    CNContactBirthdayKey,
                    CNContactThumbnailImageDataKey] as? [CNKeyDescriptor]
                
                // Get all the containers
                var allContainers: [CNContainer] = []
                do {
                    allContainers = try contactStore.containers(matching: nil)
                } catch {
                    print("Error fetching containers")
                }
                
                var results: [CNContact] = []
                
                // Iterate all containers and append their contacts to our results array
                for container in allContainers {
                    let fetchPredicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)
                    
                    do {
                        let containerResults = try contactStore.unifiedContacts(matching: fetchPredicate, keysToFetch: keysToFetch!)
                        results.append(contentsOf: containerResults)
                    } catch {
                        print("Error fetching results for container")
                    }
                
                }
            }else{
              // request failed.
            }
        }
        
    }
    
    fileprivate func encodeContact(contact : CNContact){
        
    }
    
    fileprivate func requestForAccess(completion: @escaping ( Bool ) -> ()){
        let authStatus = CNContactStore.authorizationStatus(for: .contacts)
        switch authStatus {
        case .authorized:
            completion(true)
            break
        case .restricted:
            completion(false)
            break
        case .notDetermined, .denied:
            contactStore.requestAccess(for: .contacts, completionHandler: { (access : Bool, error : Error?) in
                if access{
                    completion(true)
                }else{
                    completion(false)
                }
            })
        default:break
            
        }
    }
}
