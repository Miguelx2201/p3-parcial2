Code.require_file("Util.ex", __DIR__)
alias Util

defmodule NodoCliente do
  @nombre_servicio_local :servicio_respuesta
  @servicio_local {@nombre_servicio_local, :nodocliente@localhost}

  @nodo_remoto :nodoservidor@localhost
  @servicio_remoto {:servicio_sismos, @nodo_remoto}
  # Lista de mensajes a procesar
  @mensajes [
    {@servicio_local, {:reporte_ciudad, 01}},
    {@servicio_local, {:reporte_ciudad, 03}},
    {@servicio_local, {:reporte_ciudad, 04}},
    {@servicio_local, :reporte_general},
    {@servicio_local, :fin},
  ]

  def main() do
    Util.mostrar_mensaje("CLIENTE ACTIVO...")


    @nombre_servicio_local
    |> registrar_servicio()

    establecer_conexion(@nodo_remoto)
    |> iniciar_produccion()
  end

  defp registrar_servicio(nombre_servicio_local),
    do: Process.register(self(), nombre_servicio_local)

  defp establecer_conexion(nodo_remoto) do
    Node.connect(nodo_remoto)
  end

  defp iniciar_produccion(false),
    do: Util.mostrar_mensaje("No se pudo conectar con el nodo servidor")

  defp iniciar_produccion(true) do
    enviar_mensajes()
    recibir_respuestas()
  end

  defp enviar_mensajes() do
    Enum.each(@mensajes, &enviar_mensaje/1)
  end

  defp enviar_mensaje(mensaje) do
    send(@servicio_remoto, {@servicio_local, mensaje})
  end

  defp recibir_respuestas() do
    receive do
      :fin ->
        :ok

      respuesta ->
        Util.mostrar_mensaje("\t -> \"#{respuesta}\"")
        recibir_respuestas()
    end
  end
end

NodoCliente.main()
