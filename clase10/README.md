## interpretacion de valores
se puede graficar como usar de una forma mas abstracta

### formato .CSV
Coma separated value

tiempo, dato1, dato2/n
lunes,05,04/n
martes,9,10/n

### Tiempo EPOCH/UNIX
t0 = 1 de enero de 1970, dt = 1 por segundo

### Normalizacion
Se escalan los datos para poderlos visualizar en procesing

importar en excel, nombrar raw y proteger hoja

luego, se copia y se "peina" (desplazar los numeros al eje positivo y normalizar)

Al ingresar en Processing se debe agregar a una carpeta /data

Crear una clase '''Table''' luego se inicializa  con '''loadtable'''

tabla.getRowCount();  tabla.getColumnCount();  tabla.getFloat(y,x);
