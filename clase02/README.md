
# Processing

lenguadje de progarmacion orientado a grafica e imagen generativa [link](https://processing.org/)

## Sintaxis
[Referencia](https://processing.org/reference)
### Consola
  Entorno donde visualizar informacion, se accede con ```print();```

### Comentarios
  Notas al margen para los humanos, la maquina lo ignora, se accede con ```//```

### Funciones
todas las funciones en processing se esctiben ```funcion(argunemnto)```

  ```print();``` escribe en la consola.
  ```println();``` print con cambio de linea
  ```int();``` transforma a entero
### Variables
  las variables son numeros o datos, 
  
  se crean definiendo siempre el TIPO de variable

```TIPO nombre = dato;```

  variables:

  ```char``` -> Caracter ascii
  ```String``` -> Array de char
  ```int``` -> Numero Entero
  ```float``` -> Punto flotante
### Setup y Draw
```
void setup(){ }

void draw(){ }
```
## Grafica
  ```size(x,y)``` tamaño del lienzo
  ```colorMode();```
  ```background(gris); o (R, G, B);```
  ```line(x1,y1,x2,y2);```
  ```textSize();``` tamaño texto
  ```fill(0);``` relleno texto
  ```text(string,x,y)```
  ```frameRate()```
  ```frameCount```

  ```mouseX```, ```mouseY```

### [Primitivas](https://processing.org/reference#shape-2d-primitives)

## Entrega 03

Generar un afiche con algunas variaciones de movimiento, que incluya el texto seleccionado en el primer encargo. Referente: constructivismo ruso

Investigar variables de tipo "String" para escribir palabras


```java
String palabra = "hola terricolas soy un String";
```
  
