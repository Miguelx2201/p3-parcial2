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

end
