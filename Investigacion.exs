defmodule Investigacion do
@moduledoc """
Modulo con investigación propuesta del proyecto sobre tiempos de ejecución de funciones del proyecto y combinacion de informacion
- Autores: Briyith Sanchez Alonso y Nicolás Arango Gutiérrez
- Fecha: Septiembre del 2026
- Licencia: GNU GPL V3
"""

 @doc """
 Ejecuta la investigación propuesta en el proyecto
 """
  def main do
  productores = Datos.productores()
  tanques = Datos.tanques()
  entregas = Datos.entregas()
  {entregas_validas, _entregas_invalidas}= Validacion.validar_entregas(entregas, productores, tanques)
  reporte_tres= Reportes.informacion_dias(1..6, entregas_validas)
  |> Enum.into(%{}, fn informacion -> {informacion.dia, informacion.litros} end)
  centro_vecino = %{
    1 => 1850.5,
    2 => 2100,
    3 => 1640,
    5 => 2350,
    7 => 800
  }

IO.puts("\nCONSULTAS\n")

medir_tiempo_liquidaciones(productores, entregas_validas)

medir_tiempo_combinar(reporte_tres, centro_vecino)

IO.puts("Litros combinados de dos centros de acopio")
combinar_litros(reporte_tres, centro_vecino)
|> IO.inspect()
 end

 @doc """
Mide el tiempo de ejecución de la función Liquidacion.liquidar_productores/2

## Parámetros
- productores: lista de mapas con la información de los productores.
- entregas_validas: lista con todas las entregas validadas.

## Ejemplo
iex> productores = Datos.productores()
iex> entregas_validas = Datos.entregas()
iex> {tiempo, resultado} = Investigacion.medir_tiempo_liquidaciones(productores, entregas_validas)
{42, resultado}
"""
def medir_tiempo_liquidaciones(productores, entregas_validas) do
  {tiempo, resultado} =
    :timer.tc(fn ->
      Liquidacion.liquidar_productores(productores, entregas_validas)
    end)

  IO.puts("Tiempo de liquidar_productores: #{tiempo} microsegundos")

  {tiempo, resultado}
end

@doc """
Mide el tiempo de ejecución de la función combinar_litros/2

## Parámetros
- mapa_r3: mapa con los litros recibidos por día obtenidos en el R3
- centro_vecino: mapa con los litros recibidos por día por el centro vecino

## Ejemplo
iex> mapa_r3 = %{1 => 2000, 2 => 1900}
iex> centro_vecino = %{1 => 1850.5, 3 => 800}
iex> {tiempo, resultado} = Investigacion.medir_tiempo_combinar(mapa_r3, centro_vecino)
{35, %{1 => 3850.5, 2 => 2700}}
"""
def medir_tiempo_combinar(mapa_r3, centro_vecino) do
  {tiempo, resultado} =
  :timer.tc(fn ->
    combinar_litros(mapa_r3, centro_vecino)
  end)

  IO.puts("Tiempo de combinar_litros: #{tiempo} microsegundos")

  {tiempo, resultado}
end

@doc """
Combina los litros registrados por día en dos mapas.

## Parámetros
- mapa_r3: mapa que contiene los litros registrados por día en el reporte 3.
- centro_vecino: mapa que contiene los litros registrados por día en el centro vecino.

## Ejemplo
iex> mapa_r3 = %{1 => 500, 2 => 600}
iex> centro_vecino = %{1 => 200, 2 => 300, 3 => 400}
iex> Investigacion.combinar_litros(mapa_r3, centro_vecino)
%{1 => 700, 2 => 900, 3 => 400}
"""
def combinar_litros(mapa_r3, centro_vecino) do
  Map.merge(mapa_r3, centro_vecino, fn _dia, litros_r3, litros_vecino ->
    litros_r3 + litros_vecino
  end)
end
end

Investigacion.main()
