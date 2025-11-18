/*
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

*/