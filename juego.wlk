import wollok.game.*
class BloqueTetris{ //Tengo dudas de donde deberiamos declarar las piezas del bloque de tetris
    var xCentro //Estas variables las deberiamos cambiar si queremos editar donde aparecen por primera vez los bloques
    var yCentro
    var centro = game.at(xCentro, yCentro)
    var a //= new Pieza(position = game.at(xCentro, yCentro+1)) 
    var b //= new Pieza(position = game.at(xCentro, yCentro)) 
    var c //= new Pieza(position = game.at(xCentro, yCentro-1))
    var d //= new Pieza(position = game.at(xCentro-1, yCentro-1))
        
    method rotar(dir){
        if (dir == "derecha"){
            self.rotarHoraria(a)
            self.rotarHoraria(b)
            self.rotarHoraria(c)
            self.rotarHoraria(d)

        }else{
            self.rotarAntiHoraria(a)
            self.rotarAntiHoraria(b)
            self.rotarAntiHoraria(c)
            self.rotarAntiHoraria(d)
        }
    }
    //AGREGAR QUE NO SE VAYA DE LOS LIMITES DEL TABLERO CUANDO GIRA CERCA DE LOS BORDES

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
        //asignamos la posicion rotada a la pieza
        pieza.asignarPosicion(xRotada, yRotada)
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
        //asignamos la posicion rotada a la pieza
        pieza.asignarPosicion(xRotada, yRotada)
    }
    
    method mover(dir){
        if ((dir == "derecha" && [a,b,c,d].all{p => p.position().x() < 9})){ 
            xCentro += 1
            centro = game.at(xCentro, yCentro)
            a.asignarPosicion(a.position().x()+1, a.position().y())
            b.asignarPosicion(b.position().x()+1, b.position().y())
            c.asignarPosicion(c.position().x()+1, c.position().y())
            d.asignarPosicion(d.position().x()+1, d.position().y())
        }
        if (dir == "izquierda" && [a,b,c,d].all{p => p.position().x() > 0})
        {
            xCentro -= 1
            centro = game.at(xCentro, yCentro)
            a.asignarPosicion(a.position().x()-1, a.position().y())
            b.asignarPosicion(b.position().x()-1, b.position().y())
            c.asignarPosicion(c.position().x()-1, c.position().y())
            d.asignarPosicion(d.position().x()-1, d.position().y())
        }
    }

    method mostrar(){
        game.addVisual(a)
        game.addVisual(b)
        game.addVisual(c)
        game.addVisual(d)
    }

    method caer(){
        yCentro -= 1
        centro = game.at(xCentro, yCentro)
        a.caer()
        b.caer()
        c.caer()
        d.caer()
    }

    method estaEnElFondo(){//retorna T o F
        return [a,b,c,d].any{p => p.position().y() == 0}
    }
}

//esto podriamos generalizarlo con clases o herencias para incluir al bloque linea

class Pieza{//un "pixel" del bloque de tetris
    var position
    const image

    

    method image() = image

    method asignarPosicion(x, y){
        position = game.at(x, y)
    }
    method position() = position

    method caer(){
        position = game.at(position.x(), position.y()-1)
    }

}

class Tipo_bloqueL inherits BloqueTetris (xCentro = 5, yCentro = 21,
                                            a = new Pieza(image = "naranja.png", position = game.at(xCentro, yCentro+1)) ,
                                            b = new Pieza(image = "naranja.png", position = game.at(xCentro, yCentro)),
                                            c = new Pieza(image = "naranja.png", position = game.at(xCentro, yCentro-1)),
                                            d = new Pieza(image = "naranja.png", position = game.at(xCentro+1, yCentro-1)))
{
}


class Tipo_bloqueLinv inherits BloqueTetris(xCentro = 5, yCentro = 10,
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

