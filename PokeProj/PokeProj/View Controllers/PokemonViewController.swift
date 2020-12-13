//
//  PokemonViewController.swift
//  PokeProj
//
//  Created by Kenneth Jones on 12/12/20.
//

import UIKit

class PokemonViewController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var pokemonLabel: UILabel!
    @IBOutlet weak var spriteView: UIImageView!
    @IBOutlet weak var typesLabel: UILabel!
    @IBOutlet weak var abilitiesLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var forestView: UIImageView!
    
    var saveButtonHidden = true
    var searchBarHidden = true
    
    var pokemonController: PokemonController!
    var pokemon: PokemonRepresentation?
    var savedPokemon: Pokemon?
    var sprite: Data?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        forestView.image = UIImage(named: "forest")
        forestView.contentMode = .scaleAspectFill
        
        saveButton.backgroundColor = UIColor(hue: 190/360, saturation: 70/100, brightness: 80/100, alpha: 1.0)
        saveButton.tintColor = .white
        saveButton.layer.cornerRadius = 8.0

        searchBar.delegate = self
        updateViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !searchBar.isHidden {
            searchBar.becomeFirstResponder()
        }
    }
    
    @IBAction func savePokemon(_ sender: Any) {
        guard let pokemon = pokemon else { return }
        
        Pokemon(id: pokemon.id, name: pokemon.name, types: pokemon.types, abilities: pokemon.abilities, sprite: sprite)
        
        do {
            try CoreDataStack.shared.mainContext.save()
        } catch {
            NSLog("Error saving managed object context: \(error)")
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    private func updateViews() {
        if let pokemon = pokemon {
            title = pokemon.name.capitalized
            pokemonLabel.text = "\(pokemon.id) - \(pokemon.name.capitalized)"
            downloadImage(from: pokemon.sprite)
            displayArrayData(for: "types", in: typesLabel, from: pokemon.types)
            displayArrayData(for: "abilities", in: abilitiesLabel, from: pokemon.abilities)
        } else if let pokemon = savedPokemon,
                  let name = pokemon.name,
                  let sprite = pokemon.sprite,
                  let types = pokemon.types,
                  let abilities = pokemon.abilities {
            title = name.capitalized
            pokemonLabel.text = "\(pokemon.id) - \(name.capitalized)"
            spriteView.image = UIImage(data: sprite)
            displayArrayData(for: "types", in: typesLabel, from: types)
            displayArrayData(for: "abilities", in: abilitiesLabel, from: abilities)
        } else {
            title = "Pokemon Search"
            pokemonLabel.text = ""
            typesLabel.text = ""
            abilitiesLabel.text = ""
        }
        
        searchBar.isHidden = searchBarHidden
        saveButton.isHidden = saveButtonHidden
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
    
    private func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    private func downloadImage(from url: URL) {
        getData(from: url) { (data, _, error) in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async { [weak self] in
                self?.sprite = UIImage(data: data)?.pngData()
                self?.spriteView.image = UIImage(data: data)
            }
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchTerm = searchBar.text else { return }
        
        searchBar.resignFirstResponder()
        
        pokemonController.fetchPokemon(searchTerm: searchTerm) { (result) in
            DispatchQueue.main.async {
                do {
                    self.pokemon = try result.get()
                    self.saveButtonHidden = false
                    self.updateViews()
                } catch {
                    let alertController = UIAlertController(title: "No Data", message: "This Pokemon doesn't exist", preferredStyle: .alert)
                    let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    
                    alertController.addAction(alertAction)
                    self.present(alertController, animated: true)
                }
            }
        }
    }
}
