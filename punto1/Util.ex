defmodule Util do
 def mostrar_mensaje_java(mensaje) do
   System.cmd("java", ["-cp", ".", "Mensaje", mensaje])
 end

 def mostrar_mensaje(mensaje) do
   mensaje
   |>IO.puts()
 end

  def mostrar_error(mensaje) do
       IO.puts(:standard_error, mensaje)
   end

 #PATTERN MACTHING

 def ingresar(mensaje,:texto) do
  mensaje
  |>IO.gets()
  |>String.trim()
end

def ingresar(mensaje,:entero) do
   ingresar(mensaje, &String.to_integer/1, :entero)
end

def ingresar(mensaje, :enteropositivo) do
  numero = ingresar(mensaje, &String.to_integer/1, :entero)

  cond do
    is_binary(numero) -> numero

    is_integer(numero) and numero < 0 ->
      mostrar_error("ingrese un numero positivo")
      ingresar(mensaje, :enteropositivo)

    true -> numero
  end
end

def ingresar(mensaje,:real) do
   ingresar(mensaje, &String.to_float/1, :real)
end

def ingresar(mensaje, :boolean) do
  valor=mensaje
  |>IO.gets()
  |>String.trim()
  |>String.downcase()

  if valor == "true" || valor == "si" do
    true
  else
    false
  end
end

def ingresar(mensaje,parser,tipo_dato) do
   try do
      mensaje
      |> ingresar( :texto)
      |> parser.()
    rescue
        ArgumentError ->
          "Error, se espera que ingrese un número #{tipo_dato}\n"
          |> mostrar_error()

          mensaje
          |> ingresar(parser,tipo_dato)
    end
  end

def formater(valor) do
      :erlang.float_to_binary(valor / 1,decimals: 2)
  end

end
