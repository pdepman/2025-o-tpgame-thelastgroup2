import wollok.game.*

object Fin{
    var position = game.at(0,0)
    var inventario = []

    method imagen() = "fin.png"  
    method position() = position
    method position(newPosition) {
        position = newPosition 
    }
    method moverAlaDerecha(){
        position = position.right(1)
    }
    method moverAlaIzquierda(){
        position = position.left(1)
    }

}
