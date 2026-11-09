Code.require_file("coordinador_local.exs",__DIR__)
Code.require_file("Util.ex", __DIR__)
alias Util

defmodule NodoServidor do
  @nombre_servicio_local :servicio_sismos
  def main() do
    Util.mostrar_mensaje("SERVICIO SISMOS ACTIVO...")
    registrar_servicio(@nombre_servicio_local)
    procesar_mensajes()
  end

  defp registrar_servicio(nombre_servicio_local),
    do: Process.register(self(), nombre_servicio_local)

  defp procesar_mensajes() do
    receive do
      {productor, mensaje} ->
        respuesta = procesar_mensaje(mensaje)
        send(productor, respuesta)
        # Llama recursivamente para seguir recibiendo mensajes
        if respuesta != :fin, do: procesar_mensajes()
    end
  end

  defp procesar_mensaje(:fin), do: :fin
  defp procesar_mensaje({:reporte_ciudad, id_ciudad}), do: CoordinadorLocal.iniciar_reporte_ciudad(id_ciudad)
  defp procesar_mensaje(:reporte_general), do: CoordinadorLocal.iniciar_reporte_general()
  defp procesar_mensaje(mensaje), do: "El mensaje \"#{inspect(mensaje)}\" es desconocido."
end

NodoServidor.main()
