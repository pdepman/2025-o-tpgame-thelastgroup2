import wollok.game.*

object fin{
    var position = game.at(0,0)
    const inventario = []

    method image() = 'fin.png'  

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


    method obtenerItem(item) {
      game.say(self, item.nombre())
      game.removeVisual(item)
      self.agregarAlInventario(item)
    }
    
    method agregarAlInventario(item) {
        inventario.add(item)
    }


}
