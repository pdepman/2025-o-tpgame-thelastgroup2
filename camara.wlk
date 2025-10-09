import wollok.game.*
import Obstaculos.*
import pociones.*
import herramientas.*
import checkpoints.*


object fondoJuego {
    var position = game.at(0, 0)
    const posicionOriginal = game.at(0, 0)
    
    method image() = "background.png"
    method position() = position
    method position(newPosition) { 
        position = newPosition 
    }
    
    // Actualiza la posición del fondo según el offset de la cámara
    method actualizarPorCamara(offsetX) {
        const nuevaX = posicionOriginal.x() - offsetX
        position = game.at(nuevaX, posicionOriginal.y())
    }
}

object camara {
    var offsetX = 0  // desplazamiento horizontal camara
    const anchoMundo = 370  
    const zonaActivacion = 30  // activa el scroll una vez q el personaje x=30 (posicion)
    const margenDerecho = 50  // activa el scroll una vez q el personaje x=60 (posicion) hacia la derecha 
    method offsetX() = offsetX
    method anchoMundo() = anchoMundo
    method zonaActivacion() = zonaActivacion
    method margenDerecho() = margenDerecho
    
    
    
    // activador de camara
    method debeActivarse(posicionPersonaje) {
        return posicionPersonaje.x() >= zonaActivacion && posicionPersonaje.x() <= margenDerecho
    }
    
    // movimiento de camera hacia la izq
    method moverIzquierda() {
        if (offsetX > 0) {
            offsetX = offsetX - 1
            self.actualizarPosicionObjetos()
        }
    }
    
    // movimiento de camera hacia la der
    method moverDerecha() {
        const limiteMaximo = anchoMundo - game.width()
        if (offsetX < limiteMaximo) {
            offsetX = offsetX + 1
            self.actualizarPosicionObjetos()
        }
    }
    
    // Actualiza las posiciones de todos los objetos segun el offset de la camara
    method actualizarPosicionObjetos() {
        fondoJuego.actualizarPorCamara(offsetX)
        
        fogata.actualizarPorCamara(offsetX)
        pasto.actualizarPorCamara(offsetX)
        pocionVida.actualizarPorCamara(offsetX)
        matafuegos.actualizarPorCamara(offsetX)
        final.actualizarPorCamara(offsetX)
    }
    
    // se obtiene la posicion real fuera del offset de la camara
    method posicionMundial(posicionPantalla) {
        return game.at(posicionPantalla.x() + offsetX, posicionPantalla.y())
    }
}
