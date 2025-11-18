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
  const goalPositionsFinal = []  // Puerta dorada final
  
  
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
    goalPositionsFinal.clear()
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
  
  method addGoalPositionFinal(x, y) {
    goalPositionsFinal.add(game.at(x, y))
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
  
  method cuerpoSobreMetaFinal() = (cuerpo.personaje() != null) && goalPositionsFinal.any(
    { goalPos => cuerpo.personaje().position() == goalPos }
  )
  
  // Método original para compatibilidad (revisa todas las direcciones)
  method cuerpoSobreMeta() = (cuerpo.personaje() != null) && (
    goalPositionsNorte.any({ goalPos => cuerpo.personaje().position() == goalPos }) ||
    goalPositionsSur.any({ goalPos => cuerpo.personaje().position() == goalPos }) ||
    goalPositionsEste.any({ goalPos => cuerpo.personaje().position() == goalPos }) ||
    goalPositionsOeste.any({ goalPos => cuerpo.personaje().position() == goalPos }) ||
    goalPositionsFinal.any({ goalPos => cuerpo.personaje().position() == goalPos })
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
} 


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

// sistema de coordenadas 
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

// Puerta Dorada Final - requiere llave para ganar
object d {
  method decode(x, y, level) {
    const puertaDorada = new MetaValidadora2(
      position = game.at(x, y)
    )
    puertaDorada.iniciar()
    level.addGoalPositionFinal(x, y)
  }
}

//*==========================| Niveles Instanciados |==========================

//Move Tutorial - Nivel introductorio (FÁCIL)
const nivel1 = new Nivel(
  initialGridMap = [
      [v, v, v, v, v, v, v, v, v, v, v, v, v, v, v, v, v, v, v, v],
      [v, v, v, p, p, p, p, p, p, p, p, n, p, p, p, p, v, v, v, v],
      [v, v, v, p, _, _, _, f, _, p, _, f, _, _, _, p, v, v, v, v],
      [v, v, v, p, _, m, _, _, _, p, _, _, _, o, _, p, v, v, v, v],
      [v, v, v, l, _, _, _, _, _, p, _, _, f, _, _, p, v, v, v, v],
      [v, v, v, w, _, f, _, p, p, p, _, _, _, _, _, e, v, v, v, v],
      [v, v, v, p, _, _, _, _, _, _, _, f, _, _, _, p, v, v, v, v],
      [v, v, v, p, _, _, _, _, _, _, _, _, _, _, _, p, v, v, v, v],
      [v, v, v, p, p, p, p, p, s, p, p, p, p, p, p, p, v, v, v, v],
      [v, v, v, v, v, v, v, v, v, v, v, v, v, v, v, v, v, v, v, v]
    ], 
  fila = -1, columna = 1,
  nivelNorte = nivel2,
  nivelEste = nivel4,
  nivelOeste = nivel5,
  nivelSur = nivel15
)

//Introducción a fogatas - FÁCIL/MEDIA
const nivel2 = new Nivel(
  initialGridMap = [
    [v, v, v, v, v, v, v, v, v, v, v, v, v, v, v, v, v, v, v, v],
    [v, v, v, p, p, p, p, p, p, p, p, p, n, p, p, p, v, v, v, v],
    [v, v, v, p, _, f, _, _, _, p, f, _, _, _, f, p, v, v, v, v],
    [v, v, v, p, _, m, _, _, _, p, _, _, o, o, _, p, v, v, v, v],
    [v, v, v, w, _, _, f, _, _, p, _, f, _, _, _, l, v, v, v, v],
    [v, v, v, p, _, _, _, _, _, _, _, _, _, _, _, e, v, v, v, v],
    [v, v, v, p, _, _, _, f, _, _, _, f, _, _, _, p, v, v, v, v],
    [v, v, v, p, _, _, _, _, _, _, _, _, _, _, _, p, v, v, v, v],
    [v, v, v, p, p, p, p, p, s, p, p, p, p, p, p, p, v, v, v, v],
    [v, v, v, v, v, v, v, v, v, v, v, v, v, v, v, v, v, v, v, v]
  ],
  fila = 0, columna = 1,
  nivelSur = nivel1,
  nivelEste = nivel3,
  nivelOeste = nivel6,
  nivelNorte = nivel8
)

// Fogatas + Agujeros - MEDIA
const nivel3 = new Nivel(
  initialGridMap = [
    [v, v, v, v, v, v, v, v, v, v, v, v, v, v, v, v, v, v, v, v],
    [l, p, p, p, p, p, p, p, p, p, p, p, p, n, p, p, p, p, l, v],
    [l, _, f, _, _, _, f, _, _, _, f, _, _, _, _, _, f, _, p, v],
    [p, _, _, _, _, _, _, _, _, f, _, _, _, _, _, _, _, _, p, v],
    [w, _, m, _, _, o, _, f, _, _, _, f, _, _, _, o, _, _, p, v],
    [p, _, _, _, _, _, _, _, _, f, _, _, _, _, _, _, _, _, p, v],
    [p, _, f, _, _, o, _, _, _, _, _, _, _, _, _, _, f, _, e, v],
    [p, _, _, _, _, f, _, _, _, _, _, _, _, _, f, _, _, _, p, v],
    [l, p, p, p, p, p, p, p, p, p, p, s, p, p, p, p, p, p, l, v],
    [v, v, v, v, v, v, v, v, v, v, v, v, v, v, v, v, v, v, v, v]
  ],
  fila = 0, columna = 2,
  nivelOeste = nivel2,
  nivelSur = nivel4,
  nivelEste = nivel11,
  nivelNorte = nivel9
)

// Pasillos con obstáculos - MEDIA
const nivel4 = new Nivel(
  initialGridMap = [
    [v, v, v, v, v, v, v, v, v, v, v, v, v, v, v, v, v, v, v, v],
    [v, v, v, p, p, p, p, p, p, p, p, p, p, n, p, p, p, v, v, v],
    [v, p, p, p, _, f, _, _, f, _, _, _, _, _, f, _, _, p, p, v],
    [v, p, _, _, _, _, _, _, _, p, _, f, _, _, _, _, _, _, p, v],
    [v, w, _, _, _, _, f, _, _, p, _, _, _, _, _, 0, f, _, e, v],
    [v, l, _, _, _, m, _, _, _, p, p, p, _, o, _, _, _, _, l, v],
    [v, p, _, f, _, _, _, _, _, _, p, _, _, _, _, f, _, _, p, v],
    [v, p, _, _, _, _, f, _, o, _, _, _, _, f, _, _, _, _, p, v],
    [v, p, p, p, p, p, p, p, p, p, p, p, p, p, p, s, p, p, p, v],
    [v, v, v, v, v, v, v, v, v, v, v, v, v, v, v, v, v, v, v, v]
  ],
  fila = -1, columna = 2,
  nivelOeste = nivel1,
  nivelNorte = nivel3,
  nivelSur = nivel14,
  nivelEste = nivel12
)

// Laberinto básico - MEDIA
const nivel5 = new Nivel(
  initialGridMap = [
    [v, v, v, v, v, v, v, p, p, p, l, s, p, p, v, v, v, v, v, v],
    [v, v, v, v, p, p, p, p, _, _, _, f, _, p, p, p, p, v, v, v],
    [v, v, p, p, p, _, f, _, _, p, _, _, _, f, _, _, e, p, p, v],
    [v, v, p, _, _, _, _, _, _, p, _, f, _, _, _, _, _, _, p, v],
    [v, v, p, _, _, _, f, _, _, p, _, _, _, _, f, _, _, _, p, v],
    [v, v, l, f, _, m, _, _, _, _, f, _, _, _, _, _, _, o, l, v],
    [v, v, p, _, _, _, _, _, f, _, _, _, _, _, _, f, _, _, p, v],
    [v, v, p, _, _, _, _, _, _, _, f, n, _, _, _, _, _, _, p, v],
    [v, v, p, p, p, p, w, p, p, p, p, p, p, p, p, p, p, p, p, v],
    [v, v, v, v, v, v, v, v, v, v, v, v, v, v, v, v, v, v, v, v]
  ],
  fila = -1, columna = 0,
  nivelNorte = nivel6,
  nivelSur = nivel6,
  nivelEste = nivel1
)

// Agujeros + Fogatas - MEDIA/DIFÍCIL
const nivel6 = new Nivel(
  initialGridMap = [
    [v, v, v, v, v, v, v, v, v, v, v, v, v, v, v, v, v, v, v, v],
    [v, v, v, v, p, p, p, p, p, p, p, p, p, p, p, p, p, v, v, v],
    [v, v, v, p, p, _, f, _, _, f, _, _, f, _, _, f, n, p, v, v],
    [v, v, v, p, _, _, _, _, _, _, _, _, _, _, _, _, _, p, v, v],
    [v, v, v, p, f, m, _, _, f, _, _, f, _, _, f, _, _, p, v, v],
    [v, v, v, p, _, _, _, _, _, _, _, _, _, _, _, _, _, p, v, v],
    [v, v, v, p, _, _, _, f, _, _, p, p, _, f, s, _, _, e, v, v],
    [v, v, v, p, p, _, _, _, _, _, p, _, _, _, _, _, p, p, v, v],
    [v, v, v, v, p, p, p, p, p, p, p, p, p, n, p, p, p, v, v, v],
    [v, v, v, v, v, v, v, v, v, v, v, v, v, v, v, v, v, v, v, v]
  ],
  fila = 0, columna = 0,
  nivelEste = nivel2,
  nivelNorte = nivel7,
  nivelSur = nivel5
)

// NIVEL FINAL - Llave y Puerta Dorada - DIFÍCIL
const nivel7 = new Nivel(
  initialGridMap = [
    [v, v, v, v, v, v, v, v, v, v, v, v, v, v, v, v, v, v, v, v],
    [v, v, v, p, p, p, p, p, p, p, p, p, p, s, p, p, p, v, v, v],
    [v, v, v, p, f, _, f, _, _, p, p, _, _, f, _, f, p, v, v, v],
    [v, v, v, d, _, f, _, _, _, x, x, _, f, _, _, _, p, v, v, v],
    [v, v, v, p, f, _, _, _, _, _, _, _, _, f, _, f, p, v, v, v],
    [v, v, v, p, _, _, _, x, _, f, _, _, _, _, _, f, p, v, v, v],
    [v, v, v, e, _, m, _, _, _, x, x, _, _, _, f, _, p, v, v, v],
    [v, v, v, p, _, _, _, f, _, p, p, _, f, _, _, f, p, v, v, v],
    [v, v, v, p, p, p, p, p, p, p, p, p, p, p, p, p, p, v, v, v],
    [v, v, v, v, v, v, v, v, v, v, v, v, v, v, v, v, v, v, v, v]
  ],
  fila = 1, columna = 0,
  nivelSur = nivel6,
  nivelEste = nivel8
)

// Fogatas estratégicas - DIFÍCIL
const nivel8 = new Nivel(
  initialGridMap = [
    [v, v, v, v, p, p, p, p, p, e, p, p, p, p, p, p, v, v, v, v],
    [v, v, v, p, p, f, _, f, _, _, f, _, f, _, f, p, p, v, v, v],
    [v, v, v, p, _, _, _, _, _, _, _, _, _, _, _, _, p, v, v, v],
    [v, v, v, p, _, _, _, f, _, _, _, f, _, _, _, _, p, v, v, v],
    [v, v, v, p, _, _, _, _, _, _, _, _, _, _, f, _, p, v, v, v],
    [v, v, v, w, _, f, _, _, _, _, _, _, _, f, _, _, p, v, v, v],
    [v, v, v, p, _, _, _, _, _, m, _, _, _, _, _, _, p, v, v, v],
    [v, v, v, p, _, _, f, _, _, _, _, _, f, _, p, s, p, v, v, v],
    [v, v, v, p, p, _, _, _, f, _, _, f, _, _, p, p, p, v, v, v],
    [v, v, v, v, p, p, p, p, p, p, p, p, p, p, p, p, p, v, v, v]
  ],
  fila = 1, columna = 1,
  nivelOeste = nivel7,
  nivelEste = nivel9,
  nivelSur = nivel2
)

// Arena abierta - DIFÍCIL
const nivel9 = new Nivel(
  initialGridMap = [
    [p, p, p, p, p, p, s, p, p, p, p, p, p, p],
    [p, _, f, l, _, f, _, _, f, _, p, _, f, p],
    [p, _, p, _, p, _, _, f, _, _, _, f, _, p],
    [p, _, _, _, _, f, _, _, _, f, p, _, _, p],
    [p, f, p, _, _, _, _, _, f, _, _, p, _, p],
    [p, _, _, f, _, _, _, f, _, _, f, _, _, p],
    [p, _, _, _, p, _, f, _, _, p, _, _, _, p],
    [p, _, f, _, _, _, _, m, _, f, _, _, _, p],
    [p, p, p, p, w, p, p, p, p, p, e, p, p, p]
  ],
  fila = 1, columna = 2,
  nivelOeste = nivel8,
  nivelEste = nivel10,
  nivelSur = nivel3
)
// Obstáculos mixtos - DIFÍCIL
const nivel10 = new Nivel(
  initialGridMap = [
    [p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p],
    [p, f, _, l, _, f, p, p, _, p, _, p, p, _, f, l, _, f, _, p],
    [p, _, _, _, _, _, f, _, _, _, f, _, _, _, _, _, _, _, _, p],
    [p, _, _, _, _, _, _, f, _, _, _, f, _, _, _, _, _, _, _, p],
    [p, _, _, _, _, f, _, _, _, _, f, _, _, _, _, f, _, _, _, p],
    [p, _, _, f, _, _, _, _, _, f, _, _, _, _, f, _, _, _, _, p],
    [p, _, _, _, _, _, _, _, f, _, _, _, _, _, _, _, _, _, _, p],
    [p, _, _, _, _, f, _, _, _, _, _, _, f, _, _, _, _, _, _, p],
    [p, _, f, _, _, _, _, _, f, m, f, _, _, _, _, _, f, _, _, p],
    [p, p, p, p, w, p, p, p, p, p, p, p, p, p, p, p, p, p, s, p]
  ],
  fila = 1, columna = 3,
  nivelSur = nivel11,
  nivelOeste = nivel9
)
// Patrón complejo - DIFÍCIL
const nivel11 = new Nivel(
  initialGridMap = [
    [p, p, p, p, p, p, p, p, p, p, p, p, p, p, n, p, p, p, p, p],
    [p, f, _, l, f, _, p, p, f, p, _, p, p, _, f, l, _, f, _, p],
    [p, _, _, _, _, _, _, f, _, _, f, _, f, _, _, _, _, _, _, p],
    [p, _, _, _, _, _, f, _, _, _, _, _, _, _, _, f, _, _, _, p],
    [p, _, _, _, f, _, _, _, _, f, _, _, _, f, _, _, _, _, _, p],
    [p, _, f, _, _, _, _, _, f, _, f, _, _, _, _, _, f, _, _, p],
    [p, _, _, _, _, _, _, f, _, _, _, f, _, _, _, _, _, _, _, p],
    [p, _, _, _, _, f, _, _, _, _, f, _, _, f, _, _, _, _, _, p],
    [p, _, _, f, _, _, _, _, f, m, f, _, _, _, _, f, _, _, _, p],
    [p, p, p, p, w, p, p, p, p, p, p, p, p, p, p, s, p, p, p, p]
  ],
  fila = 0, columna = 3,
  nivelOeste = nivel3,
  nivelNorte = nivel10,
  nivelSur = nivel12
)
// Desafío avanzado - MUY DIFÍCIL
const nivel12 = new Nivel(
  initialGridMap = [
    [p, p, p, p, p, p, p, p, n, p, p, p, p, p, p, p, p, p, p, p],
    [p, f, _, l, f, _, p, p, _, p, _, p, p, f, s, l, _, f, _, p],
    [p, _, _, _, _, _, f, _, _, _, f, _, _, _, f, _, _, _, _, p],
    [p, _, _, _, f, _, _, _, _, f, _, _, f, _, _, _, f, _, _, p],
    [p, _, _, _, _, _, _, _, f, _, _, _, _, f, _, _, _, _, _, p],
    [p, _, f, _, _, _, _, f, _, _, _, _, _, _, f, _, _, f, _, p],
    [p, _, _, _, _, f, _, _, _, _, f, _, _, f, _, _, _, _, _, p],
    [p, _, f, _, _, _, _, _, f, _, _, _, _, _, _, f, _, _, _, p],
    [p, _, _, _, f, _, _, _, _, m, _, _, f, _, _, _, f, _, _, p],
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
    [p, f, _, l, f, _, p, p, f, p, _, f, l, _, f, _, _, f, _, p],
    [p, _, _, _, _, _, f, _, _, _, f, _, _, f, _, _, _, _, _, p],
    [p, _, _, _, f, _, _, _, _, f, _, _, _, _, _, f, _, _, _, p],
    [p, _, f, _, _, _, _, f, _, _, _, _, _, f, _, _, _, _, _, p],
    [p, _, _, _, f, _, _, _, _, _, f, _, _, _, _, _, f, _, _, p],
    [p, _, _, _, _, _, _, f, _, _, _, _, _, _, f, _, _, _, _, p],
    [p, _, _, _, f, _, _, _, _, _, f, _, _, _, _, _, f, _, _, p],
    [p, _, f, _, _, _, f, _, _, m, _, f, _, _, f, _, _, _, _, p],
    [p, p, p, p, w, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p]
  ],
  fila = -2, columna = 3,
  nivelOeste = nivel14,
  nivelNorte = nivel12

)
const nivel14 = new Nivel(
  initialGridMap = [
    [p, p, p, p, p, p, p, p, p, p, p, p, p, e, p, p, p, p, p, p],
    [p, f, _, l, f, _, p, p, f, p, _, p, p, _, f, l, _, f, _, p],
    [p, _, _, _, _, _, _, f, _, _, f, _, _, f, _, _, _, _, _, p],
    [p, _, _, _, f, _, _, _, p, p, p, p, p, p, _, _, _, _, f, p],
    [p, _, _, _, _, _, f, _, p, f, _, f, _, _, f, _, _, _, _, p],
    [p, _, f, _, _, _, _, _, p, n, _, _, _, _, _, f, p, _, _, p],
    [p, _, _, _, _, f, _, _, _, p, f, _, _, f, _, p, _, _, _, p],
    [p, _, _, _, _, _, _, _, f, _, p, p, p, p, p, _, _, f, _, p],
    [p, _, _, f, _, _, _, _, _, m, _, _, f, _, _, _, _, _, _, p],
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
    [p, _, f, l, _, _, p, p, f, p, _, p, p, f, n, l, _, f, _, p],
    [p, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, p],
    [p, _, _, _, _, _, _, _, f, _, _, _, f, _, _, _, _, _, _, p],
    [p, _, _, f, _, _, _, _, _, _, _, _, _, _, _, _, f, _, _, p],
    [p, _, _, _, _, _, f, _, _, _, f, _, _, _, _, _, _, _, _, p],
    [p, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, k, _, _, p],
    [p, _, _, _, _, f, _, _, _, _, _, _, _, f, _, _, _, _, _, p],
    [p, _, f, _, _, _, _, _, _, m, _, _, _, _, _, f, _, _, _, p],
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
    [p, f, _, l, f, _, p, p, f, _, f, _, f, _, f, _, _, f, _, p],
    [p, _, _, _, _, _, _, f, _, _, _, f, _, _, f, _, _, _, _, p],
    [p, _, _, _, f, _, _, _, _, f, _, _, _, _, _, _, f, _, _, p],
    [p, _, _, _, _, _, f, _, _, _, _, _, _, f, _, _, _, _, _, p],
    [p, _, f, _, _, _, _, _, _, f, _, _, _, _, _, _, f, _, _, e],
    [p, _, _, _, _, f, _, _, _, _, _, _, f, _, _, _, _, _, _, p],
    [p, _, _, _, _, _, _, _, f, _, _, _, _, _, _, f, _, _, _, n],
    [p, _, _, f, _, _, _, _, f, m, f, _, _, _, _, f, _, _, _, p],
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

