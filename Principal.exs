defmodule Principal do
@moduledoc """
Modulo Principal donde se coordinan los demás modulos
- Autores: Briyith Sanchez Alonso y Nicolás Arango Gutiérrez
- Fecha: Septiembre del 2026
- Licencia: GNU GPL V3
"""
  def main do
#Se cargan los datos
    productores= Datos.productores()
    tanques= Datos.tanques()
    entregas= Datos.entregas()

#Se validan las entregas
    {entregas_validas, entregas_rechazadas}=
      Validacion.validar_entregas(entregas, productores, tanques)

#Se solicita la entrega adicional y se realiza el mismo proceso anterior
    {entregas_validas, entregas_rechazadas}=
      entrega_adicional(entregas_validas, entregas_rechazadas, productores, tanques)

#Se realiza la liquidacion
    liquidaciones= Liquidacion.liquidar_productores(productores, entregas_validas)

#Se generan los reportes
      Reportes.generar_reportes(entregas_validas, entregas_rechazadas, productores, tanques)

#Se genera comprobante del productor deseado
    generar_comprobante(liquidaciones, entregas_validas, entregas_rechazadas)
end
end
