import wollok.game.*
class BloqueTetris{
    var xCentro //Estas variables las deberiamos cambiar si queremos editar donde aparecen por primera vez los bloques
    var yCentro
 
    var centro = game.at(xCentro, yCentro)
    const a 
    const b 
    const c 
    const d 

        
    method rotar(dir){ //Hacerlo Asi, seria precalculo?    
        if (dir == "derecha"){
            const listaValoresReturn = [self.rotarHoraria(a), self.rotarHoraria(b), self.rotarHoraria(c), self.rotarHoraria(d)]
            if (listaValoresReturn.all( {valorReturn => valorReturn == 0})){
                a.asumirPosicionRotada()
                b.asumirPosicionRotada()
                c.asumirPosicionRotada()
                d.asumirPosicionRotada()
            }
            else if(listaValoresReturn.any({valorReturn => valorReturn == 1})){ 
                return
            }
            else{
                self.mover(listaValoresReturn.filter({valorReturn => valorReturn != 1 && valorReturn != 0}).head())// Se mueve 1 casilla lejos de la pared lateral
                self.rotar("derecha") //Intenta rotar nuevamente
            }

        }else{
            const listaValoresReturn = [self.rotarAntiHoraria(a), self.rotarAntiHoraria(b), self.rotarAntiHoraria(c), self.rotarAntiHoraria(d)]
            if (listaValoresReturn.any({valorReturn => valorReturn})){
                a.asumirPosicionRotada()
                b.asumirPosicionRotada()
                c.asumirPosicionRotada()
                d.asumirPosicionRotada()
            }
            else if(listaValoresReturn.any({valorReturn => valorReturn == 1})){ 
                return
            }
            else{
                if(controlador.dirEstaLibre(dir, [a, b, c, d])){
                    self.mover(listaValoresReturn.filter({valorReturn => valorReturn != 1 && valorReturn != 0}).head())// Se mueve 1 casilla lejos de la pared lateral
                    self.rotar("izquierda") //Intenta rotar nuevamente
                }
            }//HAY UN CASO EN EL QUE ESTO NO FUNCIONA, FIJARSE EN CUADERNO (Mateo)
        }
    }

    // Las agrego aca ya que todas los bloques de tetris van a ser rotables
    method rotarHoraria(pieza){
        //le restamos el centro a la pieza
        var xRotada = pieza.position().x()-centro.x() //La coordenada x de la pieza
        var yRotada = pieza.position().y()-centro.y() //La coordenada y de la pieza
        //intercambiamos las coordenadas x'=y, y'=-x
        const aux = xRotada
        xRotada = yRotada
        yRotada = -(aux)
        //le sumamos el centro de vuelta
        xRotada += centro.x() 
        yRotada += centro.y() 
        
        if(xRotada < 18){
            return "derecha"
        }
        else if(xRotada > 27){
            return "izquierda"
        }
        else{
            //guardamos la posicion rotada a la pieza
            pieza.guardarPosicionRotada(xRotada, yRotada)
            //retornamos si la posicion rotada esta ocupada o no (es decir si esa pieza puede girar o no)
            return controlador.posEstaOcupada(xRotada, yRotada)
        }
    }

    method rotarAntiHoraria(pieza){
        //le restamos el centro a la pieza
        var xRotada = pieza.position().x()-centro.x() //La coordenada x de la pieza
        var yRotada = pieza.position().y()-centro.y() //La coordenada y de la pieza
        //intercambiamos las coordenadas x'=-y, y'=x
        const aux = xRotada
        xRotada = -(yRotada)
        yRotada = aux
        //le sumamos el centro de vuelta
        xRotada += centro.x()
        yRotada += centro.y()

        if(xRotada < 18){
            return "derecha"
        }
        else if(xRotada > 27){
            return "izquierda"
        }
        else{
            //guardamos la posicion rotada a la pieza
            pieza.guardarPosicionRotada(xRotada, yRotada)
            //retornamos si la posicion rotada esta ocupada o no (es decir si esa pieza puede girar o no)
            return controlador.posEstaOcupada(xRotada, yRotada)
        }
    }
    
