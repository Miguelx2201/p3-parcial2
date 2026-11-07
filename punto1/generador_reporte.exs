Code.require_file("calculador_sismos.exs", __DIR__)
Code.require_file("Util.ex", __DIR__)
defmodule GeneradorReporte do
  def generar(ciudades, movimientos, rechazos_ciu, rechazos_mov) do
    # extrae solo los ids de las ciudades válidas para filtrar los movimientos
    ids_ciudades_validas = Enum.map(ciudades, fn c -> c.id end)

    # rechaza todos los movimientos cuyo idCiudad no corresponde a una ciudad valida
    # los movimientos huerfanos son aquellos que no tienen una ciudad definida en en ciudades.txt
    {movs_validos, movs_huerfanos} = Enum.split_with(movimientos, fn m -> m.idCiudad in ids_ciudades_validas end)

    # los movimientos de ciudades inválidas se suman al total de registros rechazados
    total_rechazos_mov = rechazos_mov + length(movs_huerfanos)

    # se agrupan los movimientos válidos por idCiudad en un mapa para tener acceso rápido
    movs_por_ciudad = Enum.group_by(movs_validos, fn m -> m.idCiudad end)

    # genera el reporte iterando sobre todas las ciudades validas
    texto_ciudades = generar_texto(ciudades, movs_por_ciudad)

    # agrega al final el total de registros rechazados, separado por archivo
    texto_final = texto_ciudades <> "\n--- Registros rechazados ---\n" <>
                  "Archivo ciudades: #{rechazos_ciu}\n" <>
                  "Archivo movimientos: #{total_rechazos_mov}\n"

    # muestra el reporte en consola
    Util.mostrar_mensaje("REPORTE POR CIUDAD----- \n")
    Util.mostrar_mensaje(texto_final)

    # el reporte de consola debe guardarse en resources/reporte_sismos.txt
    guardar_archivo(texto_final)
  end

end
