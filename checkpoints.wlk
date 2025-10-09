
object final {
    var position = game.at(90,1)   
    const posicionOriginal = game.at(70,1) 
    method image() = 'final.png'
    method position() = position
    
    
    method actualizarPorCamara(offsetX) {
        const nuevaX = posicionOriginal.x() - offsetX
        position = game.at(nuevaX, posicionOriginal.y())
    }
}