    method mover(dir){
        if (dir == "derecha" && controlador.dirEstaLibre("derecha", [a, b, c, d])){ 
            xCentro += 1
            centro = game.at(xCentro, yCentro)
            a.asignarPosicion(a.position().x()+1, a.position().y())
            b.asignarPosicion(b.position().x()+1, b.position().y())
            c.asignarPosicion(c.position().x()+1, c.position().y())
            d.asignarPosicion(d.position().x()+1, d.position().y())
        }
        if (dir == "izquierda" && controlador.dirEstaLibre("izquierda", [a, b, c, d]))
        {
            xCentro -= 1
            centro = game.at(xCentro, yCentro)
            a.asignarPosicion(a.position().x()-1, a.position().y())
            b.asignarPosicion(b.position().x()-1, b.position().y())
            c.asignarPosicion(c.position().x()-1, c.position().y())
            d.asignarPosicion(d.position().x()-1, d.position().y())
        }
        if (dir == "abajo" && controlador.dirEstaLibre("abajo", [a, b, c, d]) ){
            yCentro -= 1
            centro = game.at(xCentro, yCentro)
            a.caer()
            b.caer()
            c.caer()
            d.caer()
        }
    }

    method mostrar(){
            game.addVisual(a)
            game.addVisual(b)
            game.addVisual(c)
            game.addVisual(d)
    }  

    method remover(){
        game.removeVisual(a)
        game.removeVisual(b)
        game.removeVisual(c)
        game.removeVisual(d)
    }

    method caer(){
        self.mover("abajo")
    }

    method estaEnElFondo(){//retorna T o F
        return !controlador.dirEstaLibre("abajo", [a, b, c, d])
    }

    method hardDrop(){
        if(controlador.dirEstaLibre("abajo", [a, b, c, d])){
            self.caer()
            self.hardDrop()
        }else{
            self.establecerEnTablero()
        }
        return 0
    }	

    method establecerEnTablero(){
        controlador.ocuparPos2(a.position().x(), a.position().y(), a)//pasarlo como una unica posision
        controlador.ocuparPos2(b.position().x(), b.position().y(), b)
        controlador.ocuparPos2(c.position().x(), c.position().y(), c)
        controlador.ocuparPos2(d.position().x(), d.position().y(), d)
    }

    method xCentro() = xCentro
    method yCentro() = yCentro
    method a() = a
    method b() = b
    method c() = c
    method d() = d

    method crearSombra(){
        const sombraA = new Pieza(image = "sombraFina.png", position = game.at(a.position().x(), a.position().y()))
        const sombraB = new Pieza(image = "sombraFina.png", position = game.at(b.position().x(), b.position().y()))
        const sombraC = new Pieza(image = "sombraFina.png", position = game.at(c.position().x(), c.position().y()))
        const sombraD = new Pieza(image = "sombraFina.png", position = game.at(d.position().x(), d.position().y()))
        return new Tipo_bloqueSombra(xCentro = xCentro, yCentro = yCentro, a = sombraA, b = sombraB, c = sombraC, d = sombraD)
    }
}

class BloqueJugable inherits BloqueTetris{
    const xCentroTablero
    const yCentroTablero
    const xCentroHold
    const yCentroHold

    method entrarEnTablero(){
        a.asignarPosicion((xCentro-a.position().x())+xCentroTablero, (yCentro-a.position().y())+yCentroTablero)
        b.asignarPosicion((xCentro-b.position().x())+xCentroTablero, (yCentro-b.position().y())+yCentroTablero)
        c.asignarPosicion((xCentro-c.position().x())+xCentroTablero, (yCentro-c.position().y())+yCentroTablero)
        d.asignarPosicion((xCentro-d.position().x())+xCentroTablero, (yCentro-d.position().y())+yCentroTablero)
        xCentro = xCentroTablero
        yCentro = yCentroTablero
    }

    method entrarEnHold(){
        a.asignarPosicion((xCentro-a.position().x())+xCentroHold, (yCentro-a.position().y())+yCentroHold)
        b.asignarPosicion((xCentro-b.position().x())+xCentroHold, (yCentro-b.position().y())+yCentroHold)
        c.asignarPosicion((xCentro-c.position().x())+xCentroHold, (yCentro-c.position().y())+yCentroHold)
        d.asignarPosicion((xCentro-d.position().x())+xCentroHold, (yCentro-d.position().y())+yCentroHold)
        xCentro = xCentroHold
        yCentro = yCentroHold
    }

}

//esto podriamos generalizarlo con clases o herencias para incluir al bloque linea

class Pieza{//un "pixel" del bloque de tetris
    var position
    const image
    var xRotada = 0
    var yRotada = 0

