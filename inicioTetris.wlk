import wollok.game.*
import juego.*
import controlador.*
//////////////////////////////////////////////////////
    class Juego{
        var anchoTotal = 62
        var altoTotal = 30
        var ticksCaida = 500
        var contadorHolds = 0
        var contadorNivel = 1
        var bloqueActual = controlador.generarBloqueAleatorio()
        var bloqueNext = controlador.generarBloqueAleatorio()
        const nivelUnidad = new Numero
            (
            posision = game.at(37,8), 
            imagen = "numero1.png")
        const nivelDecena = new Numero
            (
            posision = game.at(36,8), 
            imagen = "numero0.png")
        
    }
// -----------GAME DEFAULT---------------
    object tetrisPresentacion inherits Juego{
        /*
        keyboard.z().onPressDo({
            bloqueActual.rotar("izquierda")
            bloqueSombra.imitarPos(bloqueActual)
        })
        */
        method inicio(){
        //BACKGROUND
            game.title("TETRIZADO")
            game.height(altoTotal)
            game.width(anchoTotal)
            game.ground("celdaFondo.jpg") //imagen para cada celda
            game.cellSize(40) //tamaño de cada celda en pixeles que coincide con el tamaño de las piezas (hecho a ojo)
            
        //VISUALES
            game.addVisual(new Menu(posicion = game.center(), imagen = "gameBoy.png"))
            game.addVisualCharacter(persona)
            game.addVisual(papiro)
        
        //MUSICA
            keyboard.enter().onPressDo(musica)
            /*const tetris = game.sound("tetrisgameboy.mp3")
            tetris.shouldLoop(true)
            keyboard.p().onPressDo({tetris.pause()})
            keyboard.r().onPressDo({tetris.resume()})
            keyboard.s().onPressDo({tetris.stop()})
            game.schedule(500, { tetris.play()} )*/
            //-----FIN MUSICA
            
        //COLISION
            game.onCollideDo(persona, 
                        {tetris => keyboard.t().onPressDo({ tetrisJuego.configuracionJuegoTetris() })})
            //keyboard.t().onPressDo({ self.configuracion() })
        }
        
       
    }
