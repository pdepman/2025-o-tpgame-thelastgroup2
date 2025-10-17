import levels.*
import menuYTeclado.*

object juegoDungeonGame {
  var tieneLlave = false

  var property nivelActual = nivel3
  var movimientos = []

  //Config Audio
  const music = game.sound("InideGame.mp3")
  
  method iniciar(){

    //Set game properties
    game.title("Dungeon Game")
	  game.height(12)
	  game.width(24)
    game.boardGround("Fondo.png")

    //Set Background Audio
    music.shouldLoop(true)
    music.volume(0.3)
    music.play()
    

    //inicializo teclado
    configTeclado.iniciar()

    //Inicio el menu
    menu.iniciar()
  }
  
  method reset(){
    movimientos.forEach({_=> self.unDo()}) // Ejecuta unDo() por la cantidad de movimientos ejecutados
  }

  method clear(){
   cuerpo.clear()
   movimientos.clear()
   game.allVisuals().forEach({visual => game.removeVisual(visual)})
 }

  method siguienteNivel(){
    nivelActual = nivelActual.siguienteNivel()
    nivelActual.iniciar()
  }
  method anteriorNivel(){
    nivelActual = nivelActual.anteriorNivel()
    nivelActual.iniciar()
  }

  method addMove(movimiento){
    movimientos = [movimiento] + movimientos
  }

  method unDo(){
    if(!movimientos.isEmpty()){
      const move = movimientos.head()
      movimientos = movimientos.drop(1)
      move.unDo()
    }
  }

  method tomarLlave() { tieneLlave = true }
  method tieneLlave() = tieneLlave
    // Úsalo sólo en "Nuevo juego"
  method devolverLlave() { tieneLlave = false }
}

//*==========================| Cuerpo |==========================
  object cuerpo{

    // Cuerpo
    var property personaje = null

    method clear() {
      personaje = null
    }

    method agregarACuerpo(nuevo) {
      personaje = nuevo
    }

    method eliminarpersonaje(obj) {
      if (personaje == obj) { personaje = null }
    }
 
    method moverCuerpo(movimiento) {
      // Con un solo personaje, validamos y movemos ese único objeto
      if (personaje != null && personaje.puedeAvanzar(movimiento.nuevaPosicion(personaje))) {
        juegoDungeonGame.addMove(movimiento)       // registra para undo
        self.ejecutarMovimiento(movimiento)        // mueve al personaje
        const moveSound = game.sound("drag1.mp3")
        moveSound.volume(0.07)
        moveSound.play()
        personaje.collideWith()                        // collider del personaje
      }
    }


    method ejecutarMovimiento(movimiento) {
      if (personaje != null) { personaje.moveTo(movimiento) }
    }

    // Victoria: delega al nivel como antes
     method victoriaValida() = juegoDungeonGame.nivelActual().cuerpoSobreMeta()
}

//*========================| Protagonista |=======================
  class Protagonista{
    
    //Imagen
    var property image = "frente.png"

    //Posicion
    var property position

    method iniciar(){
      game.addVisual(self)
      cuerpo.agregarACuerpo(self)
      image = "frente_respirando.gif"
    }

    //Llave
    method llave() = juegoDungeonGame.tieneLlave() 
    
    method unDo(){
      self.aparecer()
    }

    method retroceder(){
      position = position.up(1)
    }

    //Colision
    method esPisable() = true

    //Puede avanzar
    method puedeAvanzar(posicion) = game.getObjectsIn(posicion).all({objeto => objeto.esPisable()})

    method moveTo(movimiento){
      position = movimiento.nuevaPosicion(self)
      if(movimiento == arriba) { image = "atras.png" } 
      else if(movimiento == abajo) { image = "frente_respirando.gif" }
      else if(movimiento == derecha) { image = "derecha.png" } 
      else if(movimiento == izquierda) { image = "izquierda.png" }
    }

    method collideWith(){
      game.getObjectsIn(position).forEach({objeto => objeto.interactuarConPersonaje(self)}) 
    }

    //Desaparecer  
    method desaparecer(){
      game.removeVisual(self)
      cuerpo.eliminarpersonaje(self)

      //Se agrega a movimientos para poder deshacer
      juegoDungeonGame.addMove(self)
    }

    //Aparecer 
    method aparecer(){
      game.addVisual(self)
      cuerpo.agregarACuerpo(self)
      //Deshace el movimiento anterior
      juegoDungeonGame.unDo()
    }

   method interactuarConPersonaje(pj){}
  }


  //----- HitBox 
  class HitBox{
      
    //const padre

    //Posicion
    const property position

    method iniciar(){
      game.addVisual(self)
    }

    method eliminar(){
      game.removeVisual(self)
    }

    //Colision
    method esPisable() = true

    }

  //----------------| Movimiento |----------------
  object arriba {
    method nuevaPosicion(objeto) = objeto.position().up(1)
    method unDo(){cuerpo.ejecutarMovimiento(abajo)}
  }

  object abajo {
    method nuevaPosicion(objeto) = objeto.position().down(1)
    method unDo(){cuerpo.ejecutarMovimiento(arriba)}
  }

  object izquierda {
    method nuevaPosicion(objeto) = objeto.position().left(1)
    method unDo(){cuerpo.ejecutarMovimiento(derecha)}
  }

  object derecha {
    method nuevaPosicion(objeto) = objeto.position().right(1)
    method unDo(){cuerpo.ejecutarMovimiento(izquierda)}
  }

