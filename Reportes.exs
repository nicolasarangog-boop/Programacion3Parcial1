defmodule Reportes do
  @moduledoc """
Modulo para generar los reportes del centro de acopio
- Autores:  Nicolás Arango Gutiérrez y Briyith Sanchez Alonso
- Fecha: Septiembre del 2026
- Licencia: GNU GPL V3
"""
  @meta_diaria 2000
  @dias 1..6

def generar_reportes(entregas_validas, entregas_rechazadas, productores, tanques) do
  IO.puts(" Reportes del centro de acopio ")
  reporte1(entregas_rechazadas)
  reporte2(entregas_validas, tanques)
  reporte3(entregas_validas)
  reporte4(entregas_validas, productores)
  reporte5(entregas_validas, productores)
  reporte6(entregas_validas, productores)
  reporte7(entregas_validas, productores)
  reporte8(entregas_validas,productores, tanques)
end

@doc """
Genera un reporte de las entregas rechazadas

## Parámetros
- entregas_rechazadas: lista de tuplas donde cada elemento contiene una entrega rechazada y el motivo del rechazo.

## Ejemplo

iex> entregas_rechazadas = [
...>   {%{productor: "P001"}, :productor_desconocido},
...>   {%{tanque: "T1"}, :tanque_desconocido},
...>   {%{dia: 8}, :dia_invalido},
...>   {%{litros: 50}, :litros_fuera_rango},
...>   {%{grasa: 10}, :porcentaje_invalido}
...> ]
iex> Reportes.reporte1(entregas_rechazadas)
[
  {:productor_desconocido, 1},
  {:tanque_desconocido, 1},
  {:dia_invalido, 1},
  {:litros_fuera_rango, 1},
  {:porcentaje_invalido, 1}
]
"""
def reporte1(entregas_rechazadas) do
  motivos = [
    :productor_desconocido,
    :tanque_desconocido,
    :dia_invalido,
    :litros_fuera_rango,
    :porcentaje_invalido
  ]

  resultados=
  Enum.map(motivos, fn motivo ->
    conteo =
      Enum.count(entregas_rechazadas, fn {_entrega, motivo_entrega} ->
        motivo_entrega == motivo
      end)

    {motivo, conteo}
  end)

  IO.puts("Entregas rechazadas ")

  Enum.each(resultados, fn{motivo, conteo} ->
    IO.puts("#{motivo}: #{conteo}")
  end)

  IO.puts(" ")

  resultados
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
Genera el reporte mostrando los litros recibidos por cada día y verifica si se cumplió la meta diaria de 2000 litros.

## Parámetros
- entregas_validas: lista de entregas validadas

## Ejemplo
iex> Reportes.reporte3(entregas_validas)
:ok
"""
def reporte3(entregas_validas) do
  @dias
  |> informacion_dias(entregas_validas)
  |> evaluar_cumplimiento_metas()
end

@doc """
Obtiene la información de litros recibidos para cada uno de los 6 días

## Parámetros
- dias:lista de días
- entregas_validas: lista de mapas que contiene las entregas
  validadas

## Ejemplo

iex> entregas = [
...>   %{dia: 1, litros: 2200},
...>   %{dia: 2, litros: 1800}
...> ]
iex> Reportes.informacion_dias(1..2, entregas)
[
  %{dia: 1, litros: 2200, cumplio: true},
  %{dia: 2, litros: 1800, cumplio: false}
]
"""
def informacion_dias(dias, entregas_validas) do
  Enum.map(dias, fn dia -> informacion_dia(dia, entregas_validas) end)
end

@doc """
Calcula la cantidad total de litros recibidos durante un día y determina si se alcanzó la meta diaria de 2000 litros

## Parámetros
- dia: número del día que se desea consultar
- entregas_validas: lista de mapas que contiene las entregas
  validadas

