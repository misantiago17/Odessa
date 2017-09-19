//
//  Inimigo.swift
//  Odessa
//
//  Created by Michelle Beadle on 15/09/17.
//  Copyright © 2017 Michelle Beadle. All rights reserved.
//

import Foundation

class Inimigo {
    
    var nome: String
    var vida: Int
    var velocidade: Float
    var defesa: Int
    var dano: Int
    var tipo: String
    
    init(nome:String, vida:Int, velocidade:Float, defesa:Int, dano: Int, tipo: String){
        
        self.nome = nome
        self.vida = vida
        self.velocidade = velocidade
        self.defesa = defesa
        self.dano = dano
        self.tipo = tipo
        
    }


    
}
