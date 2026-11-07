defmodule Lector do
  def leer_y_procesar(ruta_archivo, identificador, modulo_parser, pid_coordinador) do
    case File.read(ruta_archivo) do
      {:ok, contenido} ->
        lineas = String.split(contenido, "\n")
        {validos, rechazados} = procesar_lineas(lineas, modulo_parser)
        #se envia al coordinador si el resultado de la lectura fue exitoso con los validos y rechazados
        send(pid_coordinador, {:resultado_lectura, identificador, {:ok, validos, rechazados}})
        #se envia al coordinador si el resultado de la lectura fue erroneo
      {:error, _motivo} ->
        send(pid_coordinador, {:resultado_lectura, identificador, :error})
    end
  end

 defp procesar_lineas(lineas, modulo_parser) do
    # se quitan las líneas vacías
    lineas_utiles =
      lineas
      |> Enum.map(&String.trim/1)
      |> Enum.reject(fn linea -> linea == "" end)

    # se parsean todas las líneas y se separan los validos de los rechazados
    {validos, rechazados} =
      lineas_utiles
      |> Enum.map(fn linea -> modulo_parser.parsear(linea) end)
      |> Enum.split_with(fn resultado -> match?({:ok, _}, resultado) end)

    # se ignora el :ok y se extrae solo el struct
    validos_str = Enum.map(validos, fn {:ok, registro} -> registro end)

    {validos_str, length(rechazados)}
  end

end
