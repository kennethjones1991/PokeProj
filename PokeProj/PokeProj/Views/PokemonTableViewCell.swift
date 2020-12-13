//
//  PokemonTableViewCell.swift
//  PokeProj
//
//  Created by Kenneth Jones on 12/12/20.
//

import UIKit

class PokemonTableViewCell: UITableViewCell {

    @IBOutlet weak var spriteView: UIImageView!
    @IBOutlet weak var pokemonLabel: UILabel!
    @IBOutlet weak var typesLabel: UILabel!
    
    var pokemon: Pokemon? {
        didSet {
            updateViews()
        }
    }
    
    private func updateViews() {
        guard let pokemon = pokemon,
                  let name = pokemon.name,
                  let sprite = pokemon.sprite,
                  let types = pokemon.types else { return }
        
        pokemonLabel.text = name.capitalized
        spriteView.image = UIImage(data: sprite)
        displayArrayData(for: "types", in: typesLabel, from: types)
    }
    
    private func displayArrayData(for array: String, in label: UILabel, from data: [String]) {
        // Abilities: Ability1, Ability2, Ability3
        var finalString = "\(array.capitalized): " // "Abilities: "
        itemLoop: for item in data { // 1: "Abilities: Ability1, " 2: "Abilities: Ability1, Ability2, " 3: "Abilities: Ability1, Ability2, Ability3
            while item != data.last {
                finalString += "\(item.capitalized), " // 1: "Abilities: Ability1, " 2: "Abilities: Ability1, Ability2, "
                continue itemLoop
            }
            finalString += item.capitalized // "Abilities: Ability1, Ability2, Ability3"
        }
        label.text = finalString
    }

}
