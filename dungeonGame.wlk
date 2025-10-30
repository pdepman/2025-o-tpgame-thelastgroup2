import levels.*
import menuYTeclado.*

object juegoDungeonGame {
  var tieneLlave = false

  var property nivelActual = nivel3
  var movimientos = []
  // nivel por defecto post game over"
  const nivelPorDefecto = nivel3
  //Config Audio
  const music = game.sound("BasicMusic.mp3")

  method iniciar(){

    //Set game properties
    game.title("Dungeon Game")
	  game.height(12)
	  game.width(24)
    game.boardGround("Fondo2.png")

    //Set Background Audio
    if(!tieneLlave){
      music.shouldLoop(true)
      music.volume(0.1)
      music.play()
    } else {
      music.stop()
    }

    

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

  // Navegación matricial 4D
  method irAlNorte(){
    if(nivelActual.nivelNorte() != null){
      nivelActual = nivelActual.nivelNorte()
      nivelActual.iniciar()
    }
  }
  method irAlSur(){
    if(nivelActual.nivelSur() != null){
      nivelActual = nivelActual.nivelSur()
      nivelActual.iniciar()
    }
  }
  method irAlEste(){
    if(nivelActual.nivelEste() != null){
      nivelActual = nivelActual.nivelEste()
      nivelActual.iniciar()
    }
  }
  method irAlOeste(){
    if(nivelActual.nivelOeste() != null){
      nivelActual = nivelActual.nivelOeste()
      nivelActual.iniciar()
    }
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

method reiniciarNivel(){
  tieneLlave = false
  movimientos.clear()
  self.clear()
  administradorVidas.reiniciar()
  nivelActual = nivelPorDefecto
  nivelActual.iniciar()
}
method volverAlMenuPrincipal(){
  tieneLlave = false
  movimientos.clear()
  self.clear()
  administradorVidas.reiniciar()
  nivelActual = nivelPorDefecto
  menu.iniciar()
  
}
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
     
     // Victoria direccional para sistema matricial
     method victoriaValidaNorte() = juegoDungeonGame.nivelActual().cuerpoSobreMetaNorte()
     method victoriaValidaSur() = juegoDungeonGame.nivelActual().cuerpoSobreMetaSur()
     method victoriaValidaEste() = juegoDungeonGame.nivelActual().cuerpoSobreMetaEste()
     method victoriaValidaOeste() = juegoDungeonGame.nivelActual().cuerpoSobreMetaOeste()
}

//*========================| Protagonista |=======================
  object configuracionVida{
    const property vidaMaxima =5
  }
  class Protagonista{
    
    //Imagen
    var property image = "frente.png"
    //vida
    var vidas = configuracionVida.vidaMaxima()
    //Posicion
    var property position
    var inmunidadActivada = false
    var derrotado = false


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

  
    
    method perderVida (){
      if(self.puedePerderVida()){
        vidas = (vidas -1).max(0)
        

        if(self.estaMuerto()){
          self.morir()
        }else{
          self.activarInmunidad() // temporalmente activa
        }
        administradorVidas.vidaCambio(vidas)
      }
      
     
    }
     method puedePerderVida() = !inmunidadActivada && !derrotado
    method estaMuerto() = vidas <= 0
    method vidas() = vidas  
    
    method reiniciarVida() {
        vidas = configuracionVida.vidaMaxima()
        derrotado = false
        inmunidadActivada = false
        
        administradorVidas.vidaCambio(vidas)
    }
    method vidaInicial() = configuracionVida.vidaMaxima()
    method activarInmunidad() {
      inmunidadActivada = true
      game.schedule(2000, {inmunidadActivada = false})
    }

    method morir(){
      derrotado = true
      self.desaparecer()
      game.schedule(1000, { pantallaGameOver.mostrar()})
    }

    method reiniciarCompleto() {
        vidas = configuracionVida.vidaMaxima()
        derrotado = false
        inmunidadActivada = false
        administradorVidas.vidaCambio(vidas)
        // El personaje se creará nuevo en el nivel
    }
    

    

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
  class VidaPersonaje{
      var property image = "vidaDoradaLlena.png"
      var property position 
      const id 

      method iniciar(){
        game.addVisual(self)
      }

      method position() = position
      method id() = id

    // metodos a los que accede el adm de vidas

      method mostrarLlena() {
        image = "vidaDoradaLlena.png"
    }
    
    method mostrarVacia() {
        image = "vidaDoradaVacia.png"
    }

      method esPisable() = true
      method interactuarConPersonaje(pj){}


    }
    object  administradorVidas {
      
      const vida1 = new VidaPersonaje (position = game.at(14, 11), id=1)
      const vida2 = new VidaPersonaje (position = game.at(16, 11), id=2)
      const vida3 = new VidaPersonaje (position = game.at(18, 11), id=3)
      const vida4 = new VidaPersonaje (position = game.at(20, 11), id=4)
      const vida5 = new VidaPersonaje (position = game.at(22, 11), id=5)

      const vidas = [vida1, vida2, vida3, vida4, vida5]

      method inicializar(){
        vidas.forEach({vida => vida.iniciar()})
      }
      method vidaCambio(vidasRestantes) {
        vidas.forEach({ vida => 
            if (vida.id() <= vidasRestantes) {
                vida.mostrarLlena()
            } else {
                vida.mostrarVacia()
            }
        })
    }
    
    method reiniciar() {
        self.vidaCambio(configuracionVida.vidaMaxima())
    }

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

//*======================| PUERTA DIRECCIONAL SIMPLE |======================

class PuertaDireccional inherits Meta {
  const direccion
  const esValidadora = false  // Indica si es la primera puerta validadora del nivel
  
  override method interactuarConPersonaje(pj){
    // Solo procesa si es una puerta validadora O si no hay puertas validadoras
    if (esValidadora) {
      // Verifica si ha ganado el nivel según la dirección
      const ganoNivel = self.validarVictoria()
      
      if (ganoNivel){
        // Sonido de Victoria
        const winSound = game.sound("Victoria.mp3")
        winSound.volume(0.1)
        winSound.play()
        
        // Navega según la dirección
        self.navegar()
      }
    }
  }
  
  method validarVictoria() = 
    if (direccion == "norte") cuerpo.victoriaValidaNorte()
    else if (direccion == "sur") cuerpo.victoriaValidaSur()
    else if (direccion == "este") cuerpo.victoriaValidaEste()
    else if (direccion == "oeste") cuerpo.victoriaValidaOeste()
    else false
  
  method navegar() {
    if (direccion == "norte") juegoDungeonGame.irAlNorte()
    else if (direccion == "sur") juegoDungeonGame.irAlSur()
    else if (direccion == "este") juegoDungeonGame.irAlEste()
    else if (direccion == "oeste") juegoDungeonGame.irAlOeste()
  }
}

object pantallaGameOver{
  var property mostrada = false

  method mostrar(){
    if(!mostrada){
      game.addVisual(cartelGameOver)
      configTeclado.gameOverOn()
      mostrada = true
    }
  }
  method ocultar(){
    if (mostrada){
      game.removeVisual(cartelGameOver)
      mostrada = false
    }
  }
  method reiniciarJuego() {
        self.ocultar()
        juegoDungeonGame.reiniciarNivel()
    }
    
    method volverAlMenu() {
        self.ocultar()
        juegoDungeonGame.volverAlMenuPrincipal()
    }

}
  
  object cartelGameOver{
    method position () = game.at(0.25,-1)
    method image() = "GAMEOVER.png"
    method esPisable () = true
    method interactuarConPersonaje(pj) {}
  }

//*======================| CLASE BASE |======================

class ElementoDeEscenario {
  var property image = ""
  const property position

  method iniciar() {
    self.elegirImagen()
    game.addVisual(self)
  }

  // Para redefinir en subclases si tienen varias opciones de imagen
  method elegirImagen() {}

  method esPisable() = true
  method interactuarConPersonaje(pj) {}
}


//*======================| ESCENARIO |======================

class Suelo inherits ElementoDeEscenario {
  override method elegirImagen() {
    image = ["Piso1.png", "Piso2.png", "Piso3.png"].randomized().head()
  }
}

class Pared inherits ElementoDeEscenario {
  override method elegirImagen() { 
   image = ["Ladrillo1.png","Ladrillo2.png","Ladrillo3.png","Ladrillo4.png"].randomized().head() 
   }
  override method esPisable() = false
}

class Lampara inherits ElementoDeEscenario {
  override method elegirImagen() { 
  image = "Lampara.png" 
  }
  override method esPisable() = false
}


//*======================| OBSTÁCULOS |======================

 
class Obstaculo inherits ElementoDeEscenario {
  var property estadoActual = false
  var estadoActivo = false

  method inicializar() {
    estadoActivo = estadoActual
    self.iniciar()
  }

  override method interactuarConPersonaje(pj) {}
}


//---- Agujero ----
class Agujero inherits Obstaculo {

  const images = ["Trampa2.png", "Trampa3.png", "Trampa4.png", "Trampa5.png"]

  override method elegirImagen() {
    image = if (estadoActivo) "Trampa1.png" else images.randomized().head()
  }

  override method esPisable() = true

  method activar() {
    image = "Trampa1.png"
    estadoActivo = true
  }

  method unDo() {
    estadoActivo = false
    self.elegirImagen()
    juegoDungeonGame.unDo()
  }

  override method interactuarConPersonaje(personaje) {
    if (estadoActivo) {
      personaje.desaparecer()
    } else {
      self.activar()
      juegoDungeonGame.addMove(self)
    }
  }
}


//---- Fuego ----
class Fuego inherits Obstaculo {

  override method elegirImagen() { image = "fuego.png" }

  override method esPisable() = true

  override method interactuarConPersonaje(pj) {
    pj.perderVida()
  }
}


//=======================| HERRAMIENTAS |=======================

class Herramienta inherits ElementoDeEscenario {
  var property estadoActual = false
  var estadoActivo = false

  method inicializar() {
    estadoActivo = estadoActual
    self.iniciar()
  }

  override method esPisable() = true

  method activar() {
    estadoActivo = true
    image = "Piso1.png"
  }

  method unDo() {
    estadoActivo = false
    self.elegirImagen()
    juegoDungeonGame.unDo()
  }
}


//---- Llave ----
class Llave inherits Herramienta {

  override method elegirImagen() {
    image = if (juegoDungeonGame.tieneLlave()) "Piso1.png" else "Key.png"
  }

  override method interactuarConPersonaje(pj) {
    juegoDungeonGame.tomarLlave()
    image = "Piso1.png"
    juegoDungeonGame.addMove(self)
  }
}

//---- MataFuego ----
class MataFuego inherits Herramienta {

  override method elegirImagen() { image = "Matafuego.png" }

  override method interactuarConPersonaje(pj) {
    // ejemplo: desactiva fuegos cercanos
    const apagarSound = game.sound("apagar.mp3")
    apagarSound.volume(0.1)
    apagarSound.play()
  }
}