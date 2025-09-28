object muro {
    var position = game.at(0,0)   
    method imagen() = 'muros.png'

    method position() = position
    method position(newPosition) {
        position = newPosition 
    }
}

object fogata {
    var position = game.at(1,1)   
    method imagen() = 'fogata.png'

    method position() = position
    method position(newPosition) {
        position = newPosition 
    }
  
}

object pocion {
    var position = game.at(2,2)   
    method imagen() = 'pocion.png'

    method position() = position
    method position(newPosition) {
        position = newPosition 
    }
}