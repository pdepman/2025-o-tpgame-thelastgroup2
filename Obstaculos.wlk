object muro {
    var position = game.at(25,1)   
    method image() = 'muros.png'
    method position() = position
    method position(newPosition) {
        position = newPosition 
    }
}

object fogata {
    var position = game.at(50,1)   
    method image() = 'fogata.png'

    method position() = position
    method position(newPosition) {
        position = newPosition 
    }
  
}

object pocion {
    var position = game.at(15,1)   
    method image() = 'pocion.png'

    method position() = position
    method position(newPosition) {
        position = newPosition 
    }
}