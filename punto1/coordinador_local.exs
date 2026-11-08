Code.require_file("ciudad.exs", __DIR__)
Code.require_file("sismo.exs", __DIR__)
Code.require_file("lector_archivos.exs", __DIR__)
Code.require_file("Util.ex", __DIR__)
Code.require_file("generador_reporte.exs", __DIR__)

defmodule CoordinadorLocal do
  # inicia la lectura concurrente de los archivos
  def iniciar_reporte do
    pid_coordinador = self()
    # el spawn crea los procesos en paralelo, entonces ambos archivos se empiezan a leer al mismo tiempo
    spawn(fn -> Lector.leer_y_procesar("resources/ciudades.txt", :ciudades, Ciudad, pid_coordinador) end)
    spawn(fn -> Lector.leer_y_procesar("resources/movimientos.txt", :movimientos, Sismo, pid_coordinador) end)
    # envía un mapa vacío para guardar los resultados y no hay mensajes recibidos hasta ahora
    esperar_respuestas(%{}, 0)
  end

    # cuando ya se hayan recibido las 2 respuestas esperadas (de ciudades y de movimientos) se evaluan estos mismos
  defp esperar_respuestas(resultados, 2) do
    evaluar_resultados(resultados)
  end

  defp esperar_respuestas(resultados, recibidos) do
    #recibe los resultados de la lectura hecha y hace una llamada recursiva con el mapa de nuevos resultados y suma 1 al contador de recibidos
    receive do
      {:resultado_lectura, archivo, resultado} ->
        nuevos_resultados = Map.put(resultados, archivo, resultado)
        esperar_respuestas(nuevos_resultados, recibidos + 1)
    end
  end

  defp evaluar_resultados(resultados) do
    #extrae del mapa de resultados los valores de las llaves ciudades y movimientos
    res_ciudades = Map.get(resultados, :ciudades)
    res_mov = Map.get(resultados, :movimientos)

    cond do
      #si el archivo de ciudades o el de movimientos fallaron muestra error
      res_ciudades == :error ->
        Util.mostrar_mensaje("Error: No se pudo leer el archivo de ciudades.")
      res_mov == :error ->
         Util.mostrar_mensaje("Error: No se pudo leer el archivo de movimientos sísmicos.")

      true ->
        # si ambos archivos retornaron ok se usa pattern matching para extraer los datos necesarios para generar el reporte
        {:ok, ciudades, rechazos_ciu} = res_ciudades
        {:ok, movimientos, rechazos_mov} = res_mov

        GeneradorReporte.generar(ciudades, movimientos, rechazos_ciu, rechazos_mov)
    end
  end
end
