//
//  Reader_JSON.swift
//  Odessa
//
//  Created by Michelle Beadle on 26/09/17.
//  Copyright © 2017 Michelle Beadle. All rights reserved.
//

import Foundation
import SwiftyJSON

class Reader {
    
    // no arquvo json dentro de modulo precisa ter um set de inimigos e esse set precisa ser definido
    var jsonDictionary: [String: Any] = [:]
    
    init() {
        
        if let path = Bundle.main.path(forResource: "JsonFile", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                let jsonData = JSON(data: data)
                if jsonData == JSON.null {
                    print("Could not get json from file, make sure that file contains valid json.")
                } else {
                    self.jsonDictionary = jsonData.dictionaryObject!
                }
            } catch let error {
                print(error.localizedDescription)
            }
        } else {
            print("Invalid filename/path.")
        }
    }
    
    func GetAllModules() -> [ModuloMapa] {
        
        // Separa as informações do dicionário
        var modulesID: [Int] = []
        
        let modulesDictionary = jsonDictionary["ModuleMap"] as! [String: Any]
        
        for i in 1...modulesDictionary.count {
            
            modulesID.append(i)
        }
        
        // Coloca as informações na instancia
        var Modules: [ModuloMapa] = []
        
        for ID in modulesID {
            
            Modules.append(GetModule(ModuleID: ID))
        }
        
        return Modules
    }
    
    func GetModule(ModuleID: Int) -> ModuloMapa {
        
        // Separa as informações do dicionário
        let modulesDictionary = jsonDictionary["ModuleMap"] as! [String: Any]
        let moduleDictionary = modulesDictionary["Module\(ModuleID)"] as! [String:Any]
        
        let imageName = moduleDictionary["ImageName"] as! String
        let ID = Int(moduleDictionary["ID"] as! String)
        let waves = GetModuleSets(ModuleID: ID!)
        
        // Coloca as informações na instancia
        let module = ModuloMapa(imagemCenario: imageName, IDModulo: ID!, waves: waves)
        
        return module
    }
    
    func GetAllSets() -> [Waves] {
        
        // Separa as informações do dicionário
        let setsDictionary = jsonDictionary["Sets"] as! [String:Any]
        
        var setsID: [Int] = []
        
        for i in 1...setsDictionary.count {
            
            setsID.append(i)
        }
        
        // Coloca as informações na instancia
        var Sets: [Waves] = []
        
        for ID in setsID {
            
            Sets.append(GetSet(SetID: ID))
        }
        
        return Sets
    }
    
    func GetModuleSets(ModuleID: Int) -> [Waves] {
        
        // Separa as informações do dicionário
        let modulesDictionary = jsonDictionary["ModuleMap"] as! [String:Any]
        let moduleDictionary = modulesDictionary["Module\(ModuleID)"] as! [String:Any]
        let SetIDs = moduleDictionary["Sets"] as! [String]
        
        // Coloca as informações nas instancias
        var Sets: [Waves] = []
        
        for ID in SetIDs {
            Sets.append(GetSet(SetID: Int(ID)!))
        }
        
        return Sets
    }
    
    func GetSet(SetID: Int) -> Waves {
        
        // Separa as informações do dicionário
        let setsDictionary = jsonDictionary["Sets"] as! [String: Any]
        let setDictionary = setsDictionary["Set\(SetID)"] as! [String: Any]
        
        let ID = Int(setDictionary["ID"] as! String)
        let Dificulty = Int(setDictionary["Dificulty"] as! String)
        let ModuleID = Int(setDictionary["ModuleID"] as! String)
        let Enemies: [Inimigo] = GetSetEnemies(SetID: ID!)
        
        // Coloca as informações nas instancias
        let Set = Waves(ID: ID!, dificuldade: Dificulty!, moduloID: ModuleID!, inimigos: Enemies)
        
        return Set
    }
    
    func GetAllEnemies() -> [Inimigo] {
        
        // Separa as informações do dicionário
        let enemiesDictionary = jsonDictionary["Enemies"] as! [String:Any]
        
        var enemiesID: [Int] = []
        
        for i in 1...enemiesDictionary.count {

            enemiesID.append(i)
        }
        
        // Coloca as informações na instancia
        var Enemies: [Inimigo] = []
        
        for ID in enemiesID {
            
            Enemies.append(GetEnemy(EnemyID: ID))
        }
        
        return Enemies
    }
    
    func GetSetEnemies(SetID: Int) -> [Inimigo] {
        
        // Separa as informações do dicionário
        let setsDictionary = jsonDictionary["Sets"] as! [String: Any]
        let setDictionary = setsDictionary["Set\(SetID)"] as! [String: Any]
        let EnemiesIDs = setDictionary["Enemies"] as! [String]
        
        // Coloca as informações nas instancias
        var Enemies: [Inimigo] = []
        
        for ID in EnemiesIDs {
            Enemies.append(GetEnemy(EnemyID: Int(ID)!))
        }
        
        return Enemies
    }
    
    func GetEnemy(EnemyID: Int) -> Inimigo {
        
        // Separa as informações do dicionário
        let enemiesDictionary = jsonDictionary["Enemies"] as! [String: Any]
        let enemyDictionary = enemiesDictionary["Enemy\(EnemyID)"] as! [String: Any]
        
        let name = enemyDictionary["Name"] as! String
        let life = Int(enemyDictionary["Vida"] as! String)
        let velocity = Float(enemyDictionary["Velocidade"] as! String)
        let defence = Int(enemyDictionary["Defesa"] as! String)
        let attack = Int(enemyDictionary["Dano"] as! String)
        let type = enemyDictionary["Tipo"] as! String
        let img = enemyDictionary["ImgName"] as! String
        
        // Coloca as informações nas instancias
        let Enemy = Inimigo(nome: name, vida: life!, velocidade: velocity!, defesa: defence!, dano: attack!, tipo: type, imgName: img)
        
        return Enemy
    }
    
}
