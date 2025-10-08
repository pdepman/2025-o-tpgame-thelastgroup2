import wollok.vm.*
import Obstaculos.*  //preguntar al profe, me parece malisimo
import wollok.game.*
import camara.*  // Importamos el nuevo archivo de cámara
object barraVida {
    var position = game.at(1, 45)
    const ancho = 10  // ancho máximo de la barra (puede representar 100 de vida)
    
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
    var direccion = "derecha" 
    

    
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
        direccion = "izquierda"
        
        
        // Si el personaje está en la zona central y la cámara puede moverse hacia la izquierda
        if (position.x() <= camara.zonaActivacion() && camara.offsetX() > 0) {
            
            camara.moverIzquierda()
        } else if (position.x() > 0) {
            
            position = position.left(1)
        }
    }
    
    method moverDerecha() {
        direccion = "derecha"
        
        
        // Si el personaje está en la zona central y la cámara puede moverse hacia la derecha
        if (position.x() >= camara.margenDerecho() && camara.offsetX() < (camara.anchoMundo() - game.width())) {
            
            camara.moverDerecha()
        } else if (position.x() < game.width() - 1) {
            
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