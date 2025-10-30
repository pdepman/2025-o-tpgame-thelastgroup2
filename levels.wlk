import dungeonGame.*
import menuYTeclado.*

//*==========================| Creacion de Niveles |==========================
//---------(Clase)--------
class Nivel {
  const initialGridMap
  
  const property nivelNorte = null    // ↑
  const property nivelSur = null      // ↓
  const property nivelEste = null     // →
  const property nivelOeste = null    // ←
  
   // Coordenadas en la matriz 
  const property fila = 0
  const property columna = 0
  
  // Goals por dirección
  const goalPositionsNorte = []
  const goalPositionsSur = []
  const goalPositionsEste = []
  const goalPositionsOeste = []
  
  
  //Goal
 
  var property firstGoal = true //Personaje Principal
  var property mainCharacterPosition = null //Protagonistas
  const protagonistaPositions = []
  //Top Layer objects
  const lampPosition = []
  
  method iniciar() {
    juegoDungeonGame.clear()
    
    self.clearPositions()
    
    //Dibujo UI
    new OnlyVisual(image = "Menu.png", position = game.at(0, 11)).iniciar()
    new OnlyVisual(image = "Undo-Reset.png", position = game.origin()).iniciar()
    
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
  
  method clearPositions() {
    firstGoal = true
    goalPositionsNorte.clear()
    goalPositionsSur.clear()
    goalPositionsEste.clear()
    goalPositionsOeste.clear()
    protagonistaPositions.clear()
    lampPosition.clear()
  }
  
  method drawGridMap() {
    // Se hace un recorrido del mapa por cada fila se 
    var y = 10 //añade una columna y asi se va creando el mapa 2D
    var x = 2
    initialGridMap.forEach(
      { row =>
        row.forEach({ cell =>  cell.decode(x, y, self); x += 1})
        y -= 1
        x = 2
      }
    )
  }
  
  // Métodos para agregar goals por dirección
  method addGoalPositionNorte(x, y) {
    goalPositionsNorte.add(game.at(x, y))
  }
  
  method addGoalPositionSur(x, y) {
    goalPositionsSur.add(game.at(x, y))
  }
  
  method addGoalPositionEste(x, y) {
    goalPositionsEste.add(game.at(x, y))
  }
  
  method addGoalPositionOeste(x, y) {
    goalPositionsOeste.add(game.at(x, y))
  }
  
  // Métodos de victoria direccionales
  method cuerpoSobreMetaNorte() = (cuerpo.personaje() != null) && goalPositionsNorte.any(
    { goalPos => cuerpo.personaje().position() == goalPos }
  )
  
  method cuerpoSobreMetaSur() = (cuerpo.personaje() != null) && goalPositionsSur.any(
    { goalPos => cuerpo.personaje().position() == goalPos }
  )
  
  method cuerpoSobreMetaEste() = (cuerpo.personaje() != null) && goalPositionsEste.any(
    { goalPos => cuerpo.personaje().position() == goalPos }
  )
  
  method cuerpoSobreMetaOeste() = (cuerpo.personaje() != null) && goalPositionsOeste.any(
    { goalPos => cuerpo.personaje().position() == goalPos }
  )
  
  // Método original para compatibilidad (revisa todas las direcciones)
  method cuerpoSobreMeta() = (cuerpo.personaje() != null) && (
    goalPositionsNorte.any({ goalPos => cuerpo.personaje().position() == goalPos }) ||
    goalPositionsSur.any({ goalPos => cuerpo.personaje().position() == goalPos }) ||
    goalPositionsEste.any({ goalPos => cuerpo.personaje().position() == goalPos }) ||
    goalPositionsOeste.any({ goalPos => cuerpo.personaje().position() == goalPos })
  )
  
  method addProtagonistaPosition(x, y) {
    protagonistaPositions.add(game.at(x, y))
  }
  
  method drawCharacters() {
    //Instanciamos un Protagonista pero lo inicializamos como cuerpo 
    const personajePrincipal = new Protagonista(
      position = mainCharacterPosition
    )
    personajePrincipal.iniciar()
  }
  
  method addLampPosition(x, y) {
    lampPosition.add(game.at(x - 1, y - 1))
  }
  
  method drawTopLayer() {
    lampPosition.forEach(
      { pos =>
        const lampara = new Lampara(position = pos)
        return lampara.iniciar()
      }
    )
  }
} //------------------ Representaciones del GridMap ------------------

//---------(Entorno)--------
//Vacio
object v {
  method decode(_x, _y, _level) {
    
  }
} //Pared

object p {
  method decode(x, y, _level) {
    const pared = new Pared(position = game.at(x, y))
    pared.iniciar()
  }
} //Lamparas

object l {
  method decode(x, y, level) {
    p.decode(x, y, level)
    level.addLampPosition(x, y)
  }
} //Suelo

object _ {
  method decode(x, y, _level) {
    const suelo = new Suelo(position = game.at(x, y))
    suelo.iniciar()
  }
} //Trampa

object o {
  method decode(x, y, _level) {
    const agujero = new Agujero(position = game.at(x, y), estadoActual = true)
    agujero.inicializar()
  }
} //Trampa

object x {
  method decode(x, y, _level) {
    const agujero = new Agujero(position = game.at(x, y), estadoActual = false)
    agujero.inicializar()
  }
} //LLave

object k {
  method decode(x, y, _level) {
    const llave = new Llave(position = game.at(x, y), estadoActual = false)
    llave.inicializar()
  }
} // fuego

object f {
  method decode(x, y, _level) {
    const fuego = new Fuego(position = game.at(x, y), estadoActual = false)
    fuego.inicializar()
  }
} // NOTA: Los antiguos objetos g, a, s han sido reemplazados por el sistema direccional n, s, e, o
// Esto elimina redundancia y mantiene un sistema único y expresivo

object u {
  method decode(x, y, _level) {
    const arrowPopUp = new OnlyVisual(
      image = "ArrowsPopUp.gif",
      position = game.at(x + 2, y - 1)
    )
    arrowPopUp.iniciar()
  }
} //-------(Personajes)-------

//Personaje Principal
object m {
  method decode(x, y, level) {
    //Guardo la posicion del personaje principal
    level.mainCharacterPosition(game.at(x, y))
    
    //Creo suelo donde Spawnea el personaje principal
    _.decode(x, y, level)
  }
} //personajes

object z {
  method decode(x, y, level) {
    //Guardo la posicion de los Protagonistas
    level.addProtagonistaPosition(x, y)
    
    //Creo suelo donde Spawnea el personaje principal
    _.decode(x, y, level)
  }
}

//*==========================| DECODE OBJECTS DIRECCIONALES |==========================

// SISTEMA ÚNICO Y EXPRESIVO  
// n = Norte ↑, s = Sur ↓, e = Este →, o = Oeste ←

object n {
  method decode(x, y, level) {
    const puertaNorte = new PuertaDireccional(
      position = game.at(x, y), 
      direccion = "norte",
      esValidadora = level.firstGoal()
    )
    puertaNorte.iniciar()
    level.addGoalPositionNorte(x, y)
  }
}

object s {
  method decode(x, y, level) {
    const puertaSur = new PuertaDireccional(
      position = game.at(x, y), 
      direccion = "sur",
      esValidadora = level.firstGoal()
    ) 
    puertaSur.iniciar()
    level.addGoalPositionSur(x, y)
  }
}

object e {
  method decode(x, y, level) {
    const puertaEste = new PuertaDireccional(
      position = game.at(x, y), 
      direccion = "este",
      esValidadora = level.firstGoal()
    )
    puertaEste.iniciar()
    level.addGoalPositionEste(x, y)
  }
}

object w {
  method decode(x, y, level) {
    const puertaOeste = new PuertaDireccional(
      position = game.at(x, y), 
      direccion = "oeste",
      esValidadora = level.firstGoal()
    )
    puertaOeste.iniciar()  
    level.addGoalPositionOeste(x, y)
  }
}

//*==========================| Niveles Instanciados |==========================

//Move Tutorial
const nivel1 = new Nivel(
  initialGridMap = [
      [v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v],
      [v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v],
      [v,v,v,v,p,p,p,p,p,p,p,n,p,p,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v],
      [v,v,v,v,p,_,_,_,_,p,_,_,_,_,p,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v],
      [v,v,v,v,p,_,m,_,_,p,_,_,_,_,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p],
      [v,v,v,v,l,_,_,_,f,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,p,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v],
      [v,v,v,v,w,_,_,_,_,_,_,_,_,_,p,p,p,_,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,_,p,p],
      [v,v,v,v,p,_,_,_,_,_,_,_,_,_,p,v,p,_,e,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v],
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
  fila = -1, columna = 1,
  nivelNorte = nivel2,
  nivelEste = nivel4,
  nivelOeste = nivel5,
  nivelSur = nivel15
)

//Friend Tutorial
const nivel2 = new Nivel(
  initialGridMap = [
    [v, v, v, v, v, v, v, v, v, v, v, v, v, v, v, v, v, v, v, v],
    [v, v, v, v, v, v, v, v, v, v, v, v, v, v, v, v, v, v, v, v],
    [v, v, v, v, p, p, p, p, p, p, p, p, n, p, p, v, v, v, v, v],
    [v, v, v, v, p, _, _, _, _, p, _, _, _, _, p, v, v, v, v, v],
    [v, v, v, v, p, _, m, _, _, p, _, _, _, _, p, v, v, v, v, v],
    [v, v, v, v, w, _, _, _, _, _, _, _, _, _, l, v, v, v, v, v],
    [v, v, v, v, p, _, _, _, _, _, _, _, _, _, e, v, v, v, v, v],
    [v, v, v, v, p, _, _, _, _, _, _, _, _, _, p, v, v, v, v, v],
    [v, v, v, v, p, p, p, p, s, p, p, p, p, p, p, v, v, v, v, v],
    [v, v, v, v, v, v, v, v, v, v, v, v, v, v, v, v, v, v, v, v]
  ],
  fila = 0, columna = 1,
  nivelSur = nivel1,
  nivelEste = nivel3,
  nivelOeste = nivel6,
  nivelNorte = nivel8
)

// Friends Levels
const nivel3 = new Nivel(
  initialGridMap = [
    [v, v, v, v, v, v, v, v, v, v, v, v, v, v, v, v, v, v, v, v],
    [l, p, p, p, p, p, p, p, p, p, p, p, p, n, p, p, p, p, l, v],
    [l, _, _, _, _, _, _, _, _, _, f, _, _, _, _, _, _, _, p, v],
    [p, _, _, _, _, _, _, _, _, _, f, _, f, _, _, _, _, _, p, v],
    [w, _, m, _, _, _, _, _, _, _, f, _, f, _, _, _, _, _, p, v],
    [p, _, _, _, _, _, _, _, _, _, _, _, f, _, _, _, _, _, p, v],
    [p, _, _, _, _, _, _, _, _, _, f, _, f, _, _, _, _, _, e, v],
    [p, _, _, _, _, _, _, _, _, _, f, _, f, _, _, _, _, _, p, v],
    [l, p, p, p, p, p, p, p, p, p, p, s, p, p, p, p, p, p, l, v],
    [v, v, v, v, v, v, v, v, v, v, v, v, v, v, v, v, v, v, v, v]
  ],
  fila = 0, columna = 2,
  nivelOeste = nivel2,
  nivelSur = nivel4,
  nivelEste = nivel11,
  nivelNorte = nivel9
)

const nivel4 = new Nivel(
  initialGridMap = [
    [v, v, v, v, v, v, v, v, v, v, v, v, v, v, v, v, v, v, v, v],
    [v, v, v, p, p, p, p, p, p, p, p, p, p, n, p, p, p, v, v, v],
    [v, p, p, p, _, _, _, _, _, _, _, _, _, _, _, _, p, p, p, v],
    [v, p, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, p, v],
    [v, w, _, _, _, _, _, _, _, p, _, _, _, _, _, _, _, _, e, v],
    [v, l, _, _, _, _, m, _, _, p, p, p, _, _, _, _, _, _, l, v],
    [v, p, _, _, _, _, _, _, _, _, p, p, _, _, _, _, _, _, p, v],
    [v, p, _, _, _, _, _, _, _, _, _, p, _, _, _, _, _, _, p, v],
    [v, p, p, p, p, p, p, p, p, p, p, p, p, p, p, s, p, p, p, v],
    [v, v, v, v, v, v, v, v, v, v, v, v, v, v, v, v, v, v, v, v]
  ],
  fila = -1, columna = 2,
  nivelOeste = nivel1,
  nivelNorte = nivel3,
  nivelSur = nivel14,
  nivelEste = nivel12
)

const nivel5 = new Nivel(
  initialGridMap = [
    [v, v, v, v, v, v, v, p, p, p, l, s, p, p, v, v, v, v, v, v],
    [v, v, v, v, p, p, p, p, _, _, _, _, _, p, p, p, p, v, v, v],
    [v, v, p, p, p, _, _, _, _, _, _, _, _, _, _, _, e, p, p, v],
    [v, v, p, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, p, v],
    [v, v, p, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, p, v],
    [v, v, l, _, _, m, _, _, _, p, p, p, p, _, _, _, _, _, l, v],
    [v, v, p, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, p, v],
    [v, v, p, _, _, _, _, _, _, _, _, n,_, _, _, _, _, _, p, v],
    [v, v, p, p, p, p, w, p, p, p, p, p, p, p, p, p, p, p, p, v],
    [v, v, v, v, v, v, v, v, v, v, v, v, v, v, v, v, v, v, v, v]
  ],
  fila = -1, columna = 0,
  nivelNorte = nivel6,
  nivelSur = nivel6,
  nivelEste = nivel1
)

// Holes Levels
const nivel6 = new Nivel(
  initialGridMap = [
    [v, v, v, v, v, v, v, v, v, v, v, v, v, v, v, v, v, v, v, v],
    [v, v, v, v, p, p, p, p, p, p, p, p, p, p, p, p, p, v, v, v],
    [v, v, v, p, p, _, _, _, _, _, _, _, _, _, _, _, n, p, v, v],
    [v, v, v, p, _, _, _, _, _, _, _, _, _, f, f, f, _, p, v, v],
    [v, v, v, p, _, m, _, _, _, _, o, _, _, f, _, _, _, p, v, v],
    [v, v, v, p, _, _, _, _, _, _, _, _, _, f, f, f, _, p, v, v],
    [v, v, v, p, _, _, _, _, _, _, p, _, _, f, s, f, _, e, v, v],
    [v, v, v, p, p, _, _, _, _, _, p, _, _, f, f, f, p, p, v, v],
    [v, v, v, v, p, p, p, p, p, p, p, p, p, n, p, p, p, v, v, v],
    [v, v, v, v, v, v, v, v, v, v, v, v, v, v, v, v, v, v, v, v]
  ],
  fila = 0, columna = 0,
  nivelEste = nivel2,
  nivelNorte = nivel7,
  nivelSur = nivel5
)

const nivel7 = new Nivel(
  initialGridMap = [
    [v, v, v, v, v, v, v, v, v, v, v, v, v, v, v, v, v, v, v, v],
    [v, v, v, p, p, p, p, p, p, p, p, p, p, s, p, p, p, v, v, v],
    [v, v, v, p, _, _, _, _, _, p, p, _, _, _, _, _, p, v, v, v],
    [v, v, v, p, _, _, _, _, _, x, x, _, _, _, _, _, p, v, v, v],
    [v, v, v, p, _, _, _, x, _, _, _, _, x, _, _, _, p, v, v, v],
    [v, v, v, p, _, _, _, x, _, _, _, _, x, _, _, _, p, v, v, v],
    [v, v, v, e, _, m, _, _, _, x, x, _, _, _, _, _, p, v, v, v],
    [v, v, v, p, _, _, _, _, _, p, p, _, _, _, _, _, p, v, v, v],
    [v, v, v, p, p, p, p, p, p, p, p, p, p, p, p, p, p, v, v, v],
    [v, v, v, v, v, v, v, v, v, v, v, v, v, v, v, v, v, v, v, v]
  ],
  fila = 1, columna = 0,
  nivelSur = nivel6,
  nivelEste = nivel8
)

const nivel8 = new Nivel(
  initialGridMap = [
    [v, v, v, v, p, p, p, p, p, e, p, p, p, p, p, p, v, v, v, v],
    [v, v, v, p, p, _, _, _, _, f, _, _, _, _, _, p, p, v, v, v],
    [v, v, v, p, _, _, _, _, _, _, _, _, _, _, _, _, p, v, v, v],
    [v, v, v, p, _, _, _, _, x, _, f, _, _, _, _, _, p, v, v, v],
    [v, v, v, p, _, _, _, _, _, _, _, _, _, _, _, _, p, v, v, v],
    [v, v, v, w, _, _, _, _, f, _, x, _, _, _, _, f, p, v, v, v],
    [v, v, v, p, _, _, _, _, _, m, _, _, _, _, _, _, p, v, v, v],
    [v, v, v, p, _, _, _, _, _, _, _, _, _, f, p, s, p, v, v, v],
    [v, v, v, p, p, _, _, _, _, _, _, _, _, _, p, p, p, v, v, v],
    [v, v, v, v, p, p, p, p, p, p, p, p, p, p, p, p, p, v, v, v]
  ],
  fila = 1, columna = 1,
  nivelOeste = nivel7,
  nivelEste = nivel9,
  nivelSur = nivel2
)

const nivel9 = new Nivel(
  initialGridMap = [
    [p, p, p, p, p, p, p, p, p, p, p, p, p, p, s, p, p, p, p, p],
    [p, _, _, l, _, _, p, p, _, p, _, _, _, _, _, _, _, _, _, p],
    [p, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, p],
    [p, _, _, _, _, _, o, o, _, _, _, _, _, _, _, _, _, _, _, p],
    [p, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, p],
    [p, _, _, _, _, _, _, _, o, _, _, _, _, _, _, _, _, _, _, p],
    [p, _, o, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, p],
    [p, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, p],
    [p, _, _, _, _, _, _, _, _, m, _, _, _, _, _, _, _, _, _, p],
    [p, p, p, p, w, p, p, p, p, p, p, p, p, p, p, p, e, p, p, p]
  ],
  fila = 1, columna = 2,
  nivelOeste = nivel8,
  nivelEste = nivel10,
  nivelSur = nivel3
)
const nivel10 = new Nivel(
  initialGridMap = [
    [p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p],
    [p, _, _, l, _, _, p, p, _, p, _, p, p, _, _, l, _, _, _, p],
    [p, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, p],
    [p, _, _, _, _, _, o, o, _, _, _, _, _, o, _, _, _, _, _, p],
    [p, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, p],
    [p, _, _, _, _, _, _, _, o, _, _, _, _, _, _, _, _, _, _, p],
    [p, _, o, _, _, _, _, _, _, _, _, _, _, _, _, o, _, _, _, p],
    [p, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, f, p],
    [p, _, _, _, _, _, _, _, _, m, _, _, _, _, _, _, _,_, _ ,p],
    [p, p, p, p, w, p, p, p, p, p, p, p, p, p, p, p, p, p, s, p]
  ],
  fila = 1, columna = 3,
  nivelSur = nivel11,
  nivelOeste = nivel9
)
const nivel11 = new Nivel(
  initialGridMap = [
    [p, p, p, p, p, p, p, p, p, p, p, p, p, p, n, p, p, p, p, p],
    [p, _, _, l, _, _, p, p, _, p, _, p, p, _, _, l, _, _, _, p],
    [p, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, p],
    [p, _, _, f, _, _, o, f, _, _, _, _, _, o, _, _, _, _, _, p],
    [p, _, _, f, _, _, _, f, _, _, _, _, _, _, _, _, _, _, _, p],
    [p, _, _, f, _, _, _, f, o, _, _, _, _, _, _, _, _, _, _, p],
    [p, _, f, f, f, _, f, f, f, _, _, _, _, _, _, o, _, _, _, p],
    [p, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, p],
    [p, _, _, _, _, _, _, _, _, m, _, _, _, _, _, _, _, _, _, p],
    [p, p, p, p, w, p, p, p, p, p, p, p, p, p, p, s, p, p, p, p]
  ],
  fila = 0, columna = 3,
  nivelOeste = nivel3,
  nivelNorte = nivel10,
  nivelSur = nivel12
)
const nivel12 = new Nivel(
  initialGridMap = [
    [p, p, p, p, p, p, p, p, n, p, p, p, p, p, p, p, p, p, p, p],
    [p, _, _, l, _, _, p, p, _, p, _, p, p, _, s, l, _, _, _, p],
    [p, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, p],
    [p, _, _, f, _, _, f, o, _, _, _, _, _, o, _, _, _, _, _, p],
    [p, _, f, f, _, f, f, _, _, _, _, _, _, _, _, _, _, _, _, p],
    [p, f, _, f, f, _, f, _, o, _, _, _, _, _, _, _, _, _, _, p],
    [p, _, o, f, _, f, f, _, _, _, _, _, _, _, _, o, _, _, _, p],
    [p, _, _, f, _, _, f, _, _, _, _, _, _, _, _, _, _, _, _, p],
    [p, _, _, _, _, _, f, f, _, m, _, _, _, _, _, _, _, _, _, p],
    [p, p, p, p, w, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p]
  ],
  fila = -1, columna = 3,
  nivelOeste = nivel4,
  nivelNorte = nivel11,
  nivelSur = nivel13

)
const nivel13 = new Nivel(
  initialGridMap = [
    [p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, n, p, p, p],
    [p, _, _, l, _, _, p, p, _, p, _, _, l, _, _, _, _, _, _, p],
    [p, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, p],
    [p, _, _, _, _, _, o, o, _, f, f, _, _, o, _, _, _, _, _, p],
    [p, _, _, _, _, _, _, _, _, _, f, _, _, _, _, _, _, _, _, p],
    [p, _, _, _, _, _, _, _, o, f, f, _, _, _, _, _, _, _, _, p],
    [p, _, o, _, _, _, _, _, f, _, _, _, _, _, _, o, _, _, _, p],
    [p, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, p],
    [p, _, _, _, _, _, _, _, _, m, _, _, _, _, _, _, _, _, _, p],
    [p, p, p, p, w, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p]
  ],
  fila = -2, columna = 3,
  nivelOeste = nivel14,
  nivelNorte = nivel12

)
const nivel14 = new Nivel(
  initialGridMap = [
    [p, p, p, p, p, p, p, p, p, p, p, p, p, e, p, p, p, p, p, p],
    [p, _, _, l, _, _, p, p, _, p, _, p, p, _, _, l, _, _, _, p],
    [p, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, p],
    [p, _, _, _, _, _, o, o, p, p, p, p, p, p, _, _, _, _, _, p],
    [p, _, _, _, _, _, _, _, p, _, _, _, f, _, _, _, _, _, _, p],
    [p, _, _, _, _, _, _, _, p, n, f, _, f, _, _, _, p, _, _, p],
    [p, _, o, _, _, _, _, _, _, p, f, _, _, _, _, p, _, _, _, p],
    [p, _, _, _, _, _, _, _, _, _, p, p, p, p, p, _, _, _, _, p],
    [p, _, _, _, _, _, _, _, _, m, _, _, _, _, _, _, _, _, _, p],
    [p, p, p, p, w, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p]
  ],
  fila = -2, columna = 2,
  nivelOeste = nivel15,
  nivelEste = nivel13,
  nivelNorte = nivel4

)
const nivel15 = new Nivel(
  initialGridMap = [
    [p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p],
    [p, _, _, l, _, _, p, p, _, p, _, p, p, _, n, l, _, _, _, p],
    [p, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, p],
    [p, _, _, _, _, _, o, o, _, _, _, _, _, o, _, _, _, _, _, p],
    [p, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, p],
    [p, _, _, _, _, _, _, _, o, _, _, _, _, _, _, _, _, _, _, p],
    [p, _, o, _, _, _, _, _, _, _, _, _, _, _, _, o, _, _, _, p],
    [p, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, p],
    [p, _, _, _, _, _, _, _, _, m, _, _, _, _, _, _, _, _, _, p],
    [p, p, p, p, w, p, p, p, p, p, p, p, p, p, p, p, p, p, e, p]
  ],
  fila = -2, columna = 1,
  nivelOeste = nivel16,
  nivelEste = nivel14,
  nivelNorte = nivel1

)
const nivel16 = new Nivel(
  initialGridMap = [
    [p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p],
    [p, _, _, l, _, _, p, p, _, _, f, f, f, f, f, f, f, _, _, p],
    [p, _, _, _, _, _, _, _, _, _, _, _, _, f, _, _, _, _, _, p],
    [p, _, _, _, _, _, o, o, _, _, _, _, _, f, _, _, _, _, _, p],
    [p, _, _, _, _, _, _, _, _, _, _, _, _, f, _, _, _, _, _, p],
    [p, _, _, _, _, _, _, _, o, _, _, _, _, f, _, _, _, _, _, e],
    [p, _, o, _, _, _, _, _, _, _, _, _, _, f, _, _, _, _, _, p],
    [p, _, _, _, _, _, _, _, _, _, _, _, _, f, _, _, _, _, _, n],
    [p, _, _, _, _, _, _, _, _, m, _, _, _, f, _, _, _, _, _, p],
    [p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p]
  ],
  fila = -2, columna = 0,
  nivelEste = nivel15,
  nivelNorte = nivel5

)







object endCredits {
  method iniciar() {
    juegoDungeonGame.clear()
    configTeclado.gameOn()
    new OnlyVisual(image = "End.png", position = game.at(8, 1)).iniciar()
  }
}

