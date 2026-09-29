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

  Enum.each(motivos, fn motivo1 -> conteo= Enum.count(entregas_rechazadas, fn {_e, motivo} -> motivo == motivo1 end)
  IO.puts("Motivo #{motivo1}: #{conteo} rechazos") end )

  IO.puts(" ")
end

@doc """
Funcion que reporta litros almacenados por tanque y porcentaje de ocupacion

## Parametros
- Entregas_validas: Lista con todas las entregas validadas
-Tanques: Lista de mapas con los datos de los tanques

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
- Tanques: Lista de los tanques
- Entregas_validas: Lista de entregas validadas

## Ejemplo
iex> Reportes.informacion_tanques(tanques, entregas_validas)
[...]
"""
def informacion_tanques(tanques, entregas_validas) do
  tanques
  |> Enum.map(fn tanque ->
  informacion_tanque(tanque, entregas_validas)
  end)
end

@doc """
Funcion para obtener la informacion de un tanque como los litros almacenados y % ocupacion

## Parametros
- Tanque: Mapa con la informacion del tanque
- Entregas_validas: Lista de entregas validadas

## Ejemplo
iex> tanque = %{id: "T01", nombre: "Tanque 1", capacidad: 2000}
iex> entregas_validas = [%{tanque: "T01", litros: 700}]
iex> Reportes.informacion_tanque(tanque, entregas_validas)
%{id: "T01", nombre: "Tanque 1", litros: 700, capacidad: 2000, ocupacion: 35.0}
"""
def informacion_tanque(tanque, entregas_validas) do
  litros = litros_tanque(tanque.id, entregas_validas)
  ocupacion= porcentaje_ocupacion(litros, tanque.capacidad)

  %{
    id: tanque.id,
    nombre: tanque.nombre,
    litros: litros,
    capacidad: tanque.capacidad,
    ocupacion: ocupacion
  }
end

@doc """
Funcion para calcular a partir de las entregas validadas, la cantidad de litros almacenados en un tanque

## Parametros
- Id_tanque: Identificación Unica del tanque que se desea consultar
- Entregas_validas: Lista de entregas validadas

## Ejemplo
iex> entregas_validas = [
%{tanque: "T01", litros: 300},
%{tanque: "T02", litros: 200},
]
iex> Reportes.litros_tanque("T01", entregas_validas)
300
"""
def litros_tanque(id_tanque, entregas_validas) do
  entregas_validas
  |> Enum.filter(fn entrega_valida -> entrega_valida.tanque == id_tanque end)
  |> Enum.reduce(0, fn entrega_valida, acumulado ->
    acumulado + entrega_valida.litros
  end)
end

@doc """
Funcion para calcular el porcentaje de ocupacion de un tanque

## Parametros
- Litros: Cantidad de litros almacenados en el tanque
- Capacidad: Capacidad total del tanque en litros

## Ejemplo
iex> Reportes.porcentaje_ocupacion(700,2000)
"35"
"""
def porcentaje_ocupacion(litros, capacidad) do
  litros/capacidad * 100
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

@doc """
Genera el reporte 3 mostrando los litros recibidos por dia y verifica el cumplimiento de la meta

##Parámetros
-entregas_validas: lista con todas las entregas validas

##ejemplo
iex> Reportes.reporte3(entregas_validas)
[...]
"""
def reporte3(entregas_validas) do
  1..6
  |> informacion_dias(entregas_validas)
  |> evaluar_cumplimiento_metas
end

@doc """
obtiene la información de litros y el estado de la meta para cada uno de los 6 días

## Parámetros
-dias: Rango o lista con los dias a evaluar(1..6)
-entregas_validas: lista de entregas validadas

##Ejemplo
iex> Reportes.informacion_dias(1..6, entregas_validas)
[...]
"""
def informacion_dias(dia, entregas_validas) do
  dias
  |>Enum.map(fn dia ->
   informacion_dia(dia, entregas_validas)
  end )
end

@doc """
Calcula los litros totales entregados en un dia especifico y determina si se cumplió la meta de 2000 litros

## Parámetros
-dia: Número del dia que se va a verificar
-entregas_validas: lista de entregas validas

## Ejemplo
iex> Reportes.informacion_dia(1, entregas_validas)
%{dia:1, litros:2150, cumplio:true}
"""
def informacion_dia(dia, entregas_validas) do
  litros=
    entregas_validas
    |>Enum.filter(fn entrega -> entrega.dia == dia end )
    |>Enum.reduce(0, fn entrega, acc -> acc + entrega.litros end)

    cumplio? = litros >= 2000

    %{
      dia: dia,
      litros: litros,
      cumplio: cumplio?
    }
end

@doc """
Imprime el estado de cada dia y si se cumpió la meta todos los dias o al menos un dia

##Parámetros
-lista_dias: lista de mapas con la información de todos los días

## Ejemplo
iex> Reportes.evaluar_cumplimiento_metas(lista_dias)
:ok
"""
def evaluar_cumplimiento_metas(lista_dias) do
  IO.puts(" Litros recibidos por dia ")

  Enum.each(lista_dias, fn informacion ->
  estado=
    case informacion.cumplio do
      true -> "cumplió meta"
      false -> "NO cumplió meta"
    end

    IO.puts(" Dia #{informacion.dia}: #{informacion.litros}L tiene #{estado} ")
  end )

  cumplio_todos?= Enum.all?(lista_dias, fn informacion -> informacion.cumplio ==true end )
  cumplio_al_menos_uno?= Enum.any?(lista_dias, fn informacion -> informacion.cumplio == true end)

  IO.puts("Cumplió la meta todos los días? #{cumplio_todos?}")
  IO.puts("cumplió la meta al menos un día? #{cumplio_al_menos_uno?}")
end
end
