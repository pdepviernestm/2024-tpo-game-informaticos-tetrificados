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



