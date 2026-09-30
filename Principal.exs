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
    generar_comprobante(liquidaciones, entregas_validas, productores)
end

@doc """
Funcion para solicitar, convertir y validar una entrega adicional ingresada por Usuario

##Parametros
- Entregas_validas: Lista con todas las entregas que han sido validadas.
- Entregas_rechazadas: Lista con las entregas que no cumplieron las reglas de validacion.
- Productores: Lista con todos los productores registrados.
- Tanques: Lista con todos los tanques registrados.
"""
defp entrega_adicional(entregas_validas, entregas_rechazadas, productores, tanques) do
IO.puts("\n Ingrese una nueva entrega adicional
\n formato (productor; tanque; dia; litros; grasa)
\n o Enter para omitir")
entrada= IO.gets()

case String.trim(entrada) do
  "" -> {entregas_validas, entregas_rechazadas}

  texto ->
    case convertir_entrega(texto) do
    {:ok, entrega} ->
        case Validacion.validar_entrega(entrega, productores, tanques) do
            {:ok, entrega} ->
                {[entrega | entregas_validas], entregas_rechazadas}

            {:error, motivo} ->
                {entregas_validas, [{entrega, motivo} | entregas_rechazadas]}
        end

        {:error, :formato_invalido} ->
            IO.puts("El formato es inválido")
            {entregas_validas, entregas_rechazadas}
  end
end
end

@doc """
Funcion para convertir el texto ingresado por Usuario en un mapa de entrega

##Parametros
- Texto: Cadena de texto con los datos de la entrega separados por punto y coma

## Ejemplo
iex> Principal.convertir_entrega("P001;T01;1;500;3.6")
"{:ok, %{productor:"P001", tanque:"T01", dia: 1, litros: 500, grasa: 3.6}}"
"""
defp convertir_entrega(texto) do
  case String.split(texto, ";") do
    [productor, tanque, dia, litros, grasa] ->
        with {dia, ""} <- Integer.parse(dia),
             {litros, ""} <- Integer.parse(litros),
             {grasa, ""} <- Float.parse(grasa) do
               {:ok, %{
                productor: productor,
                tanque: tanque,
                dia: dia,
                litros: litros,
                grasa: grasa
               }}
        else
          _ -> {:error, :formato_invalido}
             end
          _ -> {:error, :formato_invalido}
  end
end

@doc """
Funcion que genera el comprobante de liquidacion de un productor seleccionado

## Parametros
- Liquidaciones: Lista con las liquidaciones de todos los productores
- Entregas_validas: Lista con todas las entregas que han sido validadas
- Productores: Lista con todos los productores registrados

## Ejemplo
iex> Principal.generar_comprobante(liquidaciones, entregas_validas, productores)
"Comprobante del productor seleccionado"
"""
defp generar_comprobante(liquidaciones, entregas_validas, productores) do
IO.puts("GENERACIÓN DE COMPROBANTE")

codigo=
IO.gets("Ingrese el código del productor: ")
|> String.trim()

case Enum.find(productores, fn productor -> productor.codigo == codigo end) do
  nil -> IO.puts("El productor no existe")

  productor -> liquidacion= Enum.find(liquidaciones, fn liquidacion -> liquidacion.productor == codigo end)
  entregas= Enum.filter(entregas_validas, fn entrega -> entrega.productor == codigo end)

  IO.puts("\n COMPROBANTE
  \n Productor: #{productor.nombre}
  \n Codigo: #{productor.codigo}\n")
  mostrar_detalle_dias(entregas)
  IO.puts("- Total entregas: #{length(entregas)}
  \n - Total litros: #{liquidacion.litros}
  \n - Valor entregas: $#{liquidacion.valor}
  \n - Total bonificaciones: $#{liquidacion.bonos}
  \n - Total descuento transporte: $#{liquidacion.transporte}
  \n - Neto: $#{liquidacion.neto}\n")
end
end

@doc """
Funcion que muestra el detalle de las entregas realizadas por un productor para cada dia

## Parametros
- Entregas_productor: Lista con las entregas validas realizadas por un productor

## Ejemplo
iex> Principal.mostrar_detalle_dias(entregas_productor)
"DIA 1
- Litros entregados: 500
- Valor entregas: $900000
- Bonificacion diaria: $25000"
"""
defp mostrar_detalle_dias(entregas_productor) do
  dias=
    entregas_productor
    |> Enum.map(fn entrega -> entrega.dia end)
    |>Enum.uniq()
    |> Enum.sort()

  dias
  |> Enum.each(fn dia ->
    entregas_dia=
        entregas_productor
        |> Enum.filter(fn entrega -> entrega.dia == dia end)

  litros=
    entregas_dia
    |> Enum.reduce(0, fn entrega, acumulado -> acumulado + entrega.litros end)

  valor=
    entregas_dia
    |>Enum.reduce(0, fn entrega, acumulado ->
        acumulado + Liquidacion.valor_entrega(entrega.litros, entrega.grasa)
    end)

  bono=
    if litros >= Datos.umbral_bono() do
      Datos.bono_diario()
    else
        0
    end
    IO.puts("\n DIA #{dia}
    \n - Litros entregados: #{litros}
    \n - Valor entregas: $#{valor}
    \n - Bonificación diaria: $#{bono}")
  end)
end

end
