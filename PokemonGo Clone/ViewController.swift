//
//  ViewController.swift
//  PokemonGo Clone
//
//  Created by Matheus Lima on 31/08/17.
//  Copyright © 2017 Matheus Lima. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    var locationManager = CLLocationManager()
    var count = 0;
    var coreDataPokemon: CoreDataPokemon!
    var pokemons: [Pokemon] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Classe que ira gerenciar o mapa
        self.mapView.delegate = self
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        
        // Get pokemons
        self.coreDataPokemon = CoreDataPokemon()
        self.pokemons = self.coreDataPokemon.recoverAllPokemons()
        
        // Show pokemons
        Timer.scheduledTimer(withTimeInterval: 8, repeats: true) { (timer) in
            self.showPokemon()
        }
        
    }
    
    
    // Map Functions
    
    // Chamado sempre que uma anotacao ou a marcacao do usuario eh criada
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
        
        if annotation is MKUserLocation {
            annotationView.image = #imageLiteral(resourceName: "player")
        }
        else {
            let pokemon = (annotation as! PokemonAnnotation).pokemon
            annotationView.image = UIImage(named: pokemon.imageName!)
        }
        // Set frame size
        var frame = annotationView.frame
        frame.size.height = 40
        frame.size.width = 40
        annotationView.frame = frame
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let annotation = view.annotation
        let pokemon = (annotation as! PokemonAnnotation).pokemon
        // Possibilitar varios cliques na anotacao
        mapView.deselectAnnotation(annotation, animated: true)

        if annotation is MKUserLocation {
            return
        }
        
        if let coordinateAnnotation = annotation?.coordinate {
            self.centerRegion(coordinate: coordinateAnnotation, 75, 75)
        }
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { (timer) in
            if self.capturePokemon(pokemon: pokemon) {
                self.coreDataPokemon.savePokemon(pokemon: pokemon)
                self.mapView.removeAnnotation(annotation!)
                self.createAlert(title: "Parabéns!", message: "Você capturou o pokemon: \(pokemon.name!)")
            }
            else {
                self.createAlert(title: "Você não pode Capturar", message: "Você precisa se aproximar mais para capturar o pokemon: \(pokemon.name!)")
            }
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status != .authorizedWhenInUse && status != .notDetermined {
            let alertController = UIAlertController(title: "Permissão de localização",
                                                    message: "Para utilizar o app, é necessário habilitar acesso à sua localização",
                                                    preferredStyle: .alert)
            
            let settingsAction = UIAlertAction(title: "Abrir configurações", style: .default, handler: { (settingsAlert) in
                if let settings = NSURL(string: UIApplicationOpenSettingsURLString) {
                    UIApplication.shared.open(settings as URL)
                }
            })
            
            let cancelAction = UIAlertAction(title: "Cancelar", style: .destructive, handler: nil)
            
            alertController.addAction(settingsAction)
            alertController.addAction(cancelAction)
            
            present(alertController, animated: true, completion: nil)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Center
        if count < 5 {
            if let userCoordinate = self.locationManager.location?.coordinate {
                self.centerRegion(coordinate: userCoordinate, 200, 200)
            }
            self.count += 1
        } else {
            self.locationManager.stopUpdatingLocation()
        }
    }
    
    @IBAction func centerPlayer(_ sender: Any) {
        if let userCoordinate = self.locationManager.location?.coordinate {
            self.centerRegion(coordinate: userCoordinate, 200, 200)
        }
    }
    
    @IBAction func openPokedex(_ sender: Any) {
    }
    
    // Help functions //
    
    /*
     Funcao para centralizar uma regiao no mapa
     **/
    func centerRegion(coordinate: CLLocationCoordinate2D,_ latitudeMeters: CLLocationDistance,_ longitudeMeters: CLLocationDistance) {
        let region = MKCoordinateRegionMakeWithDistance(coordinate, latitudeMeters, longitudeMeters)
        self.mapView.setRegion(region, animated: true)
    }
    
    /*
     Funcao para gerar pokemons no mapa aleatoriamente
     **/
    func showPokemon() {
        if let userCoordinate = self.locationManager.location?.coordinate {
            let randomIndex = Int(arc4random_uniform(UInt32(self.pokemons.count)))
            let randomPokemon = self.pokemons[randomIndex]
            
            let annotation = PokemonAnnotation(coordinate: userCoordinate, pokemon: randomPokemon)
            let randomLat = (Double(arc4random_uniform(400)) - 200) / 100000.0
            let randomLon = (Double(arc4random_uniform(400)) - 200) / 100000.0
            
            annotation.coordinate.latitude  += randomLat
            annotation.coordinate.longitude += randomLon
            
            self.mapView.addAnnotation(annotation)
        }
    }
    
    /*
     Funcao que tenta capturar um pokemon caso o player esteja visivel no mapa
     **/
    func capturePokemon(pokemon: Pokemon) -> Bool{
        if let coord = self.locationManager.location?.coordinate {
            // Verificar se um ponto esta visivel na area do mapa
            if MKMapRectContainsPoint(self.mapView.visibleMapRect, MKMapPointForCoordinate(coord)) {
                self.coreDataPokemon.savePokemon(pokemon: pokemon)
                return true
            }
        }
        return false;
    }
    
    func createAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let ok = UIAlertAction(title: "ok", style: .default, handler: nil)
        alertController.addAction(ok)
        self.present(alertController, animated: true, completion: nil)
    }
    
}

