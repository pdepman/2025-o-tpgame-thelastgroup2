import wollok.game.*

object fin{
    var position = game.at(0,0)
    const inventario = []

    method imagen() = 'fin.png'  

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

    method agregarAlInventario(objeto) {
        inventario.add(objeto)
    }

    method mencionarObjeto(objeto) {
      game.say(self,objeto.nombre())
      game.removeVisual(objeto)
      self.agregarAlInventario(objeto)
    }
}
