import wollok.game.*
import BloquesJugables.*
import controlador.*
class BloqueTetris{
    var xCentro
    var yCentro
    var centro = game.at(xCentro, yCentro)
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

    method rotar(dir){    
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
                const dirLejosDePared = listaValoresReturn.filter({valorReturn => valorReturn != 1 && valorReturn != 0}).head()
                if(controlador.dirEstaLibre(dirLejosDePared, [a, b, c, d])){
                    self.mover(dirLejosDePared)// Se mueve 1 casilla lejos de la pared lateral
                    self.rotar("derecha") //Intenta rotar nuevamente
                }
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
                const dirLejosDePared = listaValoresReturn.filter({valorReturn => valorReturn != 1 && valorReturn != 0}).head()
                if(controlador.dirEstaLibre(dirLejosDePared, [a, b, c, d])){
                    self.mover(dirLejosDePared)// Se mueve 1 casilla lejos de la pared lateral
                    self.rotar("izquierda") //Intenta rotar nuevamente
                }
            }
        }
    }

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

    method estaEnElFondo(){//retorna T o F
        return !controlador.dirEstaLibre("abajo", [a, b, c, d])
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
        const yDeFilaCompleta = [controlador.ocuparPos(a), controlador.ocuparPos(b), controlador.ocuparPos(c), controlador.ocuparPos(d)].filter({flag => flag > -1})
        if(yDeFilaCompleta.size() > 0){ //Si hubo una linea completa que se ejecute el method quitar linea completa
            const cantidadDeLineasCompletadas = yDeFilaCompleta.size()
            cantidadDeLineasCompletadas.times({_=>
                controlador.quitarLineaCompleta(yDeFilaCompleta.max())
                yDeFilaCompleta.remove(yDeFilaCompleta.max())
            })
        }
    }


    method crearSombra(){
        const sombraA = new Pieza(image = "sombraFina.png", position = game.at(a.position().x(), a.position().y()))
        const sombraB = new Pieza(image = "sombraFina.png", position = game.at(b.position().x(), b.position().y()))
        const sombraC = new Pieza(image = "sombraFina.png", position = game.at(c.position().x(), c.position().y()))
        const sombraD = new Pieza(image = "sombraFina.png", position = game.at(d.position().x(), d.position().y()))
        return new Tipo_bloqueSombra(xCentro = xCentro, yCentro = yCentro, a = sombraA, b = sombraB, c = sombraC, d = sombraD)
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

