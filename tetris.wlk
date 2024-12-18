import juego.*
import wollok.game.*
import controlador.*

object tetris{
    method inicioJuego(){
    game.title("TETRIZADO")
    game.height(20)
    game.width(47)
    game.ground("celdaFondo.jpg") //imagen para cada celda
    game.cellSize(40) //tamaño de cada celda en pixeles que coincide con el tamaño de las piezas (hecho a ojo)
    controlador.inicializarMatriz()
    var ticksCaida = 500 //milisiegundos cada los que las piezas descienden una posicion en el tablero
    var bloqueActual = controlador.generarBloqueAleatorio()
    var bloqueNext = controlador.generarBloqueAleatorio()
    var bloqueHold
    var bloqueSombra
    var sePuedeUsarHold = true
    var juegoPausado = false

    visuales.agregarVisuales()

    bloqueActual.entrarEnTablero()
    bloqueSombra = controlador.crearSombraYUbicarla(bloqueActual)
    bloqueNext.mostrar()

    game.start()
    /*
    method clearGame() {
		game.allVisuals().forEach({ visual => game.removeVisual(visual) })
	}
    
    self.clearGame()
    */
    
        
        //reinniciamos numeros (ya existen los metodos)
        //reiniciamos el tablero
        //reiniciamos next y hold
        //generamos nuevo bloque actual y nuevo bloque next
        

    keyboard.p().onPressDo({
        if (!juegoPausado){
            juegoPausado = true
            visuales.mostrarVentanaPausa()
        }else{
            juegoPausado = false
            visuales.ocultarVentanaPausa()
        }
    })

    keyboard.z().onPressDo({
        if(!juegoPausado){
            bloqueActual.rotar(antihoraria)
            bloqueSombra.imitarPosRot(bloqueActual)
        }
    })
    keyboard.up().onPressDo({
        if(!juegoPausado){
            bloqueActual.rotar(horaria)
            bloqueSombra.imitarPosRot(bloqueActual)
        }
    })

    keyboard.left().onPressDo({
        if(!juegoPausado){
            bloqueActual.mover(izquierda)
            bloqueSombra.imitarPosMov(bloqueActual)
        }
    })

    keyboard.right().onPressDo({
        if(!juegoPausado){
            bloqueActual.mover(derecha)
            bloqueSombra.imitarPosMov(bloqueActual)
        }
    })

    keyboard.down().onPressDo({
        if(!juegoPausado){
            bloqueActual.mover(abajo)
        }
    })

    keyboard.space().onPressDo({
        if (!juegoPausado){
            puntaje.sumar((bloqueActual.yCentro()*2).truncate(0))
            bloqueActual.hardDrop(bloqueSombra)
            sePuedeUsarHold = true
            bloqueActual = controlador.establecerYLlamarSiguente(bloqueActual, bloqueNext) 
            bloqueNext = controlador.generarSiguienteBloque()
            bloqueSombra = controlador.ReemplazarSombra(bloqueActual, bloqueSombra)
        }

    })
    
    keyboard.c().onPressDo({
        if(!juegoPausado){
            if(sePuedeUsarHold){
                sePuedeUsarHold = false
                if(bloqueHold == null){
                    bloqueHold = bloqueActual
                    bloqueHold.entrarEnHold()
                    bloqueActual = controlador.llamarSiguienteBloque(bloqueNext)
                    bloqueNext = controlador.generarSiguienteBloque()
                }else{
                    var bloqueAux
                    bloqueAux = bloqueHold
                    bloqueHold = bloqueActual
                    bloqueActual = bloqueAux
                    bloqueHold.entrarEnHold()
                    bloqueActual.entrarEnTablero()
                }
                bloqueSombra = controlador.ReemplazarSombra(bloqueActual, bloqueSombra)
            }
        }
    })
    
    game.onTick(ticksCaida, "Caida", 
    {
        if (!juegoPausado){
            bloqueActual.caer()

            if(bloqueActual.estaEnElFondo()){
                game.schedule(500, { //La idea de esto es que tengas un ratito para mover la pieza antes de que se quede fija
                    if (bloqueActual.estaEnElFondo()){
                        sePuedeUsarHold = true
                        bloqueActual = controlador.establecerYLlamarSiguente(bloqueActual, bloqueNext)
                        bloqueNext = controlador.generarSiguienteBloque()
                        bloqueSombra = controlador.ReemplazarSombra(bloqueActual, bloqueSombra)
                    }
                })
            }
        }
    })
    
    //cada 1 minuto (60 segundos) se reduce el tiempo de caida
    game.onTick(1000*60 , "Incremento de Dificultad", {
        if(!juegoPausado){
            if(ticksCaida > 50){
                ticksCaida -= 50
                nivel.sumar(1)
            } else {
                game.removeTickEvent("Incremento de Dificultad")
            }
        }
    })
    /*
       No pareciera acelerarse la velocidad de caida de las piezas...
       Quizas porque hay muchas acciones que se hacen cada vez que la pieza cae y 
       hasta que no se hacen todas no se vuelve a ejecutar el evento de caida
    */
    }
}