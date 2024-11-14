import juego.*
import wollok.game.*
import controlador.*

//-------------------------BLOQUE------------------------
class BloqueJugable inherits BloqueTetris{
    const xCentroTablero
    const yCentroTablero
    const xCentroHold
    const yCentroHold

    method entrarEnTablero(){
        a.asignarPosicion((xCentro-a.position().x())+xCentroTablero, (yCentro-a.position().y())+yCentroTablero)
        b.asignarPosicion((xCentro-b.position().x())+xCentroTablero, (yCentro-b.position().y())+yCentroTablero)
        c.asignarPosicion((xCentro-c.position().x())+xCentroTablero, (yCentro-c.position().y())+yCentroTablero)
        d.asignarPosicion((xCentro-d.position().x())+xCentroTablero, (yCentro-d.position().y())+yCentroTablero)
        xCentro = xCentroTablero
        yCentro = yCentroTablero
    }
}

//---------------------TIPOS DE BLOQUES------------------
// BLOQUE NARANJA
class Tipo_bloqueL inherits BloqueJugable
    (
    xCentro = 32, 
    yCentro = 16, 
    xCentroTablero = 23, 
    yCentroTablero = 21, 
    xCentroHold = 14, 
    yCentroHold = 16,
        a = new Pieza(image = "naranja.png", position = game.at(xCentro, yCentro+1)) ,
        b = new Pieza(image = "naranja.png", position = game.at(xCentro, yCentro)),
        c = new Pieza(image = "naranja.png", position = game.at(xCentro, yCentro-1)),
        d = new Pieza(image = "naranja.png", position = game.at(xCentro+1, yCentro-1))
        ){
        method entrarEnHold(){
            xCentro = xCentroHold
            yCentro = yCentroHold
            a.asignarPosicion(xCentro, yCentro+1)
            b.asignarPosicion(xCentro, yCentro)
            c.asignarPosicion(xCentro, yCentro-1)
            d.asignarPosicion(xCentro+1, yCentro-1)
        }}
// BLOQUE AZUL
class Tipo_bloqueLinv inherits BloqueJugable
    (
    xCentro = 33, 
    yCentro = 16, 
    xCentroTablero = 23, 
    yCentroTablero = 21, 
    xCentroHold = 15, 
    yCentroHold = 16,
        a = new Pieza(image = "azul.png", position = game.at(xCentro, yCentro+1)) ,
        b = new Pieza(image = "azul.png", position = game.at(xCentro, yCentro)),
        c = new Pieza(image = "azul.png", position = game.at(xCentro, yCentro-1)),
        d = new Pieza(image = "azul.png", position = game.at(xCentro-1, yCentro-1))
        ){
    method entrarEnHold(){
        xCentro = xCentroHold
        yCentro = yCentroHold
        a.asignarPosicion(xCentro, yCentro+1)
        b.asignarPosicion(xCentro, yCentro)
        c.asignarPosicion(xCentro, yCentro-1)
        d.asignarPosicion(xCentro-1, yCentro-1)
    }}
// BLOQUE AMARILLO
class Tipo_bloqueCuadrado inherits BloqueJugable
    (
    xCentro = (32.5), 
    yCentro = (15.5),
    xCentroTablero = 22.5, 
    yCentroTablero = 20.5, 
    xCentroHold = 14.5, 
    yCentroHold = 15.5,
        a = new Pieza(image = "amarillo.png", position = game.at(xCentro-0.5, yCentro+0.5)) ,
        b = new Pieza(image = "amarillo.png", position = game.at(xCentro-0.5, yCentro-0.5)),
        c = new Pieza(image = "amarillo.png", position = game.at(xCentro+0.5, yCentro-0.5)),
        d = new Pieza(image = "amarillo.png", position = game.at(xCentro+0.5, yCentro+0.5))
        ){
    method entrarEnHold(){
        xCentro = xCentroHold
        yCentro = yCentroHold
        a.asignarPosicion(xCentro-0.5, yCentro+0.5)
        b.asignarPosicion(xCentro-0.5, yCentro-0.5)
        c.asignarPosicion(xCentro+0.5, yCentro-0.5)
        d.asignarPosicion(xCentro+0.5, yCentro+0.5)
    }}
