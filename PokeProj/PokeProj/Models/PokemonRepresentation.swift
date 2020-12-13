//
//  PokemonRepresentation.swift
//  PokeProj
//
//  Created by Kenneth Jones on 12/11/20.
//

import Foundation

struct PokemonRepresentation: Codable {
    let id: Int
    let name: String
    let types: [String]
    let abilities: [String]
    let sprite: URL
    
    enum PokemonKeys: String, CodingKey {
        case id
        case name
        case types
        case abilities
        case sprites
        
        enum TypeDictionaryKeys: String, CodingKey {
            case type
            
            enum TypeKeys: String, CodingKey {
                case name
            }
        }
        
        enum AbilityDictionaryKeys: String, CodingKey {
            case ability
            
            enum AbilityKeys: String, CodingKey {
                case name
            }
        }
        
        enum SpriteKeys: String, CodingKey {
            case sprite = "front_default"
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: PokemonKeys.self)
        
        id = try container.decode(Int.self, forKey: .id)
        
        name = try container.decode(String.self, forKey: .name)
        
        var decodedTypes: [String] = []
        var typesContainer = try container.nestedUnkeyedContainer(forKey: .types)
        while !typesContainer.isAtEnd {
            let typesDictionaryContainer = try typesContainer.nestedContainer(keyedBy: PokemonKeys.TypeDictionaryKeys.self)
            let typeContainer = try typesDictionaryContainer.nestedContainer(keyedBy: PokemonKeys.TypeDictionaryKeys.TypeKeys.self, forKey: .type)
            
            let type = try typeContainer.decode(String.self, forKey: .name)
            decodedTypes.append(type)
        }
        types = decodedTypes
        
        var decodedAbilities: [String] = []
        var abilitiesContainer = try container.nestedUnkeyedContainer(forKey: .abilities)
        while !abilitiesContainer.isAtEnd {
            let abilityDictionaryContainer = try abilitiesContainer.nestedContainer(keyedBy: PokemonKeys.AbilityDictionaryKeys.self)
            let abilityContainer = try abilityDictionaryContainer.nestedContainer(keyedBy: PokemonKeys.AbilityDictionaryKeys.AbilityKeys.self, forKey: .ability)
            
            let ability = try abilityContainer.decode(String.self, forKey: .name)
            decodedAbilities.append(ability)
        }
        abilities = decodedAbilities
        
        let spriteContainer = try container.nestedContainer(keyedBy: PokemonKeys.SpriteKeys.self, forKey: .sprites)
        sprite = try spriteContainer.decode(URL.self, forKey: .sprite)
    }
}
