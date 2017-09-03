//
//  CoreDataPokemon.swift
//  PokemonGo Clone
//
//  Created by Matheus Lima on 02/09/17.
//  Copyright © 2017 Matheus Lima. All rights reserved.
//

import UIKit
import CoreData

class CoreDataPokemon {
    
    // Recover context
    func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let context: NSManagedObjectContext = (appDelegate?.persistentContainer.viewContext)!
        
        return context
    }
    
    // Recover all pokemons
    func recoverAllPokemons() -> [Pokemon] {
        let context = self.getContext()
        
        do {
            let pokemons = try context.fetch( Pokemon.fetchRequest() ) as! [Pokemon]
            
            if pokemons.count == 0 {
                self.addAllPokemons()
                return self.recoverAllPokemons()
            }
            
            return pokemons
        }
        catch { }
        
        return []
    }
    
    func getPokemon(captured: Bool) -> [Pokemon] {
        
        let context = self.getContext()
        
        let request = Pokemon.fetchRequest() as NSFetchRequest<Pokemon>
        request.predicate = NSPredicate(format: "captured = %@", captured as CVarArg)
        
        do {
            let pokemons = try context.fetch(request) as [Pokemon]
            return pokemons
        }
        catch { }
        
        return []
        
    }
    
    func savePokemon(pokemon: Pokemon) {
        let context = self.getContext()
        pokemon.captured = true
        do {
            try context.save()
        }
        catch { }
    }

    // Add all pokemons
    func addAllPokemons() {
        
        let context = self.getContext()
        
        self.createPokemon(name: "Mew", imageName: "mew", captured: false)
        self.createPokemon(name: "Pikachu", imageName: "pikachu-2", captured: true)
        self.createPokemon(name: "Meowth", imageName: "meowth", captured: false)
        self.createPokemon(name: "Squirtle", imageName: "squirtle", captured: false)
        self.createPokemon(name: "Charmander", imageName: "charmander", captured: false)
        self.createPokemon(name: "Caterpie", imageName: "caterpie", captured: false)
        self.createPokemon(name: "Bullbasaur", imageName: "bullbasaur", captured: false)
        self.createPokemon(name: "Bellsprout", imageName: "bellsprout", captured: false)
        self.createPokemon(name: "Psyduck", imageName: "psyduck", captured: false)
        self.createPokemon(name: "Rattata", imageName: "rattata", captured: false)
        self.createPokemon(name: "Snorlax", imageName: "snorlax", captured: false)
        self.createPokemon(name: "Zubat", imageName: "zubat", captured: false)
        
        do {
            try context.save()
        }catch{}
    }
    
    // Create pokemons
    func createPokemon(name: String, imageName: String, captured: Bool) {
        let context = self.getContext()
        let pokemon = Pokemon(context: context)
        
        pokemon.name = name
        pokemon.imageName = imageName
        pokemon.captured = captured
    }
}