    method image() = image

    method asignarPosicion(x, y){
        position = game.at(x, y)
    }
    method position() = position

    method caer(){
        position = game.at(position.x(), position.y()-1)
    }

    method guardarPosicionRotada(x, y){
        xRotada = x
        yRotada = y
    }

    method asumirPosicionRotada(){
        position = game.at(xRotada, yRotada)
    }

}

class Tipo_bloqueL inherits BloqueJugable (xCentro = 32, yCentro = 16, xCentroTablero = 23, yCentroTablero = 21, xCentroHold = 15, yCentroHold = 16,
                                            a = new Pieza(image = "naranja.png", position = game.at(xCentro, yCentro+1)) ,
                                            b = new Pieza(image = "naranja.png", position = game.at(xCentro, yCentro)),
                                            c = new Pieza(image = "naranja.png", position = game.at(xCentro, yCentro-1)),
                                            d = new Pieza(image = "naranja.png", position = game.at(xCentro+1, yCentro-1)))
{
}


class Tipo_bloqueLinv inherits BloqueJugable(xCentro = 33, yCentro = 16, xCentroTablero = 23, yCentroTablero = 21, xCentroHold = 15, yCentroHold = 16,
                                            a = new Pieza(image = "azul.png", position = game.at(xCentro, yCentro+1)) ,
                                            b = new Pieza(image = "azul.png", position = game.at(xCentro, yCentro)),
                                            c = new Pieza(image = "azul.png", position = game.at(xCentro, yCentro-1)),
                                            d = new Pieza(image = "azul.png", position = game.at(xCentro-1, yCentro-1))
                                            )
{
}

class Tipo_bloqueCuadrado inherits BloqueJugable(xCentro = (32.5), yCentro = (15.5),xCentroTablero = 22.5, yCentroTablero = 20.5, xCentroHold = 14.5, yCentroHold = 15.5,
                                            a = new Pieza(image = "amarillo.png", position = game.at(xCentro-0.5, yCentro+0.5)) ,
                                            b = new Pieza(image = "amarillo.png", position = game.at(xCentro-0.5, yCentro-0.5)),
                                            c = new Pieza(image = "amarillo.png", position = game.at(xCentro+0.5, yCentro-0.5)),
                                            d = new Pieza(image = "amarillo.png", position = game.at(xCentro+0.5, yCentro+0.5))
                                            )
{
}
class Tipo_bloqueLinea inherits BloqueJugable(xCentro = 33.5, yCentro = 16.5, xCentroTablero = 22.5, yCentroTablero = 21.5, xCentroHold = 15.5, yCentroHold = 16.5,
                                            a = new Pieza(image = "celeste.png", position = game.at(xCentro-0.5, yCentro+1.5)) ,
                                            b = new Pieza(image = "celeste.png", position = game.at(xCentro-0.5, yCentro+0.5)),
                                            c = new Pieza(image = "celeste.png", position = game.at(xCentro-0.5, yCentro-0.5)),
                                            d = new Pieza(image = "celeste.png", position = game.at(xCentro-0.5, yCentro-1.5))
                                            )
{
}

class Tipo_bloqueS inherits BloqueJugable(xCentro = 33, yCentro = 15, xCentroTablero = 23, yCentroTablero = 20, xCentroHold = 15, yCentroHold = 15,
                                            a = new Pieza(image = "verde.png", position = game.at(xCentro-1, yCentro)) ,
                                            b = new Pieza(image = "verde.png", position = game.at(xCentro, yCentro)),
                                            c = new Pieza(image = "verde.png", position = game.at(xCentro, yCentro+1)),
                                            d = new Pieza(image = "verde.png", position = game.at(xCentro+1, yCentro+1))
                                            )
{
}

class Tipo_bloqueSinv inherits BloqueJugable(xCentro = 33, yCentro = 16,xCentroTablero = 23, yCentroTablero = 20, xCentroHold = 15, yCentroHold = 16,
                                            a = new Pieza(image = "rojo.png", position = game.at(xCentro-1, yCentro)) ,
                                            b = new Pieza(image = "rojo.png", position = game.at(xCentro, yCentro)),
                                            c = new Pieza(image = "rojo.png", position = game.at(xCentro, yCentro-1)),
                                            d = new Pieza(image = "rojo.png", position = game.at(xCentro+1, yCentro-1))
                                            )
{
}

