defmodule CalculadorSismos do

  def calcular(movimientos) do
    calcular(movimientos, 0, nil, 0.0)
  end

  # caso base: cuando la ciudad no tiene movimientos
  defp calcular([], 0, _max_sismo, _suma) do
    # devuelve 0 para la cantidad, y no aplica para los demás datos
    {0, "No aplica", "No aplica"}
  end

  # caso base: cuando termina de recorrer una lista con movimientos
  defp calcular([], cantidad, max_sismo, suma_profundidades) do
    # se calcula el promedio con la suma y la cantidad
    promedio = suma_profundidades / cantidad

    # formatea el promedio a dos cifras decimales
    promedio_formateado = :erlang.float_to_binary(promedio, [decimals: 2])

    {cantidad, max_sismo, promedio_formateado}
  end

  
  defp calcular([movimiento | resto], cantidad, max_sismo, suma_profundidades) do
    # evalua si el movimiento actual es el de mayor magnitud
    nuevo_max =
      cond do
        max_sismo == nil ->
          movimiento

        movimiento.magnitud > max_sismo.magnitud ->
          movimiento

        true ->
          max_sismo
      end

    calcular(
      resto,
      cantidad + 1,
      nuevo_max,
      suma_profundidades + movimiento.profundidad
    )
  end
end
