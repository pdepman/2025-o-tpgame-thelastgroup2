object muro {
    var position = game.at(15,15)   
    method image() = 'muros.png'
    method position() = position
    method position(newPosition) {
        position = newPosition 
    }
}

object fogata {
    var position = game.at(1,1)   
    method image() = 'fogata.png'

    method position() = position
    method position(newPosition) {
        position = newPosition 
    }
  
}

object pocion {
    var position = game.at(35,50)   
    method image() = 'pocion.png'

    method position() = position
    method position(newPosition) {
        position = newPosition 
    }
}