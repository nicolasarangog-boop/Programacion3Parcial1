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

end
