defmodule Sismo do
    defstruct codigo: "", idCiudad: "", horaInicio: "", horaFinal: "" , magnitud: 0.0, profundidad: 0.0

    def parsear(linea) do
    case String.split(String.trim(linea), "@") do
      [cod, id_ciu, h_ini, h_fin, magn, prof]
        when cod != "" and id_ciu != "" and h_ini != "" and h_fin != "" ->
          validar_datos(cod, id_ciu, h_ini, h_fin, magn, prof)
      _ ->
        {:error, :formato_invalido_o_vacio}
    end
  end

  defp validar_datos(cod, id_ciu, h_ini, h_fin, magn, prof) do
    with {:ok, hora_inicio} <- Time.from_iso8601(h_ini),
         {:ok, hora_final} <- Time.from_iso8601(h_fin),
         {magnitud, ""} <- Float.parse(magn),
         {profundidad, ""} when profundidad >= 0.0 <- Float.parse(prof) do

      {:ok, %Sismo{
        codigo: cod,
        idCiudad: String.trim(id_ciu),
        horaInicio: hora_inicio,
        horaFinal: hora_final,
        magnitud: magnitud,
        profundidad: profundidad
      }}
    else
      _ -> {:error, :datos_invalidos}
    end
  end
end
