//
//  Waves.swift
//  Odessa
//
//  Created by Michelle Beadle on 15/09/17.
//  Copyright © 2017 Michelle Beadle. All rights reserved.
//

import Foundation

class Waves {
    
    //numInimigos é um dictionary que contém o tipo do inimigo: número desses inimigos na horda
    var numInimigos: [String:Int]
    var dificuldade: Int
    var inimigos: [Inimigo]
    
    //O countdown é o tempo que a wave precisa até aparecer
    var countdown: Int
    
    init(numInimigos: [String:Int], dificuldade: Int, inimigos: [Inimigo], countdown: Int){
        
        self.numInimigos = numInimigos
        self.dificuldade = dificuldade
        self.inimigos = inimigos
        self.countdown = countdown
        
    }

    
}
