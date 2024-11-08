import juego.BloqueTetris
import BloquesJugables.*
import wollok.game.*

object controlador {
    var finjuego = false 
    var contadoresDeLineaCompleta = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0] //Se suma 1 cada vez que se ocupa un lugar de su fila, hay 1 contador por cada fila
    const matriz = [ //Para acceder a indice usar coordenada 19-y, asi fila inferior es y = 0 y la superior es y = 19
        [new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz()],
        [new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz()],
        [new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz()],
        [new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz()],
        [new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz()],
        [new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz()],
        [new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz()],
        [new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz()],
        [new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz()],
        [new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz()],
        [new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz()],
        [new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz()],
        [new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz()],
        [new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz()],
        [new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz()],
        [new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz()],
        [new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz()],
        [new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz()],
        [new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz()],
        [new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz()],
        [new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz(), new ElementoMatriz()]
    ]  

    const cantidadDeBloques = 7
    method generarBloqueAleatorio() {
        const numeroAleatorio = (-0.999).randomUpTo(cantidadDeBloques - 1).roundUp()
        
        var bloque = new Tipo_bloqueL()
        if (numeroAleatorio == 0) {
            bloque = new Tipo_bloqueL()
        } else if (numeroAleatorio == 1) {
            bloque = new Tipo_bloqueLinv()
        } else if (numeroAleatorio == 2) {
            bloque = new Tipo_bloqueCuadrado()
        } else if (numeroAleatorio == 3) {
            bloque = new Tipo_bloqueLinea()
        } else if (numeroAleatorio == 4) {
            bloque = new Tipo_bloqueS()
        } else if (numeroAleatorio == 5) {
            bloque = new Tipo_bloqueSinv()
        } else if (numeroAleatorio == 6) {
            bloque = new Tipo_bloqueT()
        } else {
            bloque = new Tipo_bloqueLinv() //esto esta para evitar un error
        }
        return bloque
    }
    
    method perder(){
        game.addVisual(gameOver)
        game.removeTickEvent("Caida")
        game.schedule(100, {game.stop()})
    }

    method actualizarNivel(contador, bloqueUnidad, bloqueDecena){
        bloqueUnidad.image("numero" + (contador%10) + ".png")
        bloqueDecena.image("numero" + (contador/10).truncate(0) + ".png")
    }

    method posEstaOcupada(x, y){//1 si pos esta ocupada, 0 si no esta ocupada
        if (x < 18 || x > 27 || y < 0){
            return 1
        }
        if (y > 19){
            return 0
        }
        if (matriz.get(19-y).get(x-18).pieza() != null){
            return 1
        }
        return 0
    }

    method ocuparPos(pieza){
        const x = pieza.position().x()
        const y = pieza.position().y()
        if(y > 19){
            if (!finjuego){
                finjuego = true
                self.perder()
            }
            return -1
        }else{
            matriz.get(19-y).get(x-18).pieza(pieza)
            contadoresDeLineaCompleta = contadoresDeLineaCompleta.take(19 - y) + [(contadoresDeLineaCompleta.get(19 - y)) + 1] + contadoresDeLineaCompleta.drop(19 - y + 1)
            const huboLineaCompleta = (contadoresDeLineaCompleta.get(19 - y) == 10) //La agrego porque si no al retornar me marca un warning de que estoy usando mal el if
            if (huboLineaCompleta) {
                return y
            }
            return -1
        }
    }
    method quitarLineaCompleta(yDeFilaCompleta){
        self.eliminarLinea(19 - yDeFilaCompleta)
        self.bajarLineas(19 - yDeFilaCompleta)
    }

    method dirEstaLibre(dir, listaPiezas){
        if (dir == "derecha"){
            return !listaPiezas.any{p => self.posEstaOcupada(p.position().x()+1, p.position().y()) == 1}
        }
        if (dir == "izquierda"){
            return !listaPiezas.any{p => self.posEstaOcupada(p.position().x()-1, p.position().y()) == 1}
        }
        if (dir == "abajo"){
            return !listaPiezas.any{p => self.posEstaOcupada(p.position().x(), p.position().y()-1) == 1} 
        }
        if (dir == "arriba"){
            return !listaPiezas.any{p => self.posEstaOcupada(p.position().x(), p.position().y()+1) == 1}
        }
        if (dir == "actual"){
            return !listaPiezas.any{p => self.posEstaOcupada(p.position().x(), p.position().y()) == 1}
        }
        return "error"
    }

    method eliminarLinea(indexLinea){
        var columna = 0
        contadoresDeLineaCompleta = [0] + contadoresDeLineaCompleta.take(indexLinea) + contadoresDeLineaCompleta.drop(indexLinea + 1)//Saco la linea completa de los contadores
        10.times({_=>
            game.removeVisual(matriz.get(indexLinea).get(columna).pieza())
            matriz.get(indexLinea).get(columna).pieza(null)
            columna += 1
        })
        
    }


    method bajarLineas(indexLinea){//recibe el indice (de la matriz) de la fila que se elimino
        var matrizAuxiliar = matriz.take(indexLinea)//.filter({fila => fila.any({elemento => elemento.pieza() != null})}) //Agarro solo las filas que van a bajar y tienen alguna pieza
        //La cantidad de lineas en esta matriz sera la cantidad de veces que se va a hacer el proceso de bajar
        var lineaActual = indexLinea-1 //La fila que se va a bajar primero 
        indexLinea.times({
            _=>
            //De la ultima fila de esta matriz, bajamos todos 1 lugar
            matrizAuxiliar.last().forEach({elemento => 
                if(elemento.pieza() != null){
                    elemento.pieza().caer() //actualizamos la posision real (visual) de la pieza
                    matriz.get(lineaActual+1).get(elemento.pieza().position().x()-18).pieza(elemento.pieza()) //Ponemos la nueva pos de la pieza en la matriz
                }
            })
            matriz.get(lineaActual).forEach({elemento => elemento.pieza(null)}) //Borramos la linea de la matriz
            lineaActual -= 1
            matrizAuxiliar = matrizAuxiliar.take(matrizAuxiliar.size()-1) //sacamos la linea de la matriz auxiliar
        }) 
    }
}

class ElementoMatriz{
    var pieza = null
    method pieza() = pieza
    method pieza(nuevaPieza){pieza = nuevaPieza}
}
object gameOver {
    method image() = "gameover.png"
    method position() = game.at(19, 10)
}