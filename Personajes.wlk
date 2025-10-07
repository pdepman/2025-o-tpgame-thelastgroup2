import wollok.vm.*
import Obstaculos.*  //preguntar al profe, me parece malisimo
import wollok.game.*
object barraVida {
    var position = game.at(1, 45)
    var ancho = 10  // ancho máximo de la barra (puede representar 100 de vida)
    
    method position() = position
    method position(newPosition) { position = newPosition }
    
    method anchoActual(vida) = ancho * vida / 100   // calcula proporcional al % de vida

    method image() = "barra.png"  // puede ser un rectángulo verde
}

object fin {
    var vida = 100
    var position = game.at(0,0)
    const inventario = []
    var barra = null // ya se que dijeron que no definamos cosas con null pero es muyyy practico. 
    var direccion = "derecha"  // ✅ Nueva variable para dirección

    method vida() = vida
    method vida(evento) {
		    vida = vida + evento.energia()
        if (vida > 100) vida = 100
        if (vida < 0) vida = 0
        if (barra != null) barra.anchoActual(vida)
        if (vida == 0) self.morir()
	}
    method asignarBarra(b) { barra = b } 

    // cambio de imagen segun se mueva a la izquierda o derecha
    method image() = if (direccion == "izquierda") "finderLeft.png" else "finderRight.png"
    
    // metodos de movimiento
    method moverIzquierda() {
        if (position.x() > 0) {
            direccion = "izquierda"
            position = position.left(1)
        }
    }
    
    method moverDerecha() {
        if (position.x() < game.width() - 1) {
            direccion = "derecha"
            position = position.right(1)
        }
    }
    
    method moverArriba() {
        if (position.y() < game.height() - 1) {
            position = position.up(1)
        }
    }
    
    method moverAbajo() {
        if (position.y() > 0) {
            position = position.down(1)
        }
    }

    method position() = position
    method position(newPosition) { position = newPosition }
    
    method obtenerItem(item) {
    if (item == pocionVida) {
        self.vida(item)
        game.say(self, "Agarraste una poción! Vida: " + vida)
        item.desaparecer()
    } 
    
    else if (item == herramienta) { 
        // falta definir objeto herramienta... puede ser un matafuegos. 
        inventario.add(item)
        game.say(self, "Agarraste una herramienta")
        game.removeVisual(item)
         item.desaparecer()
    }
}
    method mover(nuevaPosicion) {
        self.position(nuevaPosicion)
    }
    
  method morir() {
        game.addVisual(gameOver) 
        game.stop()
    }
}
object gameOver{
    method image() = "gameover.png"
}