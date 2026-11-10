# Parcial #2 de Programación 3 (Programación funcional usando erlang elixir)

## Integrantes del grupo:
NATALIA CONTRERAS MORA 

JUAN MIGUEL GUTIERREZ VARGAS

## Punto 1: Reporte Local

Los archivos de entrada son ciudades.txt y movimientos.txt, se encuentran en la carpeta resources.

El archivo de salida es el reporte generado, que se encuentra en la ruta: resources/reporte_sismos.txt

**Carpeta de ejecución:**
Para ejecutar este punto, ubiquese en la carpeta `punto-1/`

### Comando para ejecución del programa:
```elixir
elixir coordinador_local.exs
```

## Punto 2: Separación de la app en nodos (Cliente y Servidor)

Los archivos de entrada son ciudades.txt y movimientos.txt, se encuentran en la carpeta resources.

**Carpeta de ejecución:** 
Para ejecutar este punto, ubiquese en la carpeta raiz `p3-parcial2`

### Comando para ejecución del nodo Servidor:
```elixir
elixir --sname nodoservidor@localhost --cookie cookie.txt punto2/nodo-servidor/nodo-servidor.exs
```

### Comando para ejecución del nodo Cliente:
```elixir
elixir --sname nodocliente@localhost --cookie cookie.txt punto2/nodo-cliente/nodo-cliente.exs
```

El codigo actual representa el ejemplo planteado en el documento del proyecto final con los 5 llamados del mismo; un reporte de ciudad con movimientos, un reporte de ciudad sin movimientos, un reporte de ciudad no existente, un reporte general y por ultimo un mensaje para declarar el fin. En caso de que se quiera dejar el servidor escuchando peticiones de otros clientes se deberia eliminar el ultimo mensaje (:fin) y asi podriamos conectar mas clientes.
