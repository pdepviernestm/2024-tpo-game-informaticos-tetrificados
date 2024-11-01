import wollok.game.*
class BloqueTetris{
    var xCentro //Estas variables las deberiamos cambiar si queremos editar donde aparecen por primera vez los bloques
    var yCentro
    var centro = game.at(xCentro, yCentro)
    var a //= new Pieza(position = game.at(xCentro, yCentro+1)) 
    var b //= new Pieza(position = game.at(xCentro, yCentro)) 
    var c //= new Pieza(position = game.at(xCentro, yCentro-1))
    var d //= new Pieza(position = game.at(xCentro-1, yCentro-1))

        
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
        
        if(xRotada < 0){
            return "derecha"
        }
        else if(xRotada > 9){
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

        if(xRotada < 0){
            return "derecha"
        }
        else if(xRotada > 9){
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
/*
        if([yPieza1, yPieza2, yPieza3, yPieza4].forEach({y => controlador.posEstaOcupada(x, y)})){
            //bajarlo pero sin mostrarlo
            contadorCaidaLibre++
            self.hardDrop(yPieza1-1, yPieza2-1, yPieza3-1, yPieza4-1)
        }else{
            //mostrarlo
            contadorCaidaLibre.times({
                self.caer()
            })
            contadorCaidaLibre = 0

            self.establecerEnTablero()
        }
        return 0
*/
        /*
        var yCentroProvisorio = yCentro
        var aProvisorio = new Pieza(image = a.image(), position = a.position())
        if(controlador.dirEstaLibre("abajo", [a, b, c, d])){
            //bajarlo pero sin mostrarlo
            yCentroProvisorio -= 1
            self.hardDrop()
        }else{
            //mostrarlo
            centro = game.at(xCentro, yCentroProvisorio)
            a.caer()
            b.caer()
            c.caer()
            d.caer()
            self.establecerEnTablero()
        }
        return 0
        */

        /*
        if(controlador.dirEstaLibre("abajo", [a, b, c, d])){
            self.caer()
            self.establecerEnTablero()
            self.hardDrop()
        }else{
            self.mostrar()
            return 0
        }
        */
    }	

    method establecerEnTablero(){
        controlador.ocuparPos(a.position().x(), a.position().y())
        controlador.ocuparPos(b.position().x(), b.position().y())
        controlador.ocuparPos(c.position().x(), c.position().y())
        controlador.ocuparPos(d.position().x(), d.position().y())
    }
    method decirPosiciones(){
        game.say(a, "posicion: A: " + a.position().x())
        game.say(b, "posicion: B: " + b.position().x())
        game.say(c, "posicion: C: " + c.position().x())
        game.say(d, "posicion: D: " + d.position().x())
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

class Tipo_bloqueL inherits BloqueTetris (xCentro = 5, yCentro = 21,
                                            a = new Pieza(image = "naranja.png", position = game.at(xCentro, yCentro+1)) ,
                                            b = new Pieza(image = "naranja.png", position = game.at(xCentro, yCentro)),
                                            c = new Pieza(image = "naranja.png", position = game.at(xCentro, yCentro-1)),
                                            d = new Pieza(image = "naranja.png", position = game.at(xCentro+1, yCentro-1)))
{
}


class Tipo_bloqueLinv inherits BloqueTetris(xCentro = 5, yCentro = 21,
                                            a = new Pieza(image = "azul.png", position = game.at(xCentro, yCentro+1)) ,
                                            b = new Pieza(image = "azul.png", position = game.at(xCentro, yCentro)),
                                            c = new Pieza(image = "azul.png", position = game.at(xCentro, yCentro-1)),
                                            d = new Pieza(image = "azul.png", position = game.at(xCentro-1, yCentro-1))
                                            )
{
}

class Tipo_bloqueCuadrado inherits BloqueTetris(xCentro = (5.5), yCentro = (20.5),
                                            a = new Pieza(image = "amarillo.png", position = game.at(xCentro-0.5, yCentro+0.5)) ,
                                            b = new Pieza(image = "amarillo.png", position = game.at(xCentro-0.5, yCentro-0.5)),
                                            c = new Pieza(image = "amarillo.png", position = game.at(xCentro+0.5, yCentro-0.5)),
                                            d = new Pieza(image = "amarillo.png", position = game.at(xCentro+0.5, yCentro+0.5))
                                            ){
    
}
class Tipo_bloqueLinea inherits BloqueTetris(xCentro = 5.5, yCentro = 21.5,
                                            a = new Pieza(image = "celeste.png", position = game.at(xCentro-0.5, yCentro+1.5)) ,
                                            b = new Pieza(image = "celeste.png", position = game.at(xCentro-0.5, yCentro+0.5)),
                                            c = new Pieza(image = "celeste.png", position = game.at(xCentro-0.5, yCentro-0.5)),
                                            d = new Pieza(image = "celeste.png", position = game.at(xCentro-0.5, yCentro-1.5))
                                            )
{
    
}

class Tipo_bloqueS inherits BloqueTetris(xCentro = 5, yCentro = 20,
                                            a = new Pieza(image = "verde.png", position = game.at(xCentro-1, yCentro)) ,
                                            b = new Pieza(image = "verde.png", position = game.at(xCentro, yCentro)),
                                            c = new Pieza(image = "verde.png", position = game.at(xCentro, yCentro+1)),
                                            d = new Pieza(image = "verde.png", position = game.at(xCentro+1, yCentro+1))
                                            ){
}

class Tipo_bloqueSinv inherits BloqueTetris(xCentro = 5, yCentro = 20,
                                            a = new Pieza(image = "rojo.png", position = game.at(xCentro-1, yCentro)) ,
                                            b = new Pieza(image = "rojo.png", position = game.at(xCentro, yCentro)),
                                            c = new Pieza(image = "rojo.png", position = game.at(xCentro, yCentro-1)),
                                            d = new Pieza(image = "rojo.png", position = game.at(xCentro+1, yCentro-1))
                                            ){
}

class Tipo_bloqueT inherits BloqueTetris(xCentro = 5, yCentro = 20,
                                            a = new Pieza(image = "violeta.png", position = game.at(xCentro-1, yCentro)) ,
                                            b = new Pieza(image = "violeta.png", position = game.at(xCentro, yCentro)),
                                            c = new Pieza(image = "violeta.png", position = game.at(xCentro, yCentro-1)),
                                            d = new Pieza(image = "violeta.png", position = game.at(xCentro+1, yCentro))
                                            ){
    
    
}

object controlador {

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
        [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    ]   

    method posEstaOcupada(x, y){
        if (x < 0 || x > 9 || y < 0){
            return 1
        }
        if (y > 19){
            return 0
        }

        return (matriz.get(19-y).get(x))
    }

    method ocuparPos(x, y){ //No encontre funcion que me permita cambiar una variable accediendo mediante el indice, asi que lo hice asi
        var filaEditada = matriz.get(19-y)
        //if (filaEditada.get(x) == 1){} Estaria bueno que tire un warning o algo si se intenta ocupar una posicion ya ocupada, pero no se como hacerlo
        filaEditada = filaEditada.take(x) + [1] + filaEditada.drop(x+1)  //Tener en cuenta que take(x) tomara hasta la fila x-1 y drop(x+1) tomara desde la fila x, porque cuentan la cantidad de los elementos y no los indices (la x es un indice)
        matriz = matriz.take(20-y-1) + [filaEditada] + matriz.drop(20-y) //Aca se usa 20-y en vez de 19-y por la razon explicada arriba
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
    method dirEstaLibre(dir, listaPiezas){
        if (dir == "derecha"){
            return !listaPiezas.any{p => self.posEstaOcupada(p.position().x()+1, p.position().y()) == 1} //Comprueba que todas las posiciones a la derecha no tengan nada
        }
        if (dir == "izquierda"){
            return !listaPiezas.any{p => self.posEstaOcupada(p.position().x()-1, p.position().y()) == 1} //Comprueba que todas las posiciones a la izquierda no tengan nada
        }
        if (dir == "abajo"){
            return !listaPiezas.any{p => self.posEstaOcupada(p.position().x(), p.position().y()-1) == 1} //Comprueba que todas las posiciones abajo de la misma no tengan nada
        }
        return EvaluationError
    }

}