## Ejemplo
iex> entregas = [
...>   %{dia: 1, litros: 1000},
...>   %{dia: 1, litros: 1200}
...> ]
iex> Reportes.informacion_dia(1, entregas)
%{dia: 1, litros: 2200, cumplio: true}
"""
def informacion_dia(dia, entregas_validas) do
  litros =
    entregas_validas
    |> Enum.filter(fn entrega -> entrega.dia == dia end)
    |> Enum.reduce(0, fn entrega, acumulado -> acumulado + entrega.litros end)

  cumplio =
    case litros >= @meta_diaria do
      true -> true
      false -> false
    end

  %{
    dia: dia,
    litros: litros,
    cumplio: cumplio
  }
end

@doc """
Muestra la cantidad de litros recibidos por día y determina si se cumplió la meta diaria.

## Parámetros
- lista_dias: lista de mapas con la información de cada día.

## Ejemplo
iex> datos = [
...>   %{dia: 1, litros: 2200, cumplio: true},
...>   %{dia: 2, litros: 1800, cumplio: false}
...> ]
iex> Reportes.evaluar_cumplimiento_metas(datos)
:ok
"""
def evaluar_cumplimiento_metas(lista_dias) do
  IO.puts(" Litros recibidos por día ")

  Enum.each(lista_dias, fn informacion ->
    estado =
      case informacion.cumplio do
        true ->
          "cumplió meta"

        false ->
          "NO cumplió meta"
      end

    IO.puts(
      "Día #{informacion.dia}: #{informacion.litros}L - #{estado}"
    )
  end)

  cumplio_todos =
    Enum.all?(lista_dias, fn informacion ->
      informacion.cumplio == true
    end)

  cumplio_al_menos_uno =
    Enum.any?(lista_dias, fn informacion ->
      informacion.cumplio == true
    end)

  IO.puts("Cumplió la meta todos los días? #{cumplio_todos}")
  IO.puts("Cumplió la meta al menos un día? #{cumplio_al_menos_uno}" )
  IO.puts(" ")

  :ok
end

@doc """
Genera el reporte de liquidación de los productores.

## Parámetros
- entregas_validas: lista de mapas que contiene las entregas validadas
- productores: lista de mapas que contiene la información de los productores

## Ejemplo
iex> Reportes.reporte4(entregas_validas, productores)
:ok
"""
def reporte4(entregas_validas, productores) do
  productores
  |> Liquidacion.liquidar_productores(entregas_validas)
  |> ranking([campo: :neto, orden: :desc])
  |> imprimir_liquidacion()
end

@doc """
Realiza un ranking de una lista de mapas según un campo y un orden especificados mediante una Keyword List

## Parámetros
- datos: lista de mapas
- opciones: Keyword List que contiene el campo y el orden

## Ejemplo
iex> datos = [
...>   %{nombre: "Juan", neto: 500000},
...>   %{nombre: "Ana", neto: 800000},
...>   %{nombre: "Pedro", neto: 300000}
...> ]
iex> Reportes.ranking(datos, [campo: :neto, orden: :desc])
[
  %{nombre: "Ana", neto: 800000},
  %{nombre: "Juan", neto: 500000},
  %{nombre: "Pedro", neto: 300000}
]
"""
def ranking(datos, opciones) do
  campo = Keyword.get(opciones, :campo, :neto)
  orden = Keyword.get(opciones, :orden, :desc)

  Enum.sort_by(datos, &Map.get(&1, campo), orden)
end

@doc """
Imprime la información de liquidación de los productores.

## Parámetros
- liquidaciones: lista de mapas con la información de cada productor.

