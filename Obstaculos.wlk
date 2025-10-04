
// CONVERTIRLAS EN CLASES
object muro {
    var position = game.at(25,1)   
    method image() = 'muros.png'
    method position() = position
    method position(newPosition) {
        position = newPosition 
    }
}

object fogata {
    var position = game.at(50,1)   
    method image() = 'fogata.png'

    method position() = position
    method position(newPosition) {
        position = newPosition 
    }
  method energia() = -30
}

object pocion {
    var position = game.at(15,1)   
    method image() = 'pocion.png'

    method position() = position
    method position(newPosition) {
        position = newPosition 
    }
    method energia() = +20
}
object herramienta {   //aca entra clases, las herramientas pueden ser una clase, y asi tener distintas herramientas
//pero aun no domino clases, asique queda para mas adelante 
    var position = game.at(25,1)   
    method image() = 'matafuego.png'

    method position() = position
    method position(newPosition) {
        position = newPosition 
    }
  //aca quizas agregar un methodo que elimine la fogata al usar la herramienta.
}