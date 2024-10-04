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
            self.rotarHoraria(centro)
            self.rotarHoraria(c)
            self.rotarHoraria(d)

        }else{
            self.rotarAntiHoraria(a)
            self.rotarAntiHoraria(centro)
            self.rotarAntiHoraria(c)
            self.rotarAntiHoraria(d)
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
}

class Tipo_bloqueLinv inherits BloqueTetris(xCentro = 1, yCentro = 1,
                                            a = new Pieza(image = "naranja.png", position = game.at(xCentro, yCentro+1)) ,
                                            b = new Pieza(image = "naranja.png", position = game.at(xCentro, yCentro)),
                                            c = new Pieza(image = "naranja.png", position = game.at(xCentro, yCentro-1)),
                                            d = new Pieza(image = "naranja.png", position = game.at(xCentro-1, yCentro-1))
                                            )
{
}

object tipo_bloqueCuadrado inherits BloqueTetris(xCentro = (0.5), yCentro = (0.5),
                                            a = new Pieza(image = "naranja.png", position = game.at(xCentro-0.5, yCentro+0.5)) ,
                                            b = new Pieza(image = "naranja.png", position = game.at(xCentro-0.5, yCentro-0.5)),
                                            c = new Pieza(image = "naranja.png", position = game.at(xCentro+0.5, yCentro-0.5)),
                                            d = new Pieza(image = "naranja.png", position = game.at(xCentro+0.5, yCentro+0.5))
                                            ){
    
}
object tipo_bloqueLinea inherits BloqueTetris(xCentro = 1, yCentro = 1.5,
                                            a = new Pieza(image = "naranja.png", position = game.at(xCentro, yCentro+1.5)) ,
                                            b = new Pieza(image = "naranja.png", position = game.at(xCentro, yCentro+0.5)),
                                            c = new Pieza(image = "naranja.png", position = game.at(xCentro, yCentro-0.5)),
                                            d = new Pieza(image = "naranja.png", position = game.at(xCentro, yCentro-1.5))
                                            )
{
    
}

object tipo_bloqueS inherits BloqueTetris(xCentro = 1, yCentro = 1,
                                            a = new Pieza(image = "naranja.png", position = game.at(xCentro-1, yCentro)) ,
                                            b = new Pieza(image = "naranja.png", position = game.at(xCentro, yCentro)),
                                            c = new Pieza(image = "naranja.png", position = game.at(xCentro, yCentro+1)),
                                            d = new Pieza(image = "naranja.png", position = game.at(xCentro+1, yCentro+1))
                                            ){
    
}

object tipo_bloqueSinv inherits BloqueTetris(xCentro = 1, yCentro = 1,
                                            a = new Pieza(image = "naranja.png", position = game.at(xCentro-1, yCentro)) ,
                                            b = new Pieza(image = "naranja.png", position = game.at(xCentro, yCentro)),
                                            c = new Pieza(image = "naranja.png", position = game.at(xCentro, yCentro-1)),
                                            d = new Pieza(image = "naranja.png", position = game.at(xCentro+1, yCentro-1))
                                            ){
    
}

object tipo_bloqueT inherits BloqueTetris(xCentro = 1, yCentro = 1,
                                            a = new Pieza(image = "naranja.png", position = game.at(xCentro-1, yCentro)) ,
                                            b = new Pieza(image = "naranja.png", position = game.at(xCentro, yCentro)),
                                            c = new Pieza(image = "naranja.png", position = game.at(xCentro, yCentro-1)),
                                            d = new Pieza(image = "naranja.png", position = game.at(xCentro+1, yCentro))
                                            ){
    
    
}
/* Es medio una idea, pero no se si es buena
La idea es que cada vez que aparezca un nuevo bloque este objeto elija una de sus posiciones al azar, 
cree las piezas correspondientes y las devuelva en la posicion correcta.
el centro no lo devolveria ya que el centro siempre apareceria en el mismo lugar, y el resto de piezas se acomodarian acordemente
Pero probablemente haya una mejor manera de hacerlo
*/
