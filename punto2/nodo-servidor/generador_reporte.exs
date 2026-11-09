Code.require_file("calculador_sismos.exs", __DIR__)
Code.require_file("Util.ex", __DIR__)
defmodule GeneradorReporte do
  def generar_general(ciudades, movimientos, rechazos_ciu, rechazos_mov) do
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
    texto_final = "\tREPORTE GENERAL:\n" <> texto_ciudades <> "\n--- Registros rechazados ---\n" <>
                  "Archivo ciudades: #{rechazos_ciu}\n" <>
                  "Archivo movimientos: #{total_rechazos_mov}\n"

    # muestra el reporte en consola
    Util.mostrar_mensaje("Reporte general generado correctamente.")


    # el reporte de consola debe guardarse en resources/reporte_sismos.txt
    guardar_archivo(texto_final)
    texto_final
  end

  def generar_ciudad(ciudades, movimientos, id) do
    #IO.puts("DEBUG FILTER: #{inspect(ciudades)} FIN DEBUG FILTER")
    case Enum.find(ciudades, fn ciudad -> extraer_id(ciudad.id) == id end) do
      nil ->
        "Error: La ciudad no con el id #{id} no existe."
      ciudad ->
        #IO.puts("DEBUG MOVS: #{inspect(movimientos)} FIN DEBUG MOVS")
        movs_ciudad = Enum.filter(movimientos, fn movimiento -> extraer_id(movimiento.idCiudad) == id end)
        formatear_ciudad(ciudad, movs_ciudad)
    end

  end

  defp extraer_id("C" <> numero), do: String.to_integer(numero)

  # funcion principal que genera el texto por ciudad
  defp generar_texto(ciudades, movs_por_ciudad) do
    Enum.map_join(ciudades, "\n--------------------------\n", fn ciudad ->
      #obtiene los movimientos que corresponden al id de la ciudad
      movs_ciudad = Map.get(movs_por_ciudad, ciudad.id, [])
      formatear_ciudad(ciudad, movs_ciudad)
    end)
  end

  # estructura el texto de una ciudad
  defp formatear_ciudad(ciudad, movs_ciudad) do
    {total_sismos, max_sismo, prom_profundidad} = CalculadorSismos.calcular(movs_ciudad)

    """
    Ciudad: #{ciudad.nombre} | Habitantes: #{ciudad.habitantes}
    #{formatear_movimientos(movs_ciudad, total_sismos)}
    Total movimientos: #{total_sismos}
    Movimiento de mayor magnitud: #{formatear_maximo(max_sismo)}
    Profundidad promedio: #{prom_profundidad} km
    """
  end

  # si el total es 0 se devuelve el texto directamente
  defp formatear_movimientos(_movs_ciudad, 0) do
    "No hay movimientos registrados"
  end

  # si hay movimientos se formatean
  defp formatear_movimientos(movs_ciudad, _total) do
    "Movimientos:\n" <>
      Enum.map_join(movs_ciudad, "\n", fn m ->
        " - #{m.codigo}: Desde las #{Time.to_string(m.horaInicio)} hasta las #{Time.to_string(m.horaFinal)} | Magnitud: #{m.magnitud} | Profundidad: #{m.profundidad} km"
      end)
  end

   # funciones auxiliares para mostrar el codigo y magnitud, o no aplica
  defp formatear_maximo("No aplica"), do: "No aplica"
  defp formatear_maximo(sismo), do: "#{sismo.codigo} (#{sismo.magnitud})"

   defp guardar_archivo(contenido) do
    #ruta en la que se guarda el reporte
    ruta = "punto2/nodo-servidor/resources/reporte_sismos.txt"

    # reemplaza el reporte anterior o si falla la escritura, informa el error en consola
    case File.write(ruta, contenido) do
      :ok ->
       Util.mostrar_mensaje("\nReporte guardado exitosamente en #{ruta}")
      {:error, _razon} ->
       Util.mostrar_mensaje("\nError: No se pudo escribir el reporte en consola hacia #{ruta}")
    end
  end

end
