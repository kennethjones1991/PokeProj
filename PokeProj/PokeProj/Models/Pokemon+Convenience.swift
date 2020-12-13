//
//  Pokemon+Convenience.swift
//  PokeProj
//
//  Created by Kenneth Jones on 12/12/20.
//

import Foundation
import CoreData

extension Pokemon {
    @discardableResult convenience init(id: Int, name: String, types: [String], abilities: [String], sprite: Data? = nil, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.id = Int16(id)
        self.name = name
        self.types = types
        self.abilities = abilities
        self.sprite = sprite
    }
}