## Ejemplo
iex> Reportes.imprimir_liquidacion([])
:ok
"""
def imprimir_liquidacion(liquidaciones) do
  IO.puts(" Liquidación de productores ")

  liquidaciones
  |> Enum.with_index(1)
  |> Enum.each(fn {liquidacion, indice} ->

    IO.puts( "#{indice}. [#{liquidacion.productor}] #{liquidacion.nombre}" )
    IO.puts( "   Litros: #{liquidacion.litros}")
    IO.puts( "   Valor: $#{formatear_dinero(liquidacion.valor)}")
    IO.puts( "   Bono: $#{formatear_dinero(liquidacion.bonos)}" )
    IO.puts( "   Transporte: -$#{formatear_dinero(liquidacion.transporte)}")
    IO.puts( "   Neto: $#{formatear_dinero(liquidacion.neto)}" )

    IO.puts("")
  end)

  :ok
end

@doc """
Genera el reporte del productor o productores que entregaron la mayor cantidad de litros durante cada día

## Parámetros
- entregas_validas: lista de mapas con las entregas validadas
- productores: lista de mapas con la información de los productores

## Ejemplo
iex> Reportes.reporte5(entregas_validas, productores)
:ok
"""
def reporte5(entregas_validas, productores) do
  productores_dia =
    obtener_mayores_por_dia(entregas_validas, productores)


    imprimir_reporte5(productores_dia)
  :ok
end

@doc """
Obtiene los productores que entregaron la mayor cantidad de litros para cada uno de los seis días.

## Parámetros
- entregas_validas: lista de mapas con las entregas validadas.
- productores: lista de mapas con la información de los productores.

## Ejemplo
iex> Reportes.obtener_mayores_por_dia(entregas_validas, productores)
[
  %{
    dia: 1,
    mayor: 500,
    ganadores: [...]
  }
]
"""
def obtener_mayores_por_dia(entregas_validas, productores) do
  @dias
  |> Enum.map(fn dia ->

    entregas_dia = Enum.filter(entregas_validas, fn entrega -> entrega.dia == dia end)
    litros_productores = Enum.map(productores, fn productor ->

        litros =
          entregas_dia
          |> Enum.filter(fn entrega ->
            entrega.productor == productor.codigo
          end)
          |> Enum.reduce(0, fn entrega, acumulado ->
            acumulado + entrega.litros
          end)

        %{
          codigo: productor.codigo,
          nombre: productor.nombre,
          litros: litros
        }
      end)

    mayor =
      case litros_productores do
        [] ->
          0

        lista ->
          Enum.max_by(lista, fn productor ->
            productor.litros
          end).litros
      end

    ganadores = Enum.filter(litros_productores, fn productor -> productor.litros == mayor and mayor > 0 end)

    %{
      dia: dia,
      mayor: mayor,
      ganadores: ganadores
    }
  end)
end

@doc """
Imprime el reporte de los productores que obtuvieron la mayor cantidad de litros en cada día.

## Parámetros
- lista: lista de mapas por la función obtener_mayores_por_dia.

## Ejemplo
iex> Reportes.imprimir_reporte5([])
:ok
"""
def imprimir_reporte5(lista) do
  IO.puts(" Productor con mayor cantidad de litros por día ")

  Enum.each(lista, fn informacion ->
    case informacion.ganadores do
      [] ->
        IO.puts( "Día #{informacion.dia}: No hubo entregas")

      ganadores ->
        nombres =
          Enum.map(ganadores, fn productor ->
            "#{productor.nombre} (#{productor.codigo})"
          end)
          |> Enum.join(", ")

        IO.puts( "Día #{informacion.dia}: #{nombres} - #{informacion.mayor} litros")
    end
  end)

  posiciones =
    lista
    |> Enum.flat_map(fn informacion ->
      informacion.ganadores
    end)
    |> Enum.reduce(%{}, fn productor, acumulado ->
      Map.update(
        acumulado,
        productor.codigo,
        %{
          nombre: productor.nombre,
          veces: 1
        },
        fn datos ->
          %{datos | veces: datos.veces + 1}
        end
      )
    end)

  IO.puts("")
  IO.puts(" Productor que ocupó el primer lugar en más días ")

  case Map.to_list(posiciones) do
    [] ->
      IO.puts("No hubo productores con entregas")

    lista_productores ->
      mayor_cantidad =
        lista_productores
        |> Enum.map(fn {_codigo, datos} ->
          datos.veces
        end)
        |> Enum.max()

      ganadores_finales =
        Enum.filter(
          lista_productores,
          fn {_codigo, datos} ->
            datos.veces == mayor_cantidad
          end
        )

      Enum.each(
        ganadores_finales,
        fn {codigo, datos} ->
          IO.puts( "- #{datos.nombre} (#{codigo}): #{datos.veces} días")
        end
      )
  end

  IO.puts(" ")
  :ok
end

@doc """
Genera el reporte de calidad de los productores.

