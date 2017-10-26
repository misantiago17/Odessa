//
//  Inimigo.swift
//  Odessa
//
//  Created by Michelle Beadle on 15/09/17.
//  Copyright © 2017 Michelle Beadle. All rights reserved.
//

import Foundation

class Inimigo {
    
    //ajeitar o modulo que recebe os dados do json para receber as posições dentro do módulo
    //colocar as posições do inimigo no módulo dentro do json
    //fazer as posições reccebidas serem relativas ao módulo e não ao mundo (fazer inimigo filho do módulo?)
    
    var nome: String
    var vida: Int
    var velocidade: Float
    var defesa: Int
    var dano: Int
    var tipo: String
    var imgName: String
    var posInModuleX: Float?
    var posInModuleY: Float?
    
    init(nome:String, vida:Int, velocidade:Float, defesa:Int, dano: Int, tipo: String, imgName: String, X: Float?, Y: Float?){
        
        self.nome = nome
        self.vida = vida
        self.velocidade = velocidade
        self.defesa = defesa
        self.dano = dano
        self.tipo = tipo
        self.imgName = imgName
        self.posInModuleX = X
        self.posInModuleY = Y
        
    }


    
}
