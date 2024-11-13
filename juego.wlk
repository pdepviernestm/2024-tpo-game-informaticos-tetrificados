import wollok.game.*
import BloquesJugables.*
import controlador.*

// ------------------ Bloque de Tetris ------------------
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

// -------------------- Rotacion ------------------------

    method rotar(dir){    
        if (dir == "derecha"){
            const listaValoresReturn = [self.rotarHoraria(a), self.rotarHoraria(b), self.rotarHoraria(c), self.rotarHoraria(d)]
            if (listaValoresReturn.all( {valorReturn => valorReturn == 0})){
                a.asumirPosicionRotada()
                b.asumirPosicionRotada()
                c.asumirPosicionRotada()
                d.asumirPosicionRotada()
            }
            else if(!listaValoresReturn.any({valorReturn => valorReturn == 1})){ 
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
            else if(!listaValoresReturn.any({valorReturn => valorReturn == 1})){ 
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
// ------------------ Mover -----------------------  
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
        if (dir == "arriba"){
            yCentro +=1
            centro = game.at(xCentro, yCentro)
            a.asignarPosicion(a.position().x(), a.position().y()+1)
            b.asignarPosicion(b.position().x(), b.position().y()+1)
            c.asignarPosicion(c.position().x(), c.position().y()+1)
            d.asignarPosicion(d.position().x(), d.position().y()+1)
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
// --------------------------- HardDrop ----------------------------

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
                if(iterador < 3){
                    controlador.actualizarPuntaje(100)
                } else if(iterador == 3){
                    controlador.actualizarPuntaje(200)
                } else if(iterador == 4){
                    controlador.actualizarPuntaje(400)
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
    method imitarPosMov(bloque){
        a.asignarPosicion(bloque.a().position().x(), a.position().y())
        b.asignarPosicion(bloque.b().position().x(), b.position().y())
        c.asignarPosicion(bloque.c().position().x(), c.position().y())
        d.asignarPosicion(bloque.d().position().x(), d.position().y())
        xCentro = bloque.xCentro()
        if (controlador.columnasLibresApartiDePieza([a,b,c,d], [bloque.a(), bloque.b(), bloque.c(), bloque.d()]) ){
            if (!controlador.dirEstaLibre("actual", [a, b, c, d])){
                self.mover("arriba")
            } else if (controlador.dirEstaLibre("abajo", [a, b, c, d])){
                self.descender()
            }
        }else {
            a.asignarPosicion(bloque.a().position().x(), bloque.a().position().y())
            b.asignarPosicion(bloque.b().position().x(), bloque.b().position().y())
            c.asignarPosicion(bloque.c().position().x(), bloque.c().position().y())
            d.asignarPosicion(bloque.d().position().x(), bloque.d().position().y())
            if (controlador.dirEstaLibre("abajo", [a, b, c, d])){
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
            if (controlador.dirEstaLibre("abajo", [a, b, c, d])){
                self.descender()
            }
        } else{
            a.asignarPosicion(bloque.a().position().x(), bloque.a().position().y())
            b.asignarPosicion(bloque.b().position().x(), bloque.b().position().y())
            c.asignarPosicion(bloque.c().position().x(), bloque.c().position().y())
            d.asignarPosicion(bloque.d().position().x(), bloque.d().position().y())
            if (controlador.dirEstaLibre("abajo", [a, b, c, d])){
                self.descender()
            }
        }
    }

    method irAlineaSuperior(){
        if (!controlador.dirEstaLibre("actual", [a, b, c, d])){
            self.mover("arriba")
            self.irAlineaSuperior()
        }
    }
}



//esto podriamos generalizarlo con clases o herencias para incluir al bloque linea

// ----------------------------- Piezas ------------------------------------
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