## Parámetros
- entregas_validas: lista de mapas con las entregas validadas.
- productores: lista de mapas con la información de los productores.

## Ejemplo
iex> Reportes.reporte6(entregas_validas, productores)
:ok
"""
def reporte6(entregas_validas, productores) do
  resultados =
    calcular_calidad_productores(
      entregas_validas,
      productores
      )


    imprimir_reporte6(resultados)
  :ok
end

@doc """
Calcula el promedio de grasa de cada productor.

## Parámetros
- entregas_validas: lista de mapas con las entregas validadas.
- productores: lista de mapas con la información de los productores.

## Ejemplo
iex> Reportes.calcular_calidad_productores(entregas_validas,productores)
[
  %{
    codigo: "P001",
    nombre: "Juan",
    entregas: 3,
    promedio_grasa: 3.5
  }
]
"""
def calcular_calidad_productores(entregas_validas, productores) do
  Enum.map(productores, fn productor ->

    entregas_productor = Enum.filter(entregas_validas, fn entrega -> entrega.productor == productor.codigo end)
    cantidad = Enum.count(entregas_productor)

    case cantidad >= 3 do
      true ->

        litros=
          entregas_productor
          |> Enum.reduce(0, fn entrega, acumulado -> acumulado + entrega.litros end)

        suma_ponderada=
          Enum.reduce(entregas_productor, 0, fn entrega, acumulado -> acumulado + entrega.grasa * entrega.litros end)

        promedio = suma_ponderada / litros

        %{
          codigo: productor.codigo,
          nombre: productor.nombre,
          entregas: cantidad,
          promedio_grasa: promedio
        }

      false ->

        %{
          codigo: productor.codigo,
          nombre: productor.nombre,
          entregas: cantidad,
          promedio_grasa: 0
        }
    end
  end)
end

@doc """
Imprime el productor que presenta el mayor promedio de grasa entre los que poseen al menos tres entregas válidas

## Parámetros
- resultados: lista de mapas de la función calcular_calidad_productores

## Ejemplo
iex> Reportes.imprimir_reporte6([])
:ok
"""
def imprimir_reporte6(resultados) do
  IO.puts(" Mejor calidad de leche ")

  elegibles =
    Enum.filter(resultados, fn productor ->
      productor.entregas >= 3
    end)

  case elegibles do
    [] ->
      IO.puts("No hay productores con al menos 3 entregas válidas.")

    lista ->
      mayor=
        Enum.max_by(lista, fn productor ->
          productor.promedio_grasa
        end).promedio_grasa

      mejores =
        Enum.filter(lista, fn productor ->
          productor.promedio_grasa == mayor
        end)

      Enum.each(mejores, fn productor ->
      IO.puts( "Productor: #{productor.nombre} [#{productor.codigo}]")
      IO.puts( "Entregas válidas: #{productor.entregas}")
      IO.puts( "Promedio de grasa ponderado: #{Float.round(productor.promedio_grasa, 2)}%")
      end)
  end
  IO.puts(" ")
end

@doc """
Genera el reporte general de los pagos realizados por el centro durante la semana.

## Parámetros
- entregas_validas: lista de mapas con las entregas validadas.
- productores: lista de mapas con la información de los productores.

