import wollok.game.*
class BloqueTetris{ //Tengo dudas de donde deberiamos declarar las piezas del bloque de tetris
    var xCentro //Estas variables las deberiamos cambiar si queremos editar donde aparecen por primera vez los bloques
    var yCentro
    var centro = game.at(xCentro, yCentro)
    var a //= new Pieza(position = game.at(xCentro, yCentro+1)) 
    var b //= new Pieza(position = game.at(xCentro, yCentro)) 
    var c //= new Pieza(position = game.at(xCentro, yCentro-1))
    var d //= new Pieza(position = game.at(xCentro-1, yCentro-1))


        
    method rotar(dir){ //Hacerlo Asi, seria precalculo?
        if (dir == "derecha"){
            if ([self.rotarHoraria(a), self.rotarHoraria(b), self.rotarHoraria(c), self.rotarHoraria(d)].all( {valorReturn => valorReturn})){
                a.asumirPosicionRotada()
                b.asumirPosicionRotada()
                c.asumirPosicionRotada()
                d.asumirPosicionRotada()
            }

        }else{
            if ([self.rotarAntiHoraria(a), self.rotarAntiHoraria(b), self.rotarAntiHoraria(c), self.rotarAntiHoraria(d)].any( {valorReturn => valorReturn})){
                a.asumirPosicionRotada()
                b.asumirPosicionRotada()
                c.asumirPosicionRotada()
                d.asumirPosicionRotada()
            }
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
        //guardamos la posicion rotada a la pieza
        pieza.guardarPosicionRotada(xRotada, yRotada)
        //retornamos si la posicion rotada esta ocupada o no (es decir si esa pieza puede girar o no)
        return !(controlador.posEstaOcupada(xRotada, yRotada))
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
        
        //guardamos la posicion rotada a la pieza
        pieza.guardarPosicionRotada(xRotada, yRotada)
        //retornamos si la posicion rotada esta ocupada o no (es decir si esa pieza puede girar o no)
        return !(controlador.posEstaOcupada(xRotada, yRotada))
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

    method establecerEnTablero(){
        controlador.ocuparPos(a.position().x(), a.position().y())
        controlador.ocuparPos(b.position().x(), b.position().y())
        controlador.ocuparPos(c.position().x(), c.position().y())
        controlador.ocuparPos(d.position().x(), d.position().y())
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
    const cantidadDeBloques = 7

    method posEstaOcupada(x, y){
        if (x < 0 || x > 9 || y < 0 || y > 19){
            return true
        }
        return (0 != matriz.get(19-y).get(x))
    }

    method ocuparPos(x, y){ //No encontre funcion que me permita cambiar una variable accediendo mediante el indice, asi que lo hice asi
        var filaEditada = matriz.get(19-y)
        //if (filaEditada.get(x) == 1){} Estaria bueno que tire un warning o algo si se intenta ocupar una posicion ya ocupada, pero no se como hacerlo
        filaEditada = filaEditada.take(x) + [1] + filaEditada.drop(x+1)  //Tener en cuenta que take(x) tomara hasta la fila x-1 y drop(x+1) tomara desde la fila x, porque cuentan la cantidad de los elementos y no los indices (la x es un indice)
        matriz = matriz.take(20-y-1) + [filaEditada] + matriz.drop(20-y) //Aca se usa 20-y en vez de 19-y por la razon explicada arriba
    }


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
    const anchoTotal = 20
	const altoTotal = 10
    method clearGame() {
		game.allVisuals().forEach({ visual => game.removeVisual(visual) })
	}
    method inicio() {
		self.clearGame()
		game.title("TETRIZADO")
		game.width(anchoTotal)
		game.height(altoTotal)
		
	}
    method gameOver() {
		game.clear()
        game.title("TETRIZADO")
		game.width(anchoTotal)
		game.height(altoTotal)
		keyboard.p().onPressDo({ self.inicio() })
		keyboard.f().onPressDo({ game.stop() })
	}

}

