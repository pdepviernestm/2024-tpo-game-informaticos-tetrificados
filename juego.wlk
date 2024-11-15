import wollok.game.*
import BloquesJugables.*
import controlador.*

// ------------------ Bloque de Tetris ------------------
class BloqueTetris{
    var xCentro
    var yCentro
    var centro = game.at(xCentro, yCentro)
    var centroAntesDeRotar = game.at(0, 0)
    const a 
    const b 
    const c 
    const d 
    method xCentro() = xCentro
    method yCentro() = yCentro
    method a() = a
    method b() = b
    method c() = c
    method d() = d
    const piezas = [a, b, c, d]
    method piezas() = piezas
    method centro() = centro
    
    method rotar(direccion){
        centroAntesDeRotar = centro
        piezas.forEach({pieza => pieza.guardarPosicionAntesDeRotar()})
        direccion.rotar(self)
        
        
    }
    method deshacerRotacionBloque(){
        piezas.forEach({pieza => pieza.revertirRotacion()})
        centro = centroAntesDeRotar
    }

    method mover(direccion){
        direccion.mover(self)
        centro = direccion.moverCentro(centro)
    }

    method estaEnElFondo(){//retorna T o F
        return !controlador.dirEstaLibre(abajo, [a, b, c, d])
    }

    method mostrar(){
        piezas.forEach({
            pieza =>
            game.addVisual(pieza)
        })
    }  

    method remover(){
        piezas.forEach({
            pieza =>
            game.removeVisual(pieza)
        })
    }

    method caer(){
        self.mover(abajo)
    }

    method hardDrop(sombra){
        a.asignarPosicion(sombra.a().position().x(), sombra.a().position().y())
        b.asignarPosicion(sombra.b().position().x(), sombra.b().position().y())
        c.asignarPosicion(sombra.c().position().x(), sombra.c().position().y())
        d.asignarPosicion(sombra.d().position().x(), sombra.d().position().y())
        
    }	

    method establecerEnTablero(){
        const yDeFilaCompleta = [controlador.ocuparPos(a), controlador.ocuparPos(b), controlador.ocuparPos(c), controlador.ocuparPos(d)].filter({flag => flag > -1})
        if(yDeFilaCompleta.size() > 0){ //Si hubo una linea completa que se ejecute el method quitar linea completa
            const cantidadDeLineasCompletadas = yDeFilaCompleta.size()
            var iterador = 1
            cantidadDeLineasCompletadas.times({_=>
                controlador.quitarLineaCompleta(yDeFilaCompleta.max())
                yDeFilaCompleta.remove(yDeFilaCompleta.max())
                if(iterador == 1){
                    puntaje.sumar(100)                
                } else if( iterador == 2){
                    puntaje.sumar(200) 
                } else if(iterador == 3){
                    puntaje.sumar(200)
                } else if(iterador == 4){
                    puntaje.sumar(300)
                }
                iterador += 1
            })
        }
    }

// ------------------------------- Prediccion ---------------------------------------

    method crearSombra(){
        const sombraA = new Pieza(image = "sombraFina.png", position = game.at(a.position().x(), a.position().y()))
        const sombraB = new Pieza(image = "sombraFina.png", position = game.at(b.position().x(), b.position().y()))
        const sombraC = new Pieza(image = "sombraFina.png", position = game.at(c.position().x(), c.position().y()))
        const sombraD = new Pieza(image = "sombraFina.png", position = game.at(d.position().x(), d.position().y()))
        return new Tipo_bloqueSombra(xCentro = xCentro, yCentro = yCentro, a = sombraA, b = sombraB, c = sombraC, d = sombraD)
    }
}