// BLOQUE CELESTE
class Tipo_bloqueLinea inherits BloqueJugable
    (
        xCentro = 33.5, 
        yCentro = 16.5, 
        xCentroTablero = 22.5, 
        yCentroTablero = 21.5, 
        xCentroHold = 15.5, 
        yCentroHold = 16.5,
            a = new Pieza(image = "celeste.png", position = game.at(xCentro-0.5, yCentro+1.5)) ,
            b = new Pieza(image = "celeste.png", position = game.at(xCentro-0.5, yCentro+0.5)),
            c = new Pieza(image = "celeste.png", position = game.at(xCentro-0.5, yCentro-0.5)),
            d = new Pieza(image = "celeste.png", position = game.at(xCentro-0.5, yCentro-1.5))
            ){
    method entrarEnHold(){
        xCentro = xCentroHold
        yCentro = yCentroHold
        a.asignarPosicion(xCentro-0.5, yCentro+1.5)
        b.asignarPosicion(xCentro-0.5, yCentro+0.5)
        c.asignarPosicion(xCentro-0.5, yCentro-0.5)
        d.asignarPosicion(xCentro-0.5, yCentro-1.5)
    }}

// BLOQUE VERDE
class Tipo_bloqueS inherits BloqueJugable
    (
        xCentro = 33, 
        yCentro = 15, 
        xCentroTablero = 23, 
        yCentroTablero = 20, 
        xCentroHold = 15, 
        yCentroHold = 15,
            a = new Pieza(image = "verde.png", position = game.at(xCentro-1, yCentro)) ,
            b = new Pieza(image = "verde.png", position = game.at(xCentro, yCentro)),
            c = new Pieza(image = "verde.png", position = game.at(xCentro, yCentro+1)),
            d = new Pieza(image = "verde.png", position = game.at(xCentro+1, yCentro+1))
            ){
    method entrarEnHold(){
        xCentro = xCentroHold
        yCentro = yCentroHold
        a.asignarPosicion(xCentro-1, yCentro)
        b.asignarPosicion(xCentro, yCentro)
        c.asignarPosicion(xCentro, yCentro+1)
        d.asignarPosicion(xCentro+1, yCentro+1)
    }}

// BLOQUE ROJO
class Tipo_bloqueSinv inherits BloqueJugable
    (
        xCentro = 33, 
        yCentro = 16,
        xCentroTablero = 23, 
        yCentroTablero = 20, 
        xCentroHold = 15, 
        yCentroHold = 16,
        a = new Pieza(image = "rojo.png", position = game.at(xCentro-1, yCentro)) ,
        b = new Pieza(image = "rojo.png", position = game.at(xCentro, yCentro)),
        c = new Pieza(image = "rojo.png", position = game.at(xCentro, yCentro-1)),
        d = new Pieza(image = "rojo.png", position = game.at(xCentro+1, yCentro-1))
        ){
    method entrarEnHold(){
        xCentro = xCentroHold
        yCentro = yCentroHold
        a.asignarPosicion(xCentro-1, yCentro)
        b.asignarPosicion(xCentro, yCentro)
        c.asignarPosicion(xCentro, yCentro-1)
        d.asignarPosicion(xCentro+1, yCentro-1)
    }}
// BLOQUE VIOLETA
class Tipo_bloqueT inherits BloqueJugable
    (
        xCentro = 33, 
        yCentro = 16, 
        xCentroTablero = 23, 
        yCentroTablero = 20, 
        xCentroHold = 15, 
        yCentroHold = 16,
        a = new Pieza(image = "violeta.png", position = game.at(xCentro-1, yCentro)) ,
        b = new Pieza(image = "violeta.png", position = game.at(xCentro, yCentro)),
        c = new Pieza(image = "violeta.png", position = game.at(xCentro, yCentro-1)),
        d = new Pieza(image = "violeta.png", position = game.at(xCentro+1, yCentro))
        ){    
    method entrarEnHold(){
        xCentro = xCentroHold
        yCentro = yCentroHold
        a.asignarPosicion(xCentro-1, yCentro)
        b.asignarPosicion(xCentro, yCentro)
        c.asignarPosicion(xCentro, yCentro-1)
        d.asignarPosicion(xCentro+1, yCentro)
    }}

