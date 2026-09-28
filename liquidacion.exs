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
- Entregas_validas: Lista con todas las entregas validadas hechas por un productor

## Ejemplo
iex> Liquidacion.bonos_por_volumen(entregas)
"75000"
"""
def bonos_por_volumen (entregas_validas) do
entregas_validas
|> Enum.group_by(fn entrega -> entrega.dia end)
|> Enum.map(fn {_dia, entregas_dia} ->
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

@doc """
Funcion que calcula el descuento por utilizar el transporte del centro

## Parametros
- Productor: Usa la información para determinar si usa o no el transporte
- Entregas_validas: Lista con todas las entregas validadas hechas por el productor

## Ejemplo
iex> Liquidacion.transporte(productor, entregas_validas)
"36000"
"""
def descuento_transporte(productor, entregas_validas) do
if productor.transporte do
  dias_entregas=
    entregas_validas
    |> Enum.map(fn entrega -> entrega.dia end)
    |> Enum.uniq()
    |> length()

    dias_entregas * Datos.costo_transporte()
  else
    0
end
end

@doc """
Funcion que calcula la liquidacion final de un productor

## Parametros
- Productor: Informacion del productor
- Entregas_validas: Lista con todas las entregas validadas hechas por el productor

## Ejemplo
iex> Liquidacion.liquidar_productor(productor, entregas)
%{
productor: "P001",
litros: 1000,
valor: 1382400,
bonos: 75000,
transporte: 36000,
neto: 1396400
}
"""
def liquidar_productor(productor, entregas) do
  valor_entregas=
    Enum.reduce(entregas, 0, fn entrega, acumulado ->
      acumulado + valor_entrega(entrega.litros, entrega.grasa)
    end)

    litros_totales=
      Enum.reduce(entregas, 0, fn entrega, acumulado ->
        acumulado + entrega.litros
      end)

      bonos= bonos_por_volumen(entregas)

      descuento_total_transporte= descuento_transporte(productor, entregas)

      neto= valor_entregas + bonos - descuento_total_transporte

      %{
        productor: productor.codigo,
        litros: litros_totales,
        valor: valor_entregas,
        bonos: bonos,
        transporte: descuento_total_transporte,
        neto: neto
      }
end

end
