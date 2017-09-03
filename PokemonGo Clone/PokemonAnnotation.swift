//
//  PokemonAnnotation.swift
//  PokemonGo Clone
//
//  Created by Matheus Lima on 02/09/17.
//  Copyright © 2017 Matheus Lima. All rights reserved.
//

import UIKit
import MapKit

class PokemonAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var pokemon: Pokemon
    
    init(coordinate: CLLocationCoordinate2D, pokemon: Pokemon) {
        self.coordinate = coordinate
        self.pokemon = pokemon
    }
}
