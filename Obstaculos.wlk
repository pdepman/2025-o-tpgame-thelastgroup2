
// CONVERTIRLAS EN CLASES

class Obstaculo { // se implementan clases de los obstaculos
    const nombreObstaculo
    const danio
    const posX
    const posY 
    var position = game.at(posX, posY)
    const posicionOriginal = game.at(posX, posY)  // guardamos la posición original a efectos de uso de camara
    
    method image() = nombreObstaculo +'.png'

    method position() = position 
    method position (newPosition) {
        position = newPosition
    }
    method energia() = -danio 
    
    // Actualiza la posición según el offset/desplazamiento de la cámara
    method actualizarPorCamara(offsetX) {
        const nuevaX = posicionOriginal.x() - offsetX
        position = game.at(nuevaX, posicionOriginal.y())
    }
}
// instanciacion de los obstaculos (clase)
const muro = new Obstaculo(nombreObstaculo = "muros", danio = 0, posX = 25, posY = 1)
const fogata = new Obstaculo (nombreObstaculo = "fogata", danio = -30, posX = 50, posY = 1)




class Pocion { // Se implementa una clase de pociones, por si definimos en un futuro varias 
  const tipo
  const cantidad
  const posX
  const posY
  var position = game.at(posX, posY)
  const posicionOriginal = game.at(posX, posY)  // guardamos la posición original para cálculos de cámara

  method image() = tipo + '.png'

  method position() = position  
  method position(newPosition) { position = newPosition }  

  method desaparecer() { 
    game.removeVisual(self) 
    }

  method aplicarEfecto(personaje) {
    if (tipo == "pocionVida") {
      personaje.vida(self)
      
    }
    else if (tipo == "pocionVelocidad") { // esto si en un futuro se desea aplicar
      personaje.aumentarVelocidad(cantidad)
    }
    self.desaparecer()
  }

  method energia() = cantidad
  
  // Actualiza la posición según el offset/desplazamiento de la cámara
  method actualizarPorCamara(offsetX) {
    const nuevaX = posicionOriginal.x() - offsetX
    position = game.at(nuevaX, posicionOriginal.y())
  }
}
const pocionVida = new Pocion (tipo = "pocionVida", cantidad = 25, posX =15, posY=1)

class herramienta{ // se implementa una clase herramienta
  const nombreHerramienta
    const posX
    const posY 
    var position = game.at(posX, posY)
    const posicionOriginal = game.at(posX, posY)  // guardamos la posición original para cálculos de cámara
    
    method image() = nombreHerramienta +'.png'

    method position() = position 
    method position (newPosition) {
        position = newPosition
    }

    method actualizarPorCamara(offsetX) {
        const nuevaX = posicionOriginal.x() - offsetX
        position = game.at(nuevaX, posicionOriginal.y())
    }
}
const matafuegos = new herramienta(nombreHerramienta = "matafuegos", posX = 25, posY = 1)


object final {
    var position = game.at(70,1)   
    const posicionOriginal = game.at(70,1) 
    method image() = 'final.png'
    method position() = position
    
    
    method actualizarPorCamara(offsetX) {
        const nuevaX = posicionOriginal.x() - offsetX
        position = game.at(nuevaX, posicionOriginal.y())
    }
}