import juego.*
import BloquesJugables.*
import wollok.game.*

// -------------- Referencias del Matriz-Tablero -------------------- 

class ElementoMatriz{
    var pieza = null
    method pieza() = pieza
    method pieza(nuevaPieza){pieza = nuevaPieza}
}
object controlador {
    var finjuego = false 
    var contadoresDeLineaCompleta = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0] //Se suma 1 cada vez que se ocupa un lugar de su fila, hay 1 contador por cada fila

// -------------- Tablero -------------------------------------------------

    const matriz = [] //Para acceder a indice usar coordenada 19-y, asi fila inferior es y = 0 y la superior es y = 19
    method inicializarMatriz(){
        20.times({_=>
            matriz.add([new ElementoMatriz()])
            9.times({_=>
                matriz.last().add(new ElementoMatriz())
            })
        })
    }  

// ------------- Crear Bloque ---------------------------------

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
 // --------------------- Game Over - Implementacion ------------------------------


    method perder(){
        game.addVisual(gameOver)
        game.removeTickEvent("Caida")
        game.schedule(100, {game.stop()})
    }


// ----------------- Verificar posiciones -------------------- 

    method posEstaOcupada(x, y){//1 si pos esta ocupada, 0 si no esta ocupada
        if (x < 18 || x > 27 || y < 0){
            return 1
        }
        if (y > 19 ){
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
// --------------------- Completar Linea ---------------------------- 

    method quitarLineaCompleta(yDeFilaCompleta){
        self.eliminarLinea(19 - yDeFilaCompleta)
        self.bajarLineas(19 - yDeFilaCompleta)
        lineas.sumar(1)
    }

    method dirEstaLibre(dir, listaPiezas){ //true si dir esta libre, false si no lo esta
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

    method ColumnaEstaLibre(xCol, ySombra, yBloque){ //retorna false si hay algun objeto en la columna
        const matrizActual = matriz.take(20-ySombra).drop(20-yBloque)
        return !matrizActual.any({fila => fila.get(xCol-18).pieza() != null})
    }

    method columnasLibresApartiDePieza(piezasSombra, piezasBloque){
        var xCols = piezasSombra.map({pieza => pieza.position().x()}).asSet().asList()
        const ySombra = piezasSombra.map({pieza => pieza.position().y()}).min()
        const yBloque = piezasBloque.map({pieza => pieza.position().y()}).min()
        const iterador = xCols.size()
        const colsLibres = []
        iterador.times({_=>
            colsLibres.add(self.ColumnaEstaLibre(xCols.head(), ySombra, yBloque))
            xCols = xCols.drop(1)
        })
        return colsLibres.all({col => col})
    }
    method crearSombraYUbicarla(bloqueActual){
        const nuevoBloqueSombra = bloqueActual.crearSombra()
        nuevoBloqueSombra.descender()
        nuevoBloqueSombra.mostrar()
        bloqueActual.remover()
        bloqueActual.mostrar()
        return nuevoBloqueSombra
    }
    method ReemplazarSombra(bloqueActual, bloqueSombra){
        bloqueSombra.eliminar()
        const nuevoBloqueSombra = self.crearSombraYUbicarla(bloqueActual)
        //esto es para que la sombra no quede por encima del bloqueActual cuando se superpongan
        return nuevoBloqueSombra
    }

    method llamarSiguienteBloque(bloqueNext){
        bloqueNext.entrarEnTablero()
        return bloqueNext
    }
    method generarSiguienteBloque(){
        const bloqueNext = self.generarBloqueAleatorio()
        bloqueNext.mostrar()
        return bloqueNext
    }
    method establecerYLlamarSiguente(bloqueActual, bloqueNext){
        bloqueActual.establecerEnTablero()
        return self.llamarSiguienteBloque(bloqueNext)
    }
}

class Incrementales {
    var contador
    const listaNumeros

    method actuaizarVisuales(valor){
        numero.mostrar(valor, listaNumeros)
    }
    
    method sumar(valorQueSeSuma){
        contador += valorQueSeSuma
        self.actuaizarVisuales(contador)
    }
 
    
}

object puntaje inherits Incrementales(contador= 0, listaNumeros = [unidad, decena, centena, unidadDeMil, decenaDeMil]){
    const unidad = new Numero(posision = game.at(37,12), imagen = "numero0.png")
    const decena = new Numero(posision = game.at(36,12), imagen = "numero0.png")
    const centena = new Numero(posision = game.at(35,12), imagen = "numero0.png")
    const unidadDeMil = new Numero(posision = game.at(34,12), imagen = "numero0.png")
    const decenaDeMil = new Numero(posision = game.at(33,12), imagen = "numero0.png")

    method unidad() = unidad
    method decena() = decena
    method centena() = centena
    method unidadDeMil() = unidadDeMil
    method decenaDeMil() = decenaDeMil

    method agregarVisuales(){
        game.addVisual(unidad)
        game.addVisual(decena)
        game.addVisual(centena)
        game.addVisual(unidadDeMil)
        game.addVisual(decenaDeMil)
    }
}

object lineas inherits Incrementales(contador= 0, listaNumeros = [unidad, decena, centena, unidadDeMil]){
    const unidad = new Numero(posision = game.at(37,10), imagen = "numero0.png")
    const decena = new Numero(posision = game.at(36,10), imagen = "numero0.png")
    const centena = new Numero(posision = game.at(35,10), imagen = "numero0.png")
    const unidadDeMil = new Numero(posision = game.at(34,10), imagen = "numero0.png")

    method unidad() = unidad
    method decena() = decena
    method centena() = centena
    method unidadDeMil() = unidadDeMil

    method agregarVisuales(){
        game.addVisual(unidad)
        game.addVisual(decena)
        game.addVisual(centena)
        game.addVisual(unidadDeMil)
    }
}

object nivel inherits Incrementales(contador= 1, listaNumeros = [unidad, decena]){
    const unidad = new Numero(posision = game.at(37,8), imagen = "numero1.png")
    const decena = new Numero(posision = game.at(36,8), imagen = "numero0.png")

    method unidad() = unidad
    method dcena() = decena

    method agregarVisuales(){
        game.addVisual(unidad)
        game.addVisual(decena)
    }
}
// ------- Game Over -------------------
object gameOver {
    method image() = "gameover.png"
    method position() = game.at(19, 10)
}

object visuales{
    var xNext = 32
    var yNext = 15
    var xHold = 14
    var yHold = 15
    const anchoCacillas = 3
    const altoCacillas = 4
    method agregarVisuales(){
        game.addVisual(new Fondo(posision = game.at(0,0), imagen = "fondoDiseñoIzq.png"))
        game.addVisual(new Fondo(posision = game.at(28,0), imagen = "fondoDiseñoDer.png"))
        game.addVisual(new Palabra(posision = game.at(29,12), imagen = "puntajeDiseño.png"))
        game.addVisual(new Palabra(posision = game.at(29,10), imagen = "lineasDiseño.png"))
        game.addVisual(new Palabra(posision = game.at(29,8), imagen = "nivelDiseño.png"))
        puntaje.agregarVisuales()
        lineas.agregarVisuales()
        nivel.agregarVisuales()
        game.addVisual(new Palabra(posision = game.at(29,18), imagen = "nextDiseño.png"))
        game.addVisual(new Palabra(posision = game.at(11,18), imagen = "holdDiseño.png"))

        //celdas para next y hold
        anchoCacillas.times({_=> 
            altoCacillas.times({_=>
                game.addVisual(new Palabra(posision = game.at(xNext,yNext), imagen = "celdaFondo2.jpg"))
                yNext += 1
                game.addVisual(new Palabra(posision = game.at(xHold,yHold), imagen = "celdaFondo2.jpg"))
                yHold += 1
            })
            yNext -= altoCacillas
            yHold -= altoCacillas
            xNext += 1
            xHold += 1
        })
        
    }
}

object numero{
    method mostrar(valor, listaNumeros){
        var divisor = 1
        listaNumeros.forEach({
            numero =>
            numero.image("numero" + ((valor/divisor).truncate(0) %10) + ".png")
            divisor *= 10
        })
    }
}