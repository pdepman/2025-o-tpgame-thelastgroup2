import dungeonGame.*
import menuYTeclado.*

//*==========================| Creacion de Niveles |==========================
//---------(Clase)--------
  class Nivel {

    const initialGridMap

    const property siguienteNivel
    const property anteriorNivel

    //Goal
    const goalPositions = []
    var property firstGoal = true

    //Personaje Principal
    var property mainCharacterPosition = null

    //Protagonistas
    const ProtagonistaPositions = []

    //Top Layer objects
    const lampPosition = []

    method iniciar(){
      juegoDungeonGame.clear()

      self.clearPositions()

      //Dibujo UI
      new OnlyVisual(image="Menu.png",position = game.at(0,11)).iniciar()
      new OnlyVisual(image="Undo-Reset.png",position = game.origin()).iniciar()

      administradorVidas.inicializar()

      //Dibujo el nivel
      self.drawGridMap()
      self.drawCharacters()
      self.drawTopLayer()

      // Seteo el Teclado para el nivel
      configTeclado.gameOn()

      //Seteo el nivel actual
      juegoDungeonGame.nivelActual(self)
    }

    method clearPositions(){
      firstGoal = true
      goalPositions.clear()
      ProtagonistaPositions.clear()
      lampPosition.clear()
    }

    
    method drawGridMap(){ // Se hace un recorrido del mapa por cada fila se 
      var y = 10           //añade una columna y asi se va creando el mapa 2D
      var x = 2
      initialGridMap.forEach({row =>
        row.forEach({cell => cell.decode(x, y, self)
        x+=1
      })
      y-=1
      x=2
      })
    }
 
    method addGoalPosition(x,y){
      goalPositions.add(game.at(x, y))
    }

    method cuerpoSobreMeta() =
      cuerpo.personaje() != null &&
      goalPositions.any({ goalPos => cuerpo.personaje().position() == goalPos })

    method addProtagonistaPosition(x,y){
      ProtagonistaPositions.add(game.at(x, y))
    }

    method drawCharacters(){

      //Instanciamos un Protagonista pero lo inicializamos como cuerpo 
      const personajePrincipal = new Protagonista(position = mainCharacterPosition)
      personajePrincipal.iniciar()

    }

    method addLampPosition(x,y){
      lampPosition.add(game.at(x-1, y-1))
    }

    method drawTopLayer(){
      lampPosition.forEach({pos => 
        const lampara = new Lampara(position = pos)
        lampara.iniciar()
      })
    }
  }

//------------------ Representaciones del GridMap ------------------
//---------(Entorno)--------

  //Vacio
  object v{
    method decode(_x,_y,_level){}
  }

  //Pared
  
object p{
    method decode(x,y,_level){
      const pared = new Pared(position = game.at(x, y))
      pared.iniciar()
    }
  }
  //Lamparas
  object l{
      method decode(x,y,level){
      p.decode(x, y,level)
      level.addLampPosition(x,y)
    }
  }

  //Suelo
  object _{
    method decode(x,y,_level){
      const suelo = new Suelo(position = game.at(x, y))
      suelo.iniciar()
    }
  }

  //Trampa
  object o{
    method decode(x,y,_level){
      const agujero = new Agujero(position = game.at(x, y), estadoActual = true)
      agujero.iniciar()
    }
  }

  //Trampa
  object x{
    method decode(x,y,_level){
      const agujero = new Agujero(position = game.at(x, y), estadoActual = false)
      agujero.iniciar()
    }
  }

  //Trampa
  object k{
    method decode(x,y,_level){
      const llave = new Llave(position = game.at(x, y), estadoActual = false)
      llave.iniciar()
    }
  }
  // fuego
  object f{
    method decode(x,y,_level){
      const fuego = new Fuego(position = game.at(x, y), estadoActual  = false)
      fuego.iniciar()
    }
  }

  //Puerta1
  object g{
    method decode(x,y,level){

      if(level.firstGoal()){
        //Solo la primer meta generada por el nivel sera la encargada de evaluar si el nivel fue completado
        //level.firstGoal(false)
        const metaValidadora = new MetaValidadora(position = game.at(x, y))
        metaValidadora.iniciar()

        }else{

        const meta = new Meta(position = game.at(x, y))
        meta.iniciar()
      }

      level.addGoalPosition(x,y)
    }
  }

  //Puerta2
  object a{
    method decode(x,y,level){

      if(level.firstGoal()){
        //Solo la primer meta generada por el nivel sera la encargada de evaluar si el nivel fue completado
        //level.firstGoal(false)
        const metaValidadora = new MetaValidadora3(position = game.at(x, y))
        metaValidadora.iniciar()

        }else{

        const meta = new Meta(position = game.at(x, y))
        meta.iniciar()
      }

      level.addGoalPosition(x,y)
    }
  }

  //Meta
  object s{
    method decode(x,y,level){

      if(level.firstGoal()){
        //Solo la primer meta generada por el nivel sera la encargada de evaluar si el nivel fue completado
        //level.firstGoal(false)
        const metaValidadora2 = new MetaValidadora2(position = game.at(x, y))
        metaValidadora2.iniciar()

        }else{

        const meta2 = new Meta(position = game.at(x, y))
        meta2.iniciar()
      }

      level.addGoalPosition(x,y)
    }
  }

  
  object u{
    method decode(x,y,_level){
      const arrowPopUp = new OnlyVisual(image = "ArrowsPopUp.gif",position = game.at(x+2, y-1))
      arrowPopUp.iniciar()
    }
  }

