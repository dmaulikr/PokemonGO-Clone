//
//  PokedexViewController.swift
//  PokemonGo Clone
//
//  Created by Matheus Lima on 03/09/17.
//  Copyright © 2017 Matheus Lima. All rights reserved.
//

import UIKit

class PokedexViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var capturedPokemons: [Pokemon] = []
    var notCapturedPokemons: [Pokemon] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let coreDataPokemon = CoreDataPokemon()
        self.capturedPokemons = coreDataPokemon.getPokemon(captured: true)
        self.notCapturedPokemons = coreDataPokemon.getPokemon(captured: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backToMap(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // Table functions //

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Capturados"
        }
        else {
            return "Não Capturados"
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.capturedPokemons.count
        }
        else {
            return self.notCapturedPokemons.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let pokemon: Pokemon
        
        if indexPath.section == 0 {
            pokemon = self.capturedPokemons[indexPath.row]
        }
        else {
            pokemon = self.notCapturedPokemons[indexPath.row]
        }
        
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "reuseIdentifier")
        
        cell.textLabel?.text = pokemon.name
        cell.imageView?.image = UIImage(named: pokemon.imageName!)
        
        return cell
    }

}
