import wollok.game.*

class BloqueTetris{ //Tengo dudas de donde deberiamos declarar las piezas del bloque de tetris
    var tipo //asignarle un tipo de bloque
    var xCentro = 1 //Estas variables las deberiamos cambiar si queremos editar donde aparecen por primera vez los bloques
    var yCentro = 1
    var a = new Pieza(position = game.at(xCentro, yCentro+1)) 
    var centro = new Pieza(position = game.at(xCentro, yCentro)) 
    var c = new Pieza(position = game.at(xCentro, yCentro-1))
    var d = new Pieza(position = game.at(xCentro-1, yCentro-1))
    
    method rotar(dir){
        if (dir == "derecha"){
            self.rotarHoraria(a)
            self.rotarHoraria(c)
            self.rotarHoraria(d)

        }else{
            self.rotarAntiHoraria(a)
            self.rotarAntiHoraria(c)
            self.rotarAntiHoraria(d)
        }
    }
    // Las agrego aca ya que todas los bloques de tetris van a ser rotables
    method rotarHoraria(pieza){
        //le restamos el centro a la pieza
        var xRotada = pieza.position().x()-centro.position().x() //La coordenada x de la pieza
        var yRotada = pieza.position().y()-centro.position().y() //La coordenada y de la pieza
        //intercambiamos las coordenadas x'=y, y'=-x
        const aux = xRotada
        xRotada = yRotada
        yRotada = -(aux)
        //le sumamos el centro de vuelta
        xRotada += centro.position().x() 
        yRotada += centro.position().y() 
        //asignamos la posicion rotada a la pieza
        pieza.asignarPosicion(xRotada, yRotada)
    }
    method rotarAntiHoraria(pieza){
        //le restamos el centro a la pieza
        var xRotada = pieza.position().x()-centro.position().x() //La coordenada x de la pieza
        var yRotada = pieza.position().y()-centro.position().y() //La coordenada y de la pieza
        //intercambiamos las coordenadas x'=-y, y'=x
        const aux = xRotada
        xRotada = -(yRotada)
        yRotada = aux
        //le sumamos el centro de vuelta
        xRotada += centro.position().x()
        yRotada += centro.position().y()
        //asignamos la posicion rotada a la pieza
        pieza.asignarPosicion(xRotada, yRotada)
    }
}

//esto podriamos generalizarlo con clases o herencias para incluir al bloque linea

class Pieza{//un "pixel" del bloque de tetris
    var position
    method asignarPosicion(x, y){
        position = game.at(x, y)
    }
    method position() = position
}

object tipo_bloqueLinv{
    

}

object tipo_bloqueCuadrado{
    
}
object tipo_bloqueLinea{
    
}

object tipo_bloqueS{
    
}

object tipo_bloqueSinv{
    
}

object tipo_bloqueT{
    
}
/* Es medio una idea, pero no se si es buena
La idea es que cada vez que aparezca un nuevo bloque este objeto elija una de sus posiciones al azar, 
cree las piezas correspondientes y las devuelva en la posicion correcta.
el centro no lo devolveria ya que el centro siempre apareceria en el mismo lugar, y el resto de piezas se acomodarian acordemente
Pero probablemente haya una mejor manera de hacerlo
////////POSICIONES INICALES///////// 
object posicionInicial{
    var xCentro = 1 //Estas variables las deberiamos cambiar si queremos editar donde aparecen por primera vez los bloques
    var yCentro = 1
    var a = null
    var centro = new Pieza(position = game.at(xCentro, yCentro)) 
    var c = null
    var d = null

    method Linv(opcion){                                                    //Posicion que describe cada opcion (b es el centro)
        if(opcion == 1){
            a = new Pieza(position = game.at(xCentro, yCentro+1))       //  \\ a \\
            c = new Pieza(position = game.at(xCentro, yCentro-1))       //  \\ b \\
            d = new Pieza(position = game.at(xCentro-1, yCentro-1))     //   d c \\
        }
        else if(opcion == 2){
            a = new Pieza(position = game.at(xCentro-1, yCentro))       //  \\ \\ \\
            c = new Pieza(position = game.at(xCentro+1, yCentro))       //   a  b  c
            d = new Pieza(position = game.at(xCentro+1, yCentro-1))     //   \\ \\ d
        }
        return [a, c, d]
   }
   //Asi hariamos con todas las posibles posiciones inicales
}
*/