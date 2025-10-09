
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
