defmodule Liquidacion do
@moduledoc """
Modulo Calcula Valor Entregas, Bonificaciones, Descuentos y Liquidacion
- Autores: Briyith Sanchez Alonso y Nicolás Arango Gutiérrez
- Fecha: Septiembre del 2026
- Licencia: GNU GPL V3
"""

@doc """
Funcion que establece el valor de una entrega de acuerdo con el porcentaje de grasa

# Parametros
- Litros: Cantidad de litros recibidos en la entrega
- Grasa: Porcentaje de la grasa de la muestra recibida en la entrega

#Ejemplo
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



end
