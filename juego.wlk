import wollok.game.*

class Pieza {//un "pixel" del bloque de tetris
    var position

    method caer(){
        position = position.down(1)
    }

    method darPos(x, y){//[izq, abajo, der, arriba] recorrer esta lista segun q flecha presione  
        position = game.at(x,y)
    }

    method irDerecha(){
        position = position.right()
    }

    method irIzquierda(){
        position = position.right()
    }

    method irArriba(){}

}

class BloqueTetris{
    var tipo //asignarle un tipo de bloque
    var orientacion

    method rotar(dir){
        if (dir == "derecha"){
            tipo.rotarHoraria()
        }else{
            tipo.rotarAntiHoraria()
        }
    }
}

//esto podriamos generalizarlo con clases o herencias para incluir al bloque linea
object tipo_bloqueL{
    var centro
    method rotacionHoraria(a, b, c, d){ //para identificar la pieza centro podriamos hacer que sea la primera que le pasemos
        
    }
}


class Pieza{
    var position
    method asignaPosicion(x, y){
        position = game.at(x, y)
    }
    method position() = position
}
object rotables{
    method rotarSentAgujasReloj(pieza, centro){
        //le restamos el centro a la pieza
        var posRotada = game.at(pieza.x()-centro.x(),pieza.y()-centro.y())
        //intercambiamos los ejes x'=y, y'=-x
        posRotada = game.at(posRotada.y(), -(posRotada.x()))
        //le sumamos el centro de vuelta
        posRotada = game.at(posRotada.x()+centro.x(),posRotada.y()+centro.y())

        pieza.asignarPosicion(posRotada.x(), posRotada.y())
    }

}

object tipo_bloqueLinv{
    
}

object tipo_bloqueCuadrado{
    
}
object tipo_bloqueLinea{
    var orientacion //para saber que centro tomamos segun este horizontal o vertical
    var centro
}

object tipo_bloqueS{
    
}

object tipo_bloqueSinv{
    
}

object tipo_bloqueT{
    
}



