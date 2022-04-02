//
//  Mascota+CoreDataProperties.swift
//  EJER05M05
//
//  Created by Erick Ayala Delgadillo on 02/04/22.
//
//

import Foundation
import CoreData


extension Mascota {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Mascota> {
        return NSFetchRequest<Mascota>(entityName: "Mascota")
    }

    @NSManaged public var edad: Double
    @NSManaged public var genero: String?
    @NSManaged public var nombre: String?
    @NSManaged public var tipo: String?

}

extension Mascota : Identifiable {

}
