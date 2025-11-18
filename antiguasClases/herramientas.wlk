
/*class Herramienta{ // se implementa una clase herramienta
  const nombreHerramienta
    const posX
    const posY 
    var position = game.at(posX, posY)
    const posicionOriginal = game.at(posX, posY)  // guardamos la posición original para cálculos de cámara
    // atributos de imagen para el efecto visual (sprite)
    const idleFrames
    var image = idleFrames.head()
    var frameActual = 0
    method image() = image

    method position() = position 
    method position (newPosition) {
        position = newPosition
    }

    method actualizarPorCamara(offsetX) {
        const nuevaX = posicionOriginal.x() - offsetX
        position = game.at(nuevaX, posicionOriginal.y())
    }

    method activarIdle(){
      game.onTick(500, "idle"+nombreHerramienta, {self.idleAnimation()})
    }
    method idleAnimation(){
      image = idleFrames.get(frameActual % idleFrames.size())
      frameActual +=1
      
    }

}
const matafuegos = new Herramienta(nombreHerramienta = "matafuegos", posX= 30, posY=1,idleFrames=["matafuegos.png", "matafuegos2.png"])
const tijeras = new Herramienta(nombreHerramienta = "tijeras", posX= 40, posY=-2,idleFrames=["tijeras.png", "tijeras2.png"])
*/