class Tipo_bloqueT inherits BloqueJugable(xCentro = 33, yCentro = 16, xCentroTablero = 23, yCentroTablero = 20, xCentroHold = 15, yCentroHold = 16,
                                            a = new Pieza(image = "violeta.png", position = game.at(xCentro-1, yCentro)) ,
                                            b = new Pieza(image = "violeta.png", position = game.at(xCentro, yCentro)),
                                            c = new Pieza(image = "violeta.png", position = game.at(xCentro, yCentro-1)),
                                            d = new Pieza(image = "violeta.png", position = game.at(xCentro+1, yCentro))
                                            )
{    
}

class Tipo_bloqueSombra inherits BloqueTetris(){
    method descender(){
        if(controlador.dirEstaLibre("abajo", [a, b, c, d])){
            self.caer()
            self.descender()
        }
    }
    method eliminar(){
        game.removeVisual(a)
        game.removeVisual(b)
        game.removeVisual(c)
        game.removeVisual(d)
    }
    method imitarPos(bloque){
        a.asignarPosicion(bloque.a().position().x(), bloque.a().position().y())
        b.asignarPosicion(bloque.b().position().x(), bloque.b().position().y())
        c.asignarPosicion(bloque.c().position().x(), bloque.c().position().y())
        d.asignarPosicion(bloque.d().position().x(), bloque.d().position().y())
        if (!controlador.dirEstaLibre("actual", [a, b, c, d])){
            self.mover("arriba")
        } else if (controlador.dirEstaLibre("abajo", [a, b, c, d])){
            self.descender()
        }
    }
}

