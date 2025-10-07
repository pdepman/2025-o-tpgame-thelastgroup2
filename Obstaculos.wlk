
// CONVERTIRLAS EN CLASES

class Obstaculo { // se implementan clases de los obstaculos
    const nombreObstaculo
    const danio
    const posX
    const posY 
    var position = game.at(posX, posY)
    method image() = nombreObstaculo +'.png'

    method position() = position 
    method position (newPosition) {
        position = newPosition
    }
    method energia() = -danio 
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

  method image() = tipo + '.png'
  method desaparecer() { game.removeVisual(self) }

  method aplicarEfecto(personaje) {
    if (tipo == "pocionVida") {
      personaje.vida(self)
      
    }
    else if (tipo == "pocionVelocidad") { // 
      personaje.aumentarVelocidad(cantidad)
    }
    self.desaparecer()
  }

  method energia() = cantidad
}



object herramienta {   //aca entra clases, las herramientas pueden ser una clase, y asi tener distintas herramientas
//pero aun no domino clases, asique queda para mas adelante 
    var position = game.at(36,1)   
    method image() = 'matafuegos.png' // si esto es una clase, la imagen tendria que ser nula o vacia y 
    //cambiar la imagen segun la instancia del objeto... o algo asi

    method position() = position
    method position(newPosition) {
        position = newPosition 
    }
  //aca quizas agregar un methodo que elimine la fogata al usar la herramienta.
}
object final {
  var position = game.at(70,1)   
    method image() = 'final.png'
    method position() = position
}