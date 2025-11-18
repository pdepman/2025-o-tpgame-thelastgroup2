import dungeonGame.*
import levels.*

//*==========================| MENU Inicial |==========================
  object menu{
    method iniciar(){
      juegoDungeonGame.clear()
      
      //Visuales
      self.drawMenu()

      //Teclado
      configTeclado.menuOn()
    }
    
    method drawMenu(){
      new OnlyVisual(image = "Logo.png", position = game.at(5,7)).iniciar()
      levelMenu.iniciar()
    }
  }

  object levelMenu{
    const property position = game.at(4,4)
    var levelMenuIsOpen = false
    var image = "CloseMenu.png"
    
    method image() = image
    
    method iniciar(){
      game.addVisual(self)
      configTeclado.menuOn()
      levelMenuIsOpen = false
      image = "CloseMenu.png"
    }

    method toggle() = if(levelMenuIsOpen) self.close() else self.open()

    method close(){
    image = "CloseMenu.png"
    configTeclado.menuOn()
    levelMenuIsOpen = false
    }

    method open(){
    image = "CloseMenu.png"
    configTeclado.levelMenuOn()
    levelMenuIsOpen = true
    }
  }

  class OnlyVisual{
    method iniciar(){
      game.addVisual(self)
    }

    var property image 

    const property position 
  }

//*==========================| Config Teclado |==========================

    
  object configTeclado{

      var teclado = tecladoJuego

      method iniciar(){

        //* GAME ON:

          //Movimientos:
          keyboard.up().onPressDo({teclado.up()})
          keyboard.down().onPressDo({teclado.down()})
          keyboard.left().onPressDo({teclado.left()})
          keyboard.right().onPressDo({teclado.right()})

          //unDo:
          keyboard.control().onPressDo({teclado.control()})

          //Menu en nivel:
          keyboard.m().onPressDo({teclado.m()})
          keyboard.r().onPressDo({teclado.r()})

        //* MENU ON:
          keyboard.p().onPressDo({teclado.p()})
          keyboard.c().onPressDo({teclado.c()})

        //* LEVEL MENU ON:
          keyboard.num1().onPressDo({teclado.num1()})
          keyboard.num2().onPressDo({teclado.num2()})
          keyboard.num3().onPressDo({teclado.num3()})
          keyboard.num4().onPressDo({teclado.num4()})
          keyboard.num5().onPressDo({teclado.num5()})
          keyboard.num6().onPressDo({teclado.num6()})
          keyboard.num7().onPressDo({teclado.num7()})
          keyboard.num8().onPressDo({teclado.num8()})
          keyboard.num9().onPressDo({teclado.num9()})

          // GAME OVER
          keyboard.e().onPressDo({teclado.e()})
      }

      method gameOn(){
        teclado = tecladoJuego
      }

      method menuOn(){
        teclado = tecladoMenu
      }

      method levelMenuOn(){
        teclado = tecladoSelectorNivel
      }
      method gameOverOn(){
        teclado = tecladoGameOver
      }
      method victoriaOn(){
        teclado = tecladoVictoria
      }
    }

  class TecladoBase{
    method up(){}
    method down(){}
    method left(){}
    method right(){}

    method control(){}

    method m(){}
    method r(){}
    method p(){}
    method c(){}

    method num1(){}
    method num2(){}
    method num3(){}
    method num4(){}
    method num5(){}
    method num6(){}
    method num7(){}
    method num8(){}
    method num9(){}

    method e(){}

  }

  object tecladoJuego inherits TecladoBase{
    override method up(){
      cuerpo.moverCuerpo(arriba)
    }
    override method down(){
      cuerpo.moverCuerpo(abajo)
    }
    override method left(){
      cuerpo.moverCuerpo(izquierda)
    }
    override method right(){
      cuerpo.moverCuerpo(derecha)
    }
    
    override method control(){
      juegoDungeonGame.unDo()
    }

    override method m(){
      menu.iniciar()
    }

    override method r(){
      juegoDungeonGame.reset()
    }
  }

  
class TecladoMenu inherits TecladoBase{
    override method p(){
        administradorVidas.reiniciar()
        nivel3.iniciar()
    }

    override method c(){
        console.println("¡TECLA C FUNCIONA!")
        levelMenu.toggle()
    }
}

const tecladoMenu = new TecladoMenu()



  object tecladoSelectorNivel inherits TecladoMenu{
      override method num1(){
        administradorVidas.reiniciar() 
        nivel1.iniciar()
    }
    override method num2(){
        administradorVidas.reiniciar()  
        nivel2.iniciar()
    }
    override method num3(){
        administradorVidas.reiniciar()  
        nivel3.iniciar()
    }
    override method num4(){
        administradorVidas.reiniciar()  
        nivel4.iniciar()
    }
    override method num5(){
        administradorVidas.reiniciar()  
        nivel5.iniciar()
    }
    override method num6(){
        administradorVidas.reiniciar()  
        nivel6.iniciar()
    }
    override method num7(){
        administradorVidas.reiniciar()  
        nivel7.iniciar()
    }
    override method num8(){
        administradorVidas.reiniciar() 
        nivel8.iniciar()
    }
    override method num9(){
        administradorVidas.reiniciar()  
        nivel9.iniciar()
    }
  }

  object tecladoGameOver inherits TecladoBase{
    override method e(){
      pantallaGameOver.reiniciarJuego()
    }
    override method m (){
      pantallaGameOver.volverAlMenu()
    }
  
  }

  object tecladoVictoria inherits TecladoBase{
    override method e(){
      pantallaVictoria.verCreditos()
    }
    override method m(){
      pantallaVictoria.volverAlMenu()
    }
  }