class Tipo_bloqueSombra inherits BloqueTetris{
    method descender(){
        if(controlador.dirEstaLibre(abajo, [a, b, c, d])){
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
    method imitarPosMov(bloque){
        a.asignarPosicion(bloque.a().position().x(), a.position().y())
        b.asignarPosicion(bloque.b().position().x(), b.position().y())
        c.asignarPosicion(bloque.c().position().x(), c.position().y())
        d.asignarPosicion(bloque.d().position().x(), d.position().y())
        xCentro = bloque.xCentro()
        if (controlador.columnasLibresApartiDePieza([a,b,c,d], [bloque.a(), bloque.b(), bloque.c(), bloque.d()]) ){
            if (!controlador.dirEstaLibre(actual, [a, b, c, d])){
                self.mover(arriba)
            } else if (controlador.dirEstaLibre(abajo, [a, b, c, d])){
                self.descender()
            }
        }else {
            a.asignarPosicion(bloque.a().position().x(), bloque.a().position().y())
            b.asignarPosicion(bloque.b().position().x(), bloque.b().position().y())
            c.asignarPosicion(bloque.c().position().x(), bloque.c().position().y())
            d.asignarPosicion(bloque.d().position().x(), bloque.d().position().y())
            if (controlador.dirEstaLibre(abajo, [a, b, c, d])){
                self.descender()
            }
        }
    }

    method imitarPosRot(bloque){
        a.asignarPosicion(bloque.a().position().x(), bloque.a().position().y()- bloque.yCentro() + yCentro)
        b.asignarPosicion(bloque.b().position().x(), bloque.b().position().y()- bloque.yCentro() + yCentro)
        c.asignarPosicion(bloque.c().position().x(), bloque.c().position().y()- bloque.yCentro() + yCentro)
        d.asignarPosicion(bloque.d().position().x(), bloque.d().position().y()- bloque.yCentro() + yCentro) //No sumar ni restar centro X
            
        if (controlador.columnasLibresApartiDePieza([a,b,c,d], [bloque.a(), bloque.b(), bloque.c(), bloque.d()])){ 
            self.irAlineaSuperior()
            if (controlador.dirEstaLibre(abajo, [a, b, c, d])){
                self.descender()
            }
        } else{
            a.asignarPosicion(bloque.a().position().x(), bloque.a().position().y())
            b.asignarPosicion(bloque.b().position().x(), bloque.b().position().y())
            c.asignarPosicion(bloque.c().position().x(), bloque.c().position().y())
            d.asignarPosicion(bloque.d().position().x(), bloque.d().position().y())
            if (controlador.dirEstaLibre(abajo, [a, b, c, d])){
                self.descender()
            }
        }
    }

    method irAlineaSuperior(){
        if (!controlador.dirEstaLibre(actual, [a, b, c, d])){
            self.mover(arriba)
            self.irAlineaSuperior()
        }
    }
}



//esto podriamos generalizarlo con clases o herencias para incluir al bloque linea

// ----------------------------- Piezas ------------------------------------
class Pieza{//un "pixel" del bloque de tetris
    var position
    const image
    var positionAntesDeRotar = game.at(0, 0)


    method image() = image

    method asignarPosicion(x, y){
        position = game.at(x, y)
    }
    method position() = position

    method guardarPosicionAntesDeRotar(){
        positionAntesDeRotar = position
    }

    method revertirRotacion(){
        position = positionAntesDeRotar
    }

    method up(){
        position = game.at(position.x(), position.y() + 1)
    }

    method caer(){
        position = game.at(position.x(), position.y()-1)
    }

    method right(){
        position = game.at(position.x()+1, position.y())
    }

    method left(){
        position = game.at(position.x()-1, position.y() + 1)
    }

}



// -------------------- VISUAL --------------------------------
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


class DireccionLibre{
    const modifX
    const modifY
    method dirEstaLibre(listaPiezas){ //true si dir esta libre, false si no lo esta
        return !listaPiezas.any{pieza => controlador.posEstaOcupada(pieza.position().x() + modifX, pieza.position().y() + modifY) == 1}
    }
}
class AccionesConDir inherits DireccionLibre{
    method mover(bloque){
        if (controlador.dirEstaLibre(self, bloque.piezas())){
            bloque.piezas().forEach({
                pieza =>
                pieza.asignarPosicion(pieza.position().x() + modifX, pieza.position().y() + modifY)
            })
        }
    }
    method moverCentro(centroBloque){
        return game.at(centroBloque.x() + modifX, centroBloque.y() + modifY)
    }
}
class RotarConSentido{
    const xRotacion = 0
    const yRotacion = 0
    
  method rotarDireccion(pieza, centro, xOrientacion, yOrientacion){ //si x = -1 e y = 1 entonces horaria, si x = 1 e y = -1 entonces antihoraria
        //le restamos el centro a la pieza
        var xRotada = pieza.position().x()-centro.x() //La coordenada x de la pieza
        var yRotada = pieza.position().y()-centro.y() //La coordenada y de la pieza
        //intercambiamos las coordenadas x'=y, y'=-x
        const aux = xRotada
        xRotada = yOrientacion * yRotada
        yRotada = xOrientacion * (aux)
        //le sumamos el centro de vuelta
        xRotada += centro.x() 
        yRotada += centro.y() 
        //retornamos si la posicion rotada
        return game.at(xRotada, yRotada)
    }

    method rotar(bloque){ //Retorna TRUE si se pudo rotar, FALSE si no se pudo
        var listaPosRotadas = bloque.piezas().map({pieza => self.rotarDireccion(pieza, bloque.centro(), xRotacion, yRotacion)})
        
        // Caso borde derecha:si al rotar se va del limite por derecha
        if (listaPosRotadas.any({posRotada => posRotada.x() > constsGlobales.paredDerTablero()})){ 
            //Si se puede move a derecha, que se mueva e intente rotar nuevamente. 
            //Si no se puede mover a derecha, entonces no hay lugar para que rote, por lo tanto no rotara
            if (controlador.dirEstaLibre(izquierda, bloque.piezas())){
                bloque.mover(izquierda)
                bloque.rotar(self)
            }else {
                bloque.deshacerRotacionBloque()
            }
        
        // Caso borde izquierda:si al rotar se va del limite por izquierda
        }else if (listaPosRotadas.any({posRotada => posRotada.x() < constsGlobales.paredIzqTablero()})){
            //Si se puede move a izquierda, que se mueva e intente rotar nuevamente. 
            //Si no se puede mover a izquierda, entonces no hay lugar para que rote, por lo tanto no rotara
            if (controlador.dirEstaLibre(derecha, bloque.piezas())){
                bloque.mover(derecha)
                bloque.rotar(self)
            }else{
                bloque.deshacerRotacionBloque()
            }
        
        // Caso rotacion libre: si al rotar no hay obstaculos
        }else if(listaPosRotadas.all( {posRotada => controlador.posEstaOcupada(posRotada.x(), posRotada.y()) == 0 })){
            bloque.piezas().forEach({pieza => 
                pieza.asignarPosicion(listaPosRotadas.head().x(), listaPosRotadas.head().y()) //se asume pos rotada
                listaPosRotadas = listaPosRotadas.drop(1)
            })
        }
        else{
            bloque.deshacerRotacionBloque()
        }
    }
}

object derecha inherits AccionesConDir(modifX = 1, modifY = 0){}
object izquierda inherits AccionesConDir(modifX = -1, modifY = 0){}
object abajo inherits AccionesConDir(modifX = 0, modifY = -1){}
object arriba inherits AccionesConDir(modifX = 0, modifY = 1){}
object actual inherits DireccionLibre(modifX = 0, modifY = 0){}

object horaria inherits RotarConSentido(xRotacion = -1, yRotacion = 1){}
object antihoraria inherits RotarConSentido(xRotacion = 1, yRotacion = -1){}

object constsGlobales{
    const property paredIzqTablero = 18
    const property paredDerTablero = 27
    const property posicionPosible = -1
    const property posicionNoEsPosible = -2

    method indEnTab(xCoord) = xCoord - paredIzqTablero
}

