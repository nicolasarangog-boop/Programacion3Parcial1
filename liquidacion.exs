defmodule Liquidacion do
@moduledoc """
Modulo Calcula Valor Entregas, Bonificaciones, Descuentos y Liquidacion
- Autores: Briyith Sanchez Alonso y Nicolás Arango Gutiérrez
- Fecha: Septiembre del 2026
- Licencia: GNU GPL V3
"""

@doc """
Funcion que calcula el valor de una entrega de acuerdo con el porcentaje de grasa

## Parametros
- Litros: Cantidad de litros recibidos en la entrega
- Grasa: Porcentaje de la grasa de la muestra recibida en la entrega

## Ejemplo
iex> Liquidacion.valor_entrega(240, 3.8)
"457.920"
"""
def valor_entrega(litros, grasa) do
  valor_inicial= litros * Datos.tarifa_base()

  cond do
    grasa >= 3.5 -> valor_inicial * 1.06
    grasa >= 3 -> valor_inicial
    grasa >= 2.5 -> valor_inicial * 0.92

    true -> valor_inicial * 0.8
  end
end

@doc """
Funcion que calcula el total de bonificaciones por volumen de un productor

## Parametros
- Entregas_validas: Lista con todas las entregas validadas

## Ejemplo
iex> Liquidacion.bonos_por_volumen(entregas)
"75000"
"""
def bonos_por_volumen (entregas_validas) do
entregas_validas
|> Enum.group_by(fn entrega -> entrega.dia end)
|> Enum.map(fn {_, entregas_dia} ->
  litros_dia=
    Enum.reduce(entregas_dia,0, fn entrega, acumulado ->
      acumulado + entrega.litros
    end)

    if litros_dia >= Datos.umbral_bono() do
      Datos.bono_diario()
    else
      0
    end
end)
|> Enum.sum()
end

end