## Ejemplo
iex> Reportes.reporte7(entregas_validas, productores)
:ok
"""
def reporte7(entregas_validas, productores) do
  liquidaciones =
    Liquidacion.liquidar_productores(productores, entregas_validas)

  total_litros =
    Enum.reduce(liquidaciones, 0, fn productor, acumulado ->
      acumulado + productor.litros
    end)

  total_pagado =
    Enum.reduce(liquidaciones, 0, fn productor, acumulado ->
      acumulado + productor.neto
    end)

  costo_promedio =
  case total_litros > 0 do
  true -> total_pagado / total_litros
  false -> 0.0
    end

  imprimir_reporte7(total_litros,total_pagado,costo_promedio)
end

@doc """
Imprime los resultados generales del centro de acopio.

## Parámetros
- total_litros: cantidad total de litros recibidos.
- total_pagado: cantidad total de dinero pagado a los productores.
- costo_promedio: costo promedio pagado por cada litro.

## Ejemplo
iex> Reportes.imprimir_reporte7(5000, 9000000, 1800)
:ok
"""
def imprimir_reporte7(total_litros,total_pagado, costo_promedio) do

  IO.puts(" Totales del centro de acopio ")
  IO.puts("Total de litros recibidos: #{total_litros} L")
  IO.puts("Total pagado: $#{Float.round(total_pagado, 2)}")
  IO.puts("Costo promedio por litro: $#{Float.round(costo_promedio, 2)}")
  IO.puts(" ")
  :ok
end

@doc """
Genera el reporte de los productores que realizaron al menos una entrega válida en todos los tanques.

## Parámetros
- entregas_validas: lista de mapas con las entregas validadas.
- productores: lista de mapas con la información de los productores.

## Ejemplo
iex> Reportes.reporte8(entregas_validas, productores, tanques)
:ok
"""
def reporte8(entregas_validas, productores, tanques) do
  resultados =
  evaluar_productores_tanques(
    entregas_validas,
     productores,
     tanques
     )

  imprimir_reporte8(resultados)
  :ok
end

@doc """
Determina cuáles productores realizaron al menos una entrega válida en cada uno de los tanques del centro de acopio.

## Parámetros
- entregas_validas: lista de mapas con las entregas validadas.
- productores: lista de mapas con la información de los productores.
-tanques:

## Ejemplo
iex> Reportes.evaluar_productores_tanques(entregas_validas, productores, tanques)
[ %{codigo: "P001", nombre: "Juan"}]
"""
def evaluar_productores_tanques(entregas_validas, productores, tanques) do
  case tanques do
  [] ->
    []

  _ ->
    ids_tanques =
      Enum.map(tanques, fn tanque ->
        tanque.id
      end)

    Enum.filter(productores, fn productor ->
      tanques_productor =
        entregas_validas
        |> Enum.filter(fn entrega ->
          entrega.productor == productor.codigo
        end)
        |> Enum.map(fn entrega ->
          entrega.tanque
        end)
        |> Enum.uniq()

      Enum.all?(ids_tanques, fn id_tanque ->
        id_tanque in tanques_productor
      end)
    end)
end
end

@doc """
Imprime los productores con entregas validas en todos los tanques

## Parámetros
- productores: lista de mapas con los productores que cumplieron la condición de entregar durante los seis días.

## Ejemplo
iex> Reportes.imprimir_reporte8([])
:ok
"""
def imprimir_reporte8(productores) do
  IO.puts(" Productores con entregas válidas en todos los tanques ")

  case productores do
    [] ->
      IO.puts( "Ningún productor realizó entregas válidas en todos los tanques" )

    lista ->
      Enum.each(lista, fn productor ->
        IO.puts( "- [#{productor.codigo}] #{productor.nombre}" )end)
  end

  IO.puts(" ")
  :ok
end

defp formatear_dinero(valor) do
  Float.round(valor * 1.0, 2)
  |> :erlang.float_to_binary(decimals: 2)
end

end
