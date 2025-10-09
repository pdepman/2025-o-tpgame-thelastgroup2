
// CONVERTIRLAS EN CLASES

class Obstaculo { // se implementan clases de los obstaculos
    const nombreObstaculo
    const danio
    const posX
    const posY 
    var position = game.at(posX, posY)
    const posicionOriginal = game.at(posX, posY)  // guardamos la posición original a efectos de uso de camara
    const idleFrames
    var image = idleFrames.head()
    var frameActual = 0
    method image() = image

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
    method activarIdle(){
      game.onTick(500, "idle"+nombreObstaculo, {self.idleAnimation()})
    }
    method idleAnimation(){
      image = idleFrames.get(frameActual % idleFrames.size())
      frameActual +=1
      
    }
}
// instanciacion de los obstaculos (clase)
const fogata = new Obstaculo(nombreObstaculo = "fogata", danio = 0, posX = 25, posY = 0, idleFrames = ["fogata.png", "fuego.png"])
const pasto = new Obstaculo(nombreObstaculo = "pasto", danio= 0, posX =40, posY =1, idleFrames = ["pasto.png", "pasto2.png"])


