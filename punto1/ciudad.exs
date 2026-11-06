defmodule Ciudad do
  defstruct id: "", nombre: "", habitantes: 0

  def parsear(linea) do
    case String.split(String.trim(linea), "@") do
      [id, nombre, habitantes] when id != "" and nombre != "" and habitantes != "" ->
        validar_habitantes(id, nombre, habitantes)
      _ ->
        {:error, :formato_invalido_o_vacio}
    end
  end

  defp validar_habitantes(id, nombre, habitantes) do
    case Integer.parse(habitantes) do
      {habitantes, ""} when habitantes > 0 ->
        {:ok, %Ciudad{id: id, nombre: nombre, habitantes: habitantes}}
      _ ->
        {:error, :habitantes_invalidos}
    end
  end
end
