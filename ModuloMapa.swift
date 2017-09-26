//
//  ModuloMapa.swift
//  Odessa
//
//  Created by Michelle Beadle on 15/09/17.
//  Copyright © 2017 Michelle Beadle. All rights reserved.
//

import Foundation
import UIKit

class ModuloMapa {
    
    var imagemCenario: UIImage
    var IDModulo: Int
    //Waves aparecem por tempo
    var waves: [Waves]?
    //  Os inimigos são posicionados ao longo do módulo
    var inimigos: [Inimigo]?
    // numInimigos tem o tipo dos inimigos pipocados pelo módulo e seu número de aparições
    var numInimigos: [String: Int]?
    
    init(imagemCenario: UIImage, IDModulo: Int, waves: [Waves], inimigos: [Inimigo], numInimigos: [String: Int]){
        
        self.imagemCenario = imagemCenario
        self.IDModulo = IDModulo
        self.waves = waves
        self.inimigos = inimigos
        self.numInimigos = numInimigos
        
    }
    
    // fazer uma função para cuidar da posição de cada set de inimigos no módulo
    // fazer um função cuidar da posição que a wave vai começar a aparecer

    
    // precisa de um arquivo json com todos os possiveis modulos iniciados e aramazenar esses módulos em algum lugar (provavelmente o Singleton?)
    
}
