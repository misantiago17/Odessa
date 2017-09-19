//
//  Player.swift
//  Odessa
//
//  Created by Michelle Beadle on 15/09/17.
//  Copyright © 2017 Michelle Beadle. All rights reserved.
//

import Foundation

class Player {
    
    var nome: String
    var vida: Int
    var velocidade: Float
    var defesa: Int
    var numVida: Int
    var ataqueEspecial: Int
    
    init(nome:String, vida:Int, velocidade:Float, defesa:Int, numVida:Int, ataqueEspecial: Int){
        
        self.nome = nome
        self.vida = vida
        self.velocidade = velocidade
        self.defesa = defesa
        self.numVida = numVida
        self.ataqueEspecial = ataqueEspecial
        
    }
    
    
}
