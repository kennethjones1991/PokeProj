//
//  PokedexTableViewController.swift
//  PokeProj
//
//  Created by Kenneth Jones on 12/11/20.
//

import UIKit

class PokedexTableViewController: UITableViewController {
    
    var pokemonController = PokemonController()
    var saveButtonHidden = true
    var searchBarHidden = true
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokemonController.pokemon.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PokemonCell", for: indexPath)

        cell.textLabel?.text = pokemonController.pokemon[indexPath.row].name.capitalized

        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            pokemonController.pokemon.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SearchSegue" {
            if let searchVC = segue.destination as? PokemonViewController {
                searchVC.pokemonController = pokemonController
                searchVC.searchBarHidden = !searchBarHidden
                searchVC.saveButtonHidden = saveButtonHidden
            }
        } else if segue.identifier == "PokemonSegue" {
            if let pokemonVC = segue.destination as? PokemonViewController {
                if let indexPath = tableView.indexPathForSelectedRow {
                    pokemonVC.pokemonController = pokemonController
                    pokemonVC.pokemon = pokemonController.pokemon[indexPath.row]
                    pokemonVC.searchBarHidden = searchBarHidden
                    pokemonVC.saveButtonHidden = saveButtonHidden
                }
            }
        }
    }
}