// -----------TETRIS
    object tetrisJuego inherits Juego{
        //CLEAR
         method clearGame() {
            game.allVisuals().forEach({ visual => game.removeVisual(visual) })
            }
        //CONFIGURACION
            method configuracionJuegoTetris(){
                self.clearGame()
                keyboard.e().onPressDo({musica.inicial()})
                anchoTotal = 20
                altoTotal = 47
                game.title("TETRIZADO")
                game.height(altoTotal)
                game.width(anchoTotal)
                game.ground("celdaFondo.jpg") //imagen para cada celda
                game.cellSize(40)
                var bloqueHold
                var bloqueSombra
        //--------------------GAMEOVER
            keyboard.e().onPressDo({musica.final()})
            /*const tetris = game.sound("tetrisgameboy.mp3")
            tetris.shouldLoop(true)
            keyboard.p().onPressDo({tetris.pause()})
            keyboard.r().onPressDo({tetris.resume()})
            keyboard.s().onPressDo({tetris.stop()})
            game.schedule(500, { tetris.play()} )*/
            //-----FIN MUSICA
        //--------------------MENU
            game.addVisual(new Menu(posicion = game.at(2,4), imagen = "Gameboyy.png"))

        //--------------------BACKGROUND
            game.addVisual(new Fondo(posision = game.at(0,0), imagen = "fondoDiseñoIzq.png"))
            game.addVisual(new Fondo(posision = game.at(28,0), imagen = "fondoDiseñoDer.png"))
            game.addVisual(new Palabra(posision = game.at(29,12), imagen = "puntajeDiseño.png"))
            game.addVisual(new Palabra(posision = game.at(29,10), imagen = "lineasDiseño.png"))
            puntajes.agregarVisuales()
            game.addVisual(new Palabra(posision = game.at(29,8), imagen = "nivelDiseño.png"))
            game.addVisual(nivelUnidad)
            game.addVisual(nivelDecena)
            game.addVisual(new Palabra(posision = game.at(29,18), imagen = "nextDiseño.png"))
            game.addVisual(new Palabra(posision = game.at(11,18), imagen = "holdDiseño.png"))
        //celdas para NEXT
            game.addVisual(new Palabra(posision = game.at(32,18), imagen = "celdaFondo2.jpg"))
            game.addVisual(new Palabra(posision = game.at(32,17), imagen = "celdaFondo2.jpg"))
            game.addVisual(new Palabra(posision = game.at(32,16), imagen = "celdaFondo2.jpg"))
            game.addVisual(new Palabra(posision = game.at(32,15), imagen = "celdaFondo2.jpg"))
            game.addVisual(new Palabra(posision = game.at(33,18), imagen = "celdaFondo2.jpg"))
            game.addVisual(new Palabra(posision = game.at(33,17), imagen = "celdaFondo2.jpg"))
            game.addVisual(new Palabra(posision = game.at(33,16), imagen = "celdaFondo2.jpg"))
            game.addVisual(new Palabra(posision = game.at(33,15), imagen = "celdaFondo2.jpg"))
            game.addVisual(new Palabra(posision = game.at(34,18), imagen = "celdaFondo2.jpg"))
            game.addVisual(new Palabra(posision = game.at(34,17), imagen = "celdaFondo2.jpg"))
            game.addVisual(new Palabra(posision = game.at(34,16), imagen = "celdaFondo2.jpg"))
            game.addVisual(new Palabra(posision = game.at(34,15), imagen = "celdaFondo2.jpg"))
        //celdas para HOLD
            game.addVisual(new Palabra(posision = game.at(14,18), imagen = "celdaFondo2.jpg"))
            game.addVisual(new Palabra(posision = game.at(14,17), imagen = "celdaFondo2.jpg"))
            game.addVisual(new Palabra(posision = game.at(14,16), imagen = "celdaFondo2.jpg"))
            game.addVisual(new Palabra(posision = game.at(14,15), imagen = "celdaFondo2.jpg"))
            game.addVisual(new Palabra(posision = game.at(15,18), imagen = "celdaFondo2.jpg"))
            game.addVisual(new Palabra(posision = game.at(15,17), imagen = "celdaFondo2.jpg"))
            game.addVisual(new Palabra(posision = game.at(15,16), imagen = "celdaFondo2.jpg"))
            game.addVisual(new Palabra(posision = game.at(15,15), imagen = "celdaFondo2.jpg"))
            game.addVisual(new Palabra(posision = game.at(16,18), imagen = "celdaFondo2.jpg"))
            game.addVisual(new Palabra(posision = game.at(16,17), imagen = "celdaFondo2.jpg"))
            game.addVisual(new Palabra(posision = game.at(16,16), imagen = "celdaFondo2.jpg"))
            game.addVisual(new Palabra(posision = game.at(16,15), imagen = "celdaFondo2.jpg"))
            /////////////////////////////
        //--------------------BLOQUE
            bloqueActual.entrarEnTablero()
            bloqueSombra = bloqueActual.crearSombra()
            bloqueSombra.descender()
            bloqueSombra.mostrar()
            bloqueActual.mostrar()
            bloqueNext.mostrar()

        //--------------------MOVE-TECLADO
            keyboard.up().onPressDo({
                bloqueActual.rotar("derecha")
                bloqueSombra.imitarPos(bloqueActual)
            })
            keyboard.left().onPressDo({
                bloqueActual.mover("izquierda")
                bloqueSombra.imitarPos(bloqueActual)
            })
            keyboard.right().onPressDo({
                bloqueActual.mover("derecha")
                bloqueSombra.imitarPos(bloqueActual)
            })
            keyboard.down().onPressDo({
                bloqueActual.mover("abajo")
            })

        //- ------------------HARDROP
            keyboard.space().onPressDo({
                controlador.actualizarPuntaje((bloqueActual.yCentro()*2).truncate(0))
                const retorno = bloqueActual.hardDrop()
                if (retorno == 0){
                    bloqueActual = bloqueNext
                    contadorHolds = 0
                    bloqueActual.entrarEnTablero()
                    bloqueNext = controlador.generarBloqueAleatorio()
                    bloqueNext.mostrar()
                    bloqueSombra.eliminar()
                    bloqueSombra = bloqueActual.crearSombra()
                    bloqueSombra.descender()
                    bloqueSombra.mostrar()
                    //esto es para que la sombra no quede por encima del bloqueActual cuando se superpongan
                        bloqueActual.remover()
                        bloqueActual.mostrar()
                    }
                }
            )

        //--------------------HOLD
            keyboard.c().onPressDo({
                if(contadorHolds == 0){
                    contadorHolds += 1
                    if(bloqueHold == null)
                    {
                        bloqueHold = bloqueActual
                        bloqueHold.entrarEnHold()
                        bloqueActual = bloqueNext
                        bloqueActual.entrarEnTablero()
                        bloqueNext = controlador.generarBloqueAleatorio()
                        bloqueNext.mostrar()
                        bloqueSombra.eliminar()
                        bloqueSombra = bloqueActual.crearSombra()
                        bloqueSombra.descender()
                        bloqueSombra.mostrar()
                    }else
                    {
                        var bloqueAux
                        bloqueAux = bloqueHold
                        bloqueHold = bloqueActual
                        bloqueActual = bloqueAux
                        bloqueHold.entrarEnHold()
                        bloqueActual.entrarEnTablero()
                        bloqueSombra.eliminar()
                        bloqueSombra = bloqueActual.crearSombra()
                        bloqueSombra.descender()
                        bloqueSombra.mostrar()
                    }
                    //esto es para que la sombra no quede 
                    //por encima del bloqueActual cuando se superpongan
                    bloqueActual.remover()
                    bloqueActual.mostrar()
                }
            })
            ///////////////////////////
        //--------------------CAIDA
            game.onTick(ticksCaida, "Caida", 
            {
                bloqueActual.caer()

                if(bloqueActual.estaEnElFondo()){
                    game.schedule(500, { //La idea de esto es que tengas un ratito para mover la pieza antes de que se quede fija
                        if (bloqueActual.estaEnElFondo()){
                            bloqueActual.establecerEnTablero()
                            bloqueActual = bloqueNext
                            contadorHolds = 0
                            bloqueActual.entrarEnTablero()
                            bloqueNext = controlador.generarBloqueAleatorio()
                            bloqueNext.mostrar()
                            bloqueSombra.eliminar()
                            bloqueSombra = bloqueActual.crearSombra()
                            bloqueSombra.descender()
                            bloqueSombra.mostrar()
                            //esto es para que la sombra no quede por encima del bloqueActual cuando se superpongan
                            bloqueActual.remover()
                            bloqueActual.mostrar()
                        }
                    })
                }
            })
        //--------------------LEVEL
            //cada 1 minuto (60 segundos) se reduce el tiempo de caida
            game.onTick(1000*60 , "Incremento de Dificultad", 
                {
                    if(ticksCaida > 50)
                    {
                        ticksCaida -= 50
                        contadorNivel += 1
                        controlador.actualizarNivel(contadorNivel, nivelUnidad, nivelDecena)
                    } else 
                    {
                        game.removeTickEvent("Incremento de Dificultad")
                    }
                }
            )
            /*
                No pareciera acelerarse la velocidad de caida de las piezas...
                Quizas porque hay muchas acciones que se hacen cada vez que la pieza cae y 
                hasta que no se hacen todas no se vuelve a ejecutar el evento de caida
                */
            }
        
    }
// -----------MUSICA
    object musica {
        method inicial(){
        const sonido = game.sound("tetrisgameboy.mp3").play()
        }
        method final(){
        const sonido = game.sound("gameover.mp3").play()    
        }
    }
//////////////////////////////////////////////////////

