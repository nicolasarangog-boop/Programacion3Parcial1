defmodule Reportes do
  @moduledoc """
Modulo para generar los reportes del centro de acopio
- Autores:  Nicolás Arango Gutiérrez y Briyith Sanchez Alonso
- Fecha: Septiembre del 2026
- Licencia: GNU GPL V3
"""
def generar_reportes(entregas_validas, entregas_rechazadas, productores, tanques) do
  IO.puts(" Reportes del centro de acopio ")
  reporte1(entregas_rechazadas)
  reporte2(entregas_validas, tanques)
  reporte3(entregas_validas)
  reporte4(entregas_validas, productores)
  reporte5(entregas_validas, productores)
  reporte6(entregas_validas, productores)
  reporte7(entregas_validas, productores)
  reporte8(entregas_validas, productores, tanques)
end

def reporte1(entregas_rechazadas) do
  IO.puts(" Entregas rechazadas ")
  motivos = [
    :productor_desconocido,
    :tanque_desconocido,
    :dia_incalido,
    :litros_fuera_rango,
    :porcentaje_invalido
  ]

  Enum.each(motivos, fn motivo1 -> conteo= Enum.count(entregas rechazadas, fn {_e, motivo} -> motivo == motivo1 end)
  IO.puts("Motivo #{motivo1}: #{conteo} rechazos") end )

  IO.puts(" ")
end

@doc """
Funcion que reporta litros almacenados por tanque y porcentaje de ocupacion

## Parametros
- Entregas_validas: Lista con todas las entregas validadas
-Tanques: Mapa con los datos de los tanques

## Ejemplo
iex> Reportes.reporte2(entregas_validas, tanques)
[...]
"""
def reporte2(entregas_validas, tanques) do
tanques
|> informacion_tanques(entregas_validas)
|> ordenar_ocupacion()
end

@doc """
Funcion para obtener en base a las entregas validadas, la informacion de todos los tanques

## Parametros
- Entregas_validas: Lista de entregas validadas
- Tanques: Lista de los tanques

## Ejemplo
iex> Reportes.informacion_tanques(entregas_validas, tanques)
[...]
"""
def informacion_tanques(entregas_validas, tanques) do
  tanques
  |> Enum.map(fn tanque ->
  informacion_tanque(tanque, entregas_validas)
  end)
end

@doc """
Funcion para ordenar los tanques de mayor a menor porcentaje de ocupacion

## Parametros
- Tanques: Lista de mapas con la informacion de los tanques

## Ejemplo
iex> tanques =[
 %{id: "T01", ocupacion: 35.0},
 %{id: "T02", ocupacion: 80.0},
]

iex> Reportes.ordenar_ocupacion(tanques)
[
 %{id: "T02", ocupacion: 80.0},
 %{id: "T01", ocupacion: 35.0}
]
"""
def ordenar_ocupacion(tanques) do
  tanques
  |> Enum.sort_by(fn tanque ->
    tanque.ocupacion
  end, :desc)
end




end
