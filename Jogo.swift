//
//  Jogo.swift
//  Odessa
//
//  Created by Michelle Beadle on 15/09/17.
//  Copyright © 2017 Michelle Beadle. All rights reserved.
//

import Foundation

class Jogo {
    
    //Singleton
    static let sharedInstance: Jogo = {
        let instance = Jogo()
        return instance
        
    }()
    
    //variaveis do jogo
    var fase: Fase?
    var player: Player?
    
    
    convenience init () {
        self.init(fase: nil, player: nil)
    }
    
    init(fase: Fase?, player: Player?){
        self.fase = fase
        self.player = player

        
    }
    
    //função para controlar o som e configurações do jogo
    
}
