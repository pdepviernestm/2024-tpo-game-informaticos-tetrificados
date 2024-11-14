# TETRIZADO (nombre provisorio)

## Equipo de desarrollo

- Ezequiel Giannoni
- Mateo Pirchi
- Fausto Rodriguez
- Lucas Cerutti
  
## IDEA PRINCIPAL DE JUEGO

El juego se basa en un tetris. Nos inspiramos en el tetris oficial y buscamos imitar su funcionamiento.

## Capturas

![Tetrizado](assets/Captura.JPG)

## Reglas de Juego / Instrucciones

- Tecla UP: rotar bloque en sentido horario
- Tecla DOWN: descender bloque una posision
- Tecla LEFT: mover bloque a la izquierda
- Tecla RIGHT: mover bloque a la derecha
- Tecla SPACE: hard drop (enviar el bloque al fondo)

## Documentacion

- PROBLEMA/SOLUCION
- Problema 1: Colision
    -- El bloque cae en un tiempo, y al encontrarse con el margen del entorno del juego deberia correrse/reubicarse. Que no se pase el bloque del margen. Que no rote trasponiendose con otro bloque ya colocado. Que no se pueda mover si esta entre bloques.
    que no pueda rotar si esta entre bloques
- Problema 2: Distintos bloques
    -- Aparicion de los distintos tipos de bloques, de forma aleatoria. Implementar cuadro predictivo en donde me diga que bloque viene
- Problema 3: Rotacion
    -- Rotacion de los bloques de izquierda a derecha y viceversa.
- Problema 4: Caida del bloque
    -- Que el bloque al llegar al suelo pueda asentarse, y se le sumen otros sea el caso.
- Problema 5: Linea completa
    -- Al completarse una linea de bloques individuales esta debe desaparecer y los bloques que tenga arriba bajen.
- Problema 6: Hard drop
    -- Predecir donde podria caer el bloque y hacerlo caer a mayor velocidad.
- Problema 7: Menu
    -- Reiniciar el juego estando en la pantalla
        Ver historial de score
        Salir del juego
- Problema 8: Game over
    -- Finalizar el juego si pasa una linea superior establecida
- Problema 9: Score
    -- Hacer un conteo de score cada vez que se completa una linea.
- Problema 10: Dificultades
    -- Mayor velocidad
        Fichas raras

## Otros

- K2005/UTN-FRBA
- Versión de wollok 0.2.7
- Repositorio puede ser público