//*==========================| Entorno |=========================
  class Meta{

    //Posicion
    const property position
    //Imagen
    method image() = "Puerta.png"

    method iniciar(){
      game.addVisual(self)
    }

    //Colision
    method esPisable() = true

    method interactuarConPersonaje(pj){
    }
  }



  class MetaValidadora inherits Meta{
    override method interactuarConPersonaje(pj){
      //Verifica si ha ganado el nivel
      const ganoNivel = cuerpo.victoriaValida()

      if (ganoNivel){

        //Sonido de Victoria
        const winSound = game.sound("Victoria.mp3")
        winSound.volume(0.1)
        winSound.play()

        juegoDungeonGame.siguienteNivel()

        }
    }
  }

    class MetaValidadora3 inherits Meta{
      
    override method interactuarConPersonaje(pj){
      //Verifica si ha ganado el nivel
      const ganoNivel = cuerpo.victoriaValida()

      if (ganoNivel){

        //Sonido de Victoria
        const winSound = game.sound("Victoria.mp3")
        winSound.volume(0.1)
        winSound.play()

        juegoDungeonGame.anteriorNivel()

      }
    }
  }

  class MetaValidadora2 inherits Meta{
    override method image() = "PuertaFinal.png"
    override method interactuarConPersonaje(pj){
      //Verifica si ha ganado el nivel
      const ganoNivel = cuerpo.victoriaValida() && pj.llave()


      if (ganoNivel){
        //Sonido de Victoria
        const winSound = game.sound("Victoria.mp3")
        winSound.volume(0.1)
        winSound.play()

        juegoDungeonGame.siguienteNivel()

      }else{
        juegoDungeonGame.unDo() // Deshace el ultimo movimiento
        const noKeySound = game.sound("PuertaCerrada.mp3")
        noKeySound.volume(0.1)
        noKeySound.play() 
      }
    }
  }



  class Pared{
   
    //Imagen
    const images = ["Ladrillo1.png","Ladrillo2.png","Ladrillo3.png","Ladrillo4.png"]
    var property image = ""

    //Posicion
    const property position

    method iniciar(){
      self.choseImage()
      game.addVisual(self)
    }

    method choseImage(){
      image = images.randomized().head()
    }

    //Colision
    method esPisable() = false

    method interactuarConPersonaje(pj){}

  }

  class Suelo{
    
    //Imagen
    const images = ["Piso1.png","Piso1.png","Piso1.png","Piso1.png","Piso1.png","Piso1.png","Piso1.png","Piso1.png", "Piso2.png", "Piso3.png"]
    var property image = ""

    //Posicion
    const property position

    method iniciar(){
      self.choseImage()
      game.addVisual(self)
    }

    method choseImage(){
      image = images.randomized().head()
    }

    //Colision
    method esPisable() = true

    method interactuarConPersonaje(pj){}

  }

  class Lampara{
    
    //Posicion
    const property position

    //Imagen
    method image() = "Lampara.png"


    method iniciar(){
      game.addVisual(self)
    } 

    //Colision
    method esPisable() = true

    method interactuarConPersonaje(pj){}
  }

  class Agujero{
    
    var estadoActual // true = abierta

    //Posicion
    const property position

    //Imagen
    const images = ["Trampa2.png","Trampa3.png","Trampa4.png","Trampa5.png"]
    var property image = ""

    method iniciar(){

      self.choseImage()
      game.addVisual(self)
    }

    method choseImage(){
      image = if(estadoActual) "Trampa1.png" else images.randomized().head()
    }

    //Colision
    method esPisable() = true

    method activar(){
      image = "Trampa1.png"
      estadoActual = true
    }

    //Este unDo es para desactivar la trampa --> En el caso de deshacer la eliminacion de un personaje se encarga el Protagonista
    method unDo(){
      estadoActual = false
      self.choseImage()

      //Se ejecuta tambien el movimiento anterior
      juegoDungeonGame.unDo()
    }

    method interactuarConPersonaje(personaje){
      
      if(estadoActual){
        personaje.desaparecer()
      } else {
        self.activar()
        //Se agrega a movimientos para poder deshacer
        juegoDungeonGame.addMove(self)
      }
    }
  }

//Rehusamos la clase de Agujero para la Llave -- Se debe modificar a futuro para evitar repetir codigo
class Llave{
    
    var estadoActual // true = abierta

    //Posicion
    const property position

    //Imagen
    var property image = ""

    method iniciar(){

      self.choseImage()
      game.addVisual(self)
    }

    method choseImage(){
      image = if(juegoDungeonGame.tieneLlave()) "Piso1.png" else "Key.png"
    }

    //Colision
    method esPisable() = true

    method activar(){
      image = "Piso1.png"
      estadoActual = true
    }

    //Este unDo es para desactivar la trampa --> En el caso de deshacer la eliminacion de un personaje se encarga el Protagonista
   method unDo(){
      estadoActual = false
      self.choseImage()

      //Se ejecuta tambien el movimiento anterior
      juegoDungeonGame.unDo()
    }

    method interactuarConPersonaje(pj){

        juegoDungeonGame.tomarLlave()
        image = "Piso1.png"
        //Se agrega a movimientos para poder deshacer
        juegoDungeonGame.addMove(self)
    }
  }
  