object controlador {
    var finjuego = false
    var matriz = [ //Para acceder a indice usar coordenada 19-y, asi fila inferior es y = 0 y la superior es y = 19
        [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    ]   

    method posEstaFueraDeTablero(x, y) {
        return (x < 18 || x > 27 || y < 0)
    }

    method posEstaOcupada(x, y){
        if (x < 18 || x > 27 || y < 0){
            return 1
        }
        if (y > 19){
            return 0
        }

        return (matriz.get(19-y).get(x-18))
    }

    method ocuparPos(x, y){ //No encontre funcion que me permita cambiar una variable accediendo mediante el indice, asi que lo hice asi
        if(y > 19 ){
            if (!finjuego){
                finjuego = true
                self.perder()
            }
        }else{
            var filaEditada = matriz.get(19-y)
            //if (filaEditada.get(x) == 1){} Estaria bueno que tire un warning o algo si se intenta ocupar una posicion ya ocupada, pero no se como hacerlo
            filaEditada = filaEditada.take(x-18) + [1] + filaEditada.drop(x-18+1)  //Tener en cuenta que take(x) tomara hasta la fila x-1 y drop(x+1) tomara desde la fila x, porque cuentan la cantidad de los elementos y no los indices (la x es un indice)
            matriz = matriz.take(20-y-1) + [filaEditada] + matriz.drop(20-y) //Aca se usa 20-y en vez de 19-y por la razon explicada arriba
        }
    }

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
    method dirEstaLibreBORRAR(dir, listaPiezas){
        if (dir == "derecha"){
            return !listaPiezas.any{p => self.posEstaOcupada(p.position().x()+1, p.position().y()) == 1} //Comprueba que todas las posiciones a la derecha no tengan nada
        }
        if (dir == "izquierda"){
            return !listaPiezas.any{p => self.posEstaOcupada(p.position().x()-1, p.position().y()) == 1} //Comprueba que todas las posiciones a la izquierda no tengan nada
        }
        if (dir == "abajo"){
            return !listaPiezas.any{p => self.posEstaOcupada(p.position().x(), p.position().y()-1) == 1} //Comprueba que todas las posiciones abajo de la misma no tengan nada
        }
        if (dir == "arriba"){
            return !listaPiezas.any{p => self.posEstaOcupada(p.position().x(), p.position().y()+1) == 1} //Comprueba que todas las posiciones arriba de la misma no tengan nada
        }
        if (dir == "actual"){
            return !listaPiezas.any{p => self.posEstaOcupada(p.position().x(), p.position().y()) == 1} //Comprueba que todas las posiciones de la misma no tengan nada
        }
        return EvaluationError
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

    var contadoresDeLineaCompleta = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0] //Se suma 1 cada vez que se ocupa un lugar de su fila, hay 1 contador por cada fila
    const matriz2 = [ //Para acceder a indice usar coordenada 19-y, asi fila inferior es y = 0 y la superior es y = 19
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

    method posEstaOcupada2(x, y){
        if (x < 18 || x > 27 || y < 0){
            return 1
        }
        if (y > 19){
            return 0
        }
        if (matriz2.get(19-y).get(x-18).pieza() != null){
            return 1
        }
        return 0
    }

    method ocuparPos2(x, y, pieza){
        if(y > 19){
             if (!finjuego){
                finjuego = true
                self.perder()
            }
        }else{
            matriz2.get(19-y).get(x-18).pieza(pieza)
            contadoresDeLineaCompleta = contadoresDeLineaCompleta.take(y) +[(contadoresDeLineaCompleta.get(y))+1] + contadoresDeLineaCompleta.drop(y+1)
            if (contadoresDeLineaCompleta.get(y) == 10){
                self.eliminarLinea(19-y)
                contadoresDeLineaCompleta.remove(10)
                contadoresDeLineaCompleta.add(0)
            }
        }
    }

    method dirEstaLibre(dir, listaPiezas){
        if (dir == "derecha"){
            return !listaPiezas.any{p => self.posEstaOcupada2(p.position().x()+1, p.position().y()) == 1}
        }
        if (dir == "izquierda"){
            return !listaPiezas.any{p => self.posEstaOcupada2(p.position().x()-1, p.position().y()) == 1}
        }
        if (dir == "abajo"){
            return !listaPiezas.any{p => self.posEstaOcupada2(p.position().x(), p.position().y()-1) == 1} 
        }
        if (dir == "arriba"){
            return !listaPiezas.any{p => self.posEstaOcupada2(p.position().x(), p.position().y()+1) == 1}
        }
        if (dir == "actual"){
            return !listaPiezas.any{p => self.posEstaOcupada2(p.position().x(), p.position().y()) == 1}
        }
        return EvaluationError
    }
/* No se usaria
    method verificarLineasCompletas(fila){
        var cantLineasCompletas = 0
        
        if (cantLineasCompletas < 4){//por como es el juego nunca se pueden eliminar mas de 4 filas a la vez, entonces evito seguir verificando por lineas completas
                if (matriz2.get(fila).all({elemento => elemento.pieza() != null})){
                    cantLineasCompletas += 1
                    self.eliminarLinea(fila)
                }
        }
        fila -= 1
        if (fila>=0){
            self.verificarLineasCompletas()
        }
        
        fila = 19
        return
    }
*/  var columna = 0
    method eliminarLinea(indexLinea){
        game.removeVisual(matriz2.get(indexLinea).get(columna).pieza())
        matriz2.get(indexLinea).get(columna).pieza(null)
        columna += 1
        if (columna < 10){
            self.eliminarLinea(indexLinea)
        }
        columna = 0
        self.bajarLineas(indexLinea)
    }


    method bajarLineas(indexLinea){//recibe el indice (de la matriz) de la fila que se elimino
        var listaAuxiliar = []
        var contadorLineas= indexLinea

        indexLinea.times({
            _=>
            
            // Copiar las piezas de la fila superior a la lista auxiliar
            matriz2.get(contadorLineas+1).forEach({elemento => listaAuxiliar.add(elemento.pieza())})

            // Asignar las piezas de la lista auxiliar a la fila actual
            matriz2.get(contadorLineas).forEach({
                elemento => 
                elemento.pieza(listaAuxiliar.head())
                listaAuxiliar = listaAuxiliar.drop(1)
                if(elemento.pieza() != null){                   
                    elemento.pieza().caer() //actualizamos la posision real (visual) de la pieza
                }
            
            })

            contadorLineas -= 1
        })
    }

}

object gameOver {
    method image() = "gameover.png"
    method position() = game.at(19, 10)
}

class Fondo{
    const posision
    const imagen
    method image() = imagen
    method position() = posision
}

class Palabra{
    const posision
    const imagen
    method image() = imagen
    method position() = posision
}

class Numero{
    const posision
    var imagen
    method image() = imagen
    method image(nuevaImagen){imagen = nuevaImagen} 
    method position() = posision
}

class ElementoMatriz{
    var pieza = null
    method pieza() = pieza
    method pieza(nuevaPieza){pieza = nuevaPieza}
}