//-------(Personajes)-------

  //Personaje Principal
  object m{
    method decode(x,y,level){
      //Guardo la posicion del personaje principal
      level.mainCharacterPosition(game.at(x, y))

      //Creo suelo donde Spawnea el personaje principal
      _.decode(x, y,level)
    }
  }

  //personajes
  object z{
    method decode(x,y,level){
      //Guardo la posicion de los Protagonistas
      level.addProtagonistaPosition(x,y)

      //Creo suelo donde Spawnea el personaje principal
      _.decode(x, y,level)
    }
  }

//*==========================| Niveles Instanciados |==========================

  //Move Tutorial
  const nivel1 = new Nivel(
    initialGridMap = [
      [v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v],
      [v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v],
      [v,v,v,v,p,p,p,p,p,p,p,p,g,p,p,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v],
      [v,v,v,v,p,_,_,_,_,p,_,_,_,_,p,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v],
      [v,v,v,v,p,_,m,_,_,p,_,_,_,_,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p],
      [v,v,v,v,l,_,_,_,f,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,p,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v],
      [v,v,v,v,p,_,_,_,_,_,_,_,_,_,p,p,p,_,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p],
      [v,v,v,v,p,_,k,_,_,_,_,_,_,_,p,v,p,_,p,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v],
      [v,v,v,v,p,p,p,p,s,p,p,p,_,p,p,v,p,_,p,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v],
      [v,v,v,v,v,v,v,v,v,v,v,p,_,_,_,_,_,_,p,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v],
      [v,v,v,v,v,v,v,v,v,v,v,p,p,p,p,p,p,p,p,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v],
      [v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v],
      [v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v],
      [v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v],
      [v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v],
      [v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v],
      [v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v],
      [v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v]
    ], 
    siguienteNivel = nivel2,
    anteriorNivel = nivel1
  )

  //Friend Tutorial
  const nivel2 = new Nivel(
    initialGridMap = [
      [v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v],
      [v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v],
      [v,v,v,v,p,p,p,p,p,p,p,p,g,p,p,v,v,v,v,v],
      [v,v,v,v,p,_,_,_,_,p,_,_,_,_,p,v,v,v,v,v],
      [v,v,v,v,p,_,m,_,_,p,_,_,_,_,p,v,v,v,v,v],
      [v,v,v,v,a,_,_,_,_,_,_,_,_,_,l,v,v,v,v,v],
      [v,v,v,v,p,_,_,_,_,_,_,_,_,_,p,v,v,v,v,v],
      [v,v,v,v,p,_,_,_,_,_,_,_,_,_,p,v,v,v,v,v],
      [v,v,v,v,p,p,p,p,p,p,p,p,p,p,p,v,v,v,v,v],
      [v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v]
    ], 
    siguienteNivel = nivel3,
    anteriorNivel = nivel1
  )

  // Friends Levels
  const nivel3 = new Nivel(
    initialGridMap = [
      [v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v],
      [l,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,l,v],
      [l,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,p,v],
      [p,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,p,v],
      [p,_,m,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,p,v],
      [p,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,p,v],
      [p,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,p,v],
      [p,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,p,v],
      [l,p,p,p,p,a,p,p,p,p,p,p,p,p,p,p,p,p,l,v],
      [v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v]
    ], 
    siguienteNivel = nivel4,
    anteriorNivel = nivel2
  )

  const nivel4 = new Nivel(
   initialGridMap = [
      [v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v],
      [v,v,v,p,p,p,p,p,p,p,p,p,p,p,p,p,p,v,v,v],
      [v,p,p,p,_,_,_,_,_,_,_,_,_,_,_,_,p,p,p,v],
      [v,p,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,p,v],
      [v,a,_,_,_,_,_,_,_,p,_,_,_,_,_,_,_,_,p,v],
      [v,l,_,_,g,_,m,_,_,p,p,p,_,_,_,_,_,_,l,v],
      [v,p,_,_,_,_,_,_,_,_,p,p,_,_,_,_,_,_,p,v],
      [v,p,_,_,_,_,_,_,_,_,_,p,_,_,_,_,_,_,p,v],
      [v,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,v],
      [v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v]
    ],
    siguienteNivel = nivel5,
    anteriorNivel = nivel3
  )

  const nivel5 = new Nivel(
   initialGridMap = [
      [v,v,v,v,v,v,v,p,p,p,l,p,p,p,v,v,v,v,v,v],
      [v,v,v,v,p,p,p,p,_,_,_,_,_,p,p,p,p,v,v,v],
      [v,v,p,p,p,_,_,_,_,_,_,_,_,_,_,_,p,p,p,v],
      [v,v,p,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,p,v],
      [v,v,p,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,p,v],
      [v,v,l,_,_,m,_,_,_,p,p,p,p,_,_,_,_,_,l,v],
      [v,v,p,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,p,v],
      [v,v,p,_,_,_,_,_,_,_,_,g,_,_,_,_,_,_,p,v],
      [v,v,p,p,p,p,a,p,p,p,p,p,p,p,p,p,p,p,p,v],
      [v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v]
    ],
    siguienteNivel = nivel6,
    anteriorNivel = nivel4
  )

  // Holes Levels
  const nivel6 = new Nivel(
   initialGridMap = [
      [v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v],
      [v,v,v,v,p,p,p,p,p,p,p,p,p,p,p,p,p,v,v,v],
      [v,v,v,p,p,_,_,_,_,_,_,_,_,_,_,_,p,p,v,v],
      [v,v,v,p,_,_,_,_,_,_,_,_,_,_,_,_,_,p,v,v],
      [v,v,v,p,_,m,_,_,_,_,o,_,_,_,_,_,_,p,v,v],
      [v,v,v,p,_,_,_,_,_,_,_,_,_,_,_,_,_,p,v,v],
      [v,v,v,p,_,_,_,_,_,g,p,_,_,_,_,_,_,p,v,v],
      [v,v,v,p,p,_,_,_,_,_,p,_,_,_,_,_,p,p,v,v],
      [v,v,v,v,p,p,p,a,p,p,p,p,p,p,p,p,p,v,v,v],
      [v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v]
    ],
    siguienteNivel = nivel7,
    anteriorNivel = nivel5
  )

  const nivel7 = new Nivel(
   initialGridMap = [
      [v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v],
      [v,v,v,p,p,p,p,p,p,p,p,p,p,p,p,p,p,v,v,v],
      [v,v,v,p,_,_,_,_,_,p,p,_,_,_,_,_,p,v,v,v],
      [v,v,v,p,_,_,_,_,_,x,x,_,_,_,_,_,p,v,v,v],
      [v,v,v,p,_,_,_,x,_,_,_,_,x,_,_,_,p,v,v,v],
      [v,v,v,p,_,_,_,x,_,_,g,_,x,_,_,_,p,v,v,v],
      [v,v,v,a,_,m,_,_,_,x,x,_,_,_,_,_,p,v,v,v],
      [v,v,v,p,_,_,_,_,_,p,p,_,_,_,_,_,p,v,v,v],
      [v,v,v,p,p,p,p,p,p,p,p,p,p,p,p,p,p,v,v,v],
      [v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v]
    ],
    siguienteNivel = nivel8,
    anteriorNivel = nivel6
  )

  const nivel8 = new Nivel(
   initialGridMap = [
      [v,v,v,v,p,p,p,p,p,p,p,p,p,p,p,p,v,v,v,v],
      [v,v,v,p,p,_,_,_,_,_,_,_,_,_,_,p,p,v,v,v],
      [v,v,v,p,_,_,_,_,_,_,_,_,_,_,_,_,p,v,v,v],
      [v,v,v,p,_,_,_,_,x,_,x,_,_,_,_,_,p,v,v,v],
      [v,v,v,p,_,_,_,_,_,x,_,_,_,_,_,_,p,v,v,v],
      [v,v,v,a,_,_,_,_,x,_,x,_,_,_,_,_,p,v,v,v],
      [v,v,v,p,_,_,_,_,_,m,_,_,_,_,_,_,p,v,v,v],
      [v,v,v,p,_,_,_,_,_,_,_,_,_,_,p,_,p,v,v,v],
      [v,v,v,p,p,_,_,_,_,_,_,_,_,_,p,g,p,v,v,v],
      [v,v,v,v,p,p,p,p,p,p,p,p,p,p,p,p,p,v,v,v]
    ],
    siguienteNivel = nivel9,
    anteriorNivel = nivel7
  )

  const nivel9 = new Nivel(
    initialGridMap = [
      [p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p],
      [p,_,_,l,_,_,p,p,_,p,_,p,p,_,s,l,_,_,_,p],
      [p,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,p],
      [p,_,_,_,_,_,o,o,_,_,_,_,_,o,_,_,_,_,_,p],
      [p,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,p],
      [p,_,_,_,_,_,_,_,o,_,_,_,_,_,_,_,_,_,_,p],
      [p,_,o,_,_,_,_,_,_,_,_,_,_,_,_,o,_,_,_,p],
      [p,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,p],
      [p,_,_,_,_,_,_,_,_,m,_,_,_,_,_,_,_,_,_,p],
      [p,p,p,p,a,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p]
      ], 
    siguienteNivel = endCredits,
    anteriorNivel = nivel8
  )
  object endCredits {
    method iniciar(){
      juegoDungeonGame.clear()
      configTeclado.gameOn()
      new OnlyVisual(image="End.png",position = game.at(8,1)).iniciar()
    }
  }



