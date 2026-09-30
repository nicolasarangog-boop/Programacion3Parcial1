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
  reporte5(entregas_rechazadas, productores)
  reporte6(entregas_validas, productores)
  reporte7(entregas_validas, productores)
  reporte8(entregas_validas, tanques)
end

@doc """
Genera el reporte mostrando la cantidad total de entregas rechazadas por motivo de rechazo

##Parámetros
-entregas_rechazadas: lista de entregas rechazadas

## Ejemplo
iex> Reportes.reporte1(entregas_rechazadas)
:ok
"""
def reporte1(entregas_rechazadas) do
  IO.puts(" Entregas rechazadas ")
  motivos = [
    :productor_desconocido,
    :tanque_desconocido,
    :dia_invalido,
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
Genera el reporte mostrando los litros recibidos por dia y verifica el cumplimiento de la meta

##Parámetros
-entregas_validas: lista con todas las entregas validas

##ejemplo
iex> Reportes.reporte3(entregas_validas)
[...]
"""
def reporte3(entregas_validas) do
  1..6
  |> informacion_dias(entregas_validas)
  |> evaluar_cumplimiento_metas()
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
def informacion_dias(dias, entregas_validas) do
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

@doc """
Genera el reporte con la liquidación detallada y ordenada por pago

## Parámetro
- entregas_validas: lista de entregas validas
- productores: lista de mapas con los productores

## Ejemplo
iex> Reportes.reporte4(entregas_validas, productores)
[...]
"""
def reporte4(entregas_validas, productores) do
  productores
   |> calcular_liquidaciones(entregas_validas)
   |> Enum.sort_by(fn liquidacion -> liquidacion.neto end, :desc)
   |> imprimir_liquidacion()
end

@doc """
Calcula el resumen financiero para cada productor a partir de sus entregas

## Parámetros
-productores: lista de productores
-entregas_validas: lista de entregas validas

## Ejemplo
iex> Reportes.calcular_liquidaciones(productores, entregas_validas)
[...]
"""
def calcular_liquidaciones(productores, entregas_validas) do
  productores
  |> Enum.map(fn productor -> entrega_productor=Enum.filter(entregas_validas, fn entrega -> entrega.productor== productor.codigo end )


  litros= Enum.reduce(entregas_productor,0, fn entrega, acc  -> acc + entrega.litros end)
  valor= Enum.reduce(entregas_productor,0, fn entrega, acc  -> acc + calcular_valor_entrega(entrega) end)
  bono= calcular_bono_volumen(entregas_productor)

  dias_activos=entregas_productor |> Enum.map(fn entrega ->entrega.dia end) |> Enum.uniq() |> Enum.count()
  transporte= case productor.transporte do
    true -> dias_activos * 18000
    false -> 0
  end

  %{
    codigo: productor.codigo,
    nombre: productor.nombre,
    litros: litros,
    valor: valor,
    bono: bono,
    transporte: transporte,
    neto: valor + bono - transporte
  }
end)
end

@doc """
Imprime la tabla de liquidación

## Parámetros
-liquidaciones: lista de liquidaciones de los productores
"""
def imprimir_liquidacion(liquidaciones) do
  IO.puts(" Liquidación de productores ")

  liquidaciones
  |>Enum.with_index(1)
  |>Enum.each(fn {element, indice} ->
   IO.puts(" #{indice}. [#{element.codigo}] #{element.nombre} | Litros: #{element.litros} ")
  end )

IO.puts(" ")
end

defp calcular_valor_entrega(entrega) do
  base= entrega.litros * 1800
  cond do
    entrega.grasa >= 3.5 -> base * 1.06
    entrega.grasa >= 3.0 -> base
    entrega.grasa >= 2.5 -> base * 0.92
    true -> base * 0.80
  end
end

defp calcular_bono_volumen(entregas_productor) do
  1..6
  |> Enum.map( fn dia ->
   entregas_dia= Enum.filter(entregas_productor, fn entrega -> entrega.dia == dia end)
   litros_dia= Enum.reduce(entregas_dia, 0, fn entrega, acc -> acc + entrega.litros end)

   case litros_dia >= 450 do
    true -> 25000
    false ->0
   end
  end)
   |> Enum.sum()
end

@doc """
Genera el reporte de los productores que tuvieron entregas rechazadas y su motivo

## Parámetros
- entregas_rechazadas: lista de las entregas rechazadas
-productores: lista de mapas con la información de los productores

##Ejemplo
iex> Reportes.reporte5( entregas_rechazadas, productores)
[...]
"""
def reporte5(entregas_rechazadas, productores) do
  productores
  |>obtener_productores_con_rechazos(entregas_rechazadas)
  |>imprimir_reporte_rechazos()
end
@doc """
  Filtra y agrupa los motivos de rechazo a cada productor.

  ## Parametros
  - productores: Lista de productores.
  - entregas_rechazadas: Lista de entregas rechazadas.

  ## Ejemplo
      iex> Reportes.obtener_productores_con_rechazos(productores, entregas_rechazadas)
      [...]
  """
  def obtener_productores_con_rechazos(productores, entregas_rechazadas) do
    productores
    |> Enum.map(fn productor ->
      rechazos_productor =
        Enum.filter(entregas_rechazadas, fn {entrega, _motivo} ->
          entrega.productor == productor.codigo
        end)

      motivos_unicos =
        rechazos_productor
        |> Enum.map(fn {_entrega, motivo} -> motivo end)
        |> Enum.uniq()

      %{
        codigo: productor.codigo,
        nombre: productor.nombre,
        total_rechazos: Enum.count(rechazos_productor),
        motivos: motivos_unicos
      }
    end)
    |> Enum.filter(fn resumen_productor -> resumen_productor.total_rechazos > 0 end)
  end

  @doc """
  Imprime los productores con entregas rechazadas y sus motivos.

  ## Parametros
  - lista_rechazados: Lista de productores con sus respectivos rechazos procesados.
  """
  def imprimir_reporte_rechazos(lista_rechazados) do
    IO.puts(" productores con entregas rechazadas")

    case Enum.empty?(lista_rechazados) do
      true ->
        IO.puts("No se registraron entregas rechazadas para ningún productor.")

      false ->
        Enum.each(lista_rechazados, fn resumen_productor ->
          cadena_motivos = Enum.join(resumen_productor.motivos, ", ")
          IO.puts("Productor: #{resumen_productor.nombre} (Código: #{resumen_productor.codigo})")
          IO.puts("   - Cantidad de rechazos: #{resumen_productor.total_rechazos}")
          IO.puts("   - Motivos: #{cadena_motivos}\n")
        end)
    end

    IO.puts("")
  end

  @doc """
  Genera el reporte con el promedio de grasa y acidez de las entregas validadas de cada productor

  ## Parametros
  - entregas_validas: Lista de entregas validadas
  - productores: Lista de mapas con la información de los productores

  ## Ejemplo
      iex> Reportes.reporte6(entregas_validas, productores)
      [...]
  """
  def reporte6(entregas_validas, productores) do
    productores
    |> calcular_promedios_calidad(entregas_validas)
    |> imprimir_reporte_calidad()
  end

  @doc """
  Calcula los promedios de grasa y acidez para cada productor

  ## Parametros
  - productores: Lista de productores
  - entregas_validas: Lista de entregas validadas

  ## Ejemplo
      iex> Reportes.calcular_promedios_calidad(productores, entregas_validas)
      [...]
  """
  def calcular_promedios_calidad(productores, entregas_validas) do
    productores
    |> Enum.map(fn productor ->
      entregas_productor = Enum.filter(entregas_validas, fn entrega -> entrega.productor == productor.codigo end)
      total_entregas = Enum.count(entregas_productor)

      case total_entregas > 0 do
        true ->
          suma_grasa = Enum.reduce(entregas_productor, 0, fn entrega, acumulador -> acumulador + entrega.grasa end)
          suma_acidez = Enum.reduce(entregas_productor, 0, fn entrega, acumulador -> acumulador + entrega.acidez end)

          %{
            codigo: productor.codigo,
            nombre: productor.nombre,
            total_entregas: total_entregas,
            promedio_grasa: Float.round(suma_grasa / total_entregas, 2),
            promedio_acidez: Float.round(suma_acidez / total_entregas, 2)
          }

        false ->
          %{
            codigo: productor.codigo,
            nombre: productor.nombre,
            total_entregas: 0,
            promedio_grasa: 0.0,
            promedio_acidez: 0.0
          }
      end
    end)
  end

  @doc """
  Imprime los promedios de calidad calculados para cada productor.

  ## Parametros
  - lista_promedios: Lista de mapas con los promedios de calidad por productor.
  """
  def imprimir_reporte_calidad(lista_promedios) do
    IO.puts(" promedio de calidad por productor ")

    Enum.each(lista_promedios, fn resumen_calidad ->
      case resumen_calidad.total_entregas > 0 do
        true ->
          IO.puts("Productor: #{resumen_calidad.nombre} [#{resumen_calidad.codigo}]")
          IO.puts("  - Entregas evaluadas: #{resumen_calidad.total_entregas}")
          IO.puts("  - Promedio Grasa: #{resumen_calidad.promedio_grasa}%")
          IO.puts("  - Promedio Acidez: #{resumen_calidad.promedio_acidez}%\n")

        false ->
          IO.puts("Productor: #{resumen_calidad.nombre} [#{resumen_calidad.codigo}] - Sin entregas aceptadas\n")
      end
    end)

    IO.puts("")
  end

  @doc """
  Genera el reporte identificando los productores que realizaron entregas validas en cada uno de los 6 dias

  ## Parametros
  - entregas_validas: Lista de entregas validadas.
  - productores: Lista de mapas con los productores.

  ## Ejemplo
      iex> Reportes.reporte7(entregas_validas, productores)
      [...]
  """
  def reporte7(entregas_validas, productores) do
    productores
    |> evaluar_cumplimiento_dias(entregas_validas)
    |> imprimir_productores_constantes()
  end

  @doc """
  Evalua cuantos y cuales dias del 1 a 6 entrego cada productor.

  ## Parametros
  - productores: Lista de productores.
  - entregas_validas: Lista de entregas validadas.

  ## Ejemplo
      iex> Reportes.evaluar_cumplimiento_dias(productores, entregas_validas)
      [...]
  """
  def evaluar_cumplimiento_dias(productores, entregas_validas) do
    productores
    |> Enum.map(fn productor ->
      entregas_productor = Enum.filter(entregas_validas, fn entrega -> entrega.productor == productor.codigo end)

      dias_registrados =
        entregas_productor
        |> Enum.map(fn entrega -> entrega.dia end)
        |> Enum.uniq()

      cumplio_todos_los_dias = Enum.count(dias_registrados) == 6

      %{
        codigo: productor.codigo,
        nombre: productor.nombre,
        dias_entregados: Enum.count(dias_registrados),
        cumplio_perfecto: cumplio_todos_los_dias
      }
    end)
  end

  @doc """
  Imprime la lista de productores que asistieron los 6 dias

  ## Parametros
  - lista_evaluada: Lista de mapas con la evaluacion de asistencia por productor
  """
  def imprimir_productores_constantes(lista_evaluada) do
    IO.puts(" productores que asistieron los seis días ")

    productores_cumplidos = Enum.filter(lista_evaluada, fn resumen -> resumen.cumplio_perfecto end)

    case Enum.empty?(productores_cumplidos) do
      true ->
        IO.puts("Ningún productor realizó entregas los 6 días")

      false ->
        IO.puts("Productores con asistencia perfecta:")
        Enum.each(productores_cumplidos, fn resumen ->
          IO.puts(" - [#{resumen.codigo}] #{resumen.nombre}")
        end)
    end

    IO.puts("\nDesglose general de asistencia:")
    Enum.each(lista_evaluada, fn resumen ->
      estado_texto = case resumen.cumplio_perfecto do
        true -> "Cumplió"
        false -> "Incompleto (#{resumen.dias_entregados}/6 días)"
      end

      IO.puts(" - #{resumen.nombre}: #{estado_texto}")
    end)

    IO.puts(" ")
  end

  @doc """
  Genera el reporte con la información de ocupación y volumen almacenado en cada uno de los tanques

  ## Parametros
  - entregas_validas: Lista de entregas validadas.
  - tanques: Lista de mapas con los datos de los tanques del centro.

  ## Ejemplo
      iex> Reportes.reporte8(entregas_validas, tanques)
      [...]
  """
  def reporte8(entregas_validas, tanques) do
    tanques
    |> obtener_estado_tanques(entregas_validas)
    |> imprimir_reporte_tanques()
  end

  @doc """
  Calcula los litros totales almacenados y el porcentaje de ocupación para cada tanque de la lista.

  ## Parametros
  - tanques: Lista de mapas con los datos de los tanques.
  - entregas_validas: Lista de entregas validadas.

  ## Ejemplo
      iex> Reportes.obtener_estado_tanques(tanques, entregas_validas)
      [...]
  """
  def obtener_estado_tanques(tanques, entregas_validas) do
    tanques
    |> Enum.map(fn tanque ->
      entregas_tanque = Enum.filter(entregas_validas, fn entrega -> entrega.tanque == tanque.id end)

      litros_almacenados = Enum.reduce(entregas_tanque, 0, fn entrega, acumulador -> acumulador + entrega.litros end)

      porcentaje_ocupacion = case tanque.capacidad > 0 do
        true -> Float.round((litros_almacenados / tanque.capacidad) * 100, 2)
        false -> 0.0
      end

      %{
        codigo: tanque.id,
        capacidad: tanque.capacidad,
        litros_almacenados: litros_almacenados,
        porcentaje_ocupacion: porcentaje_ocupacion
      }
    end)
  end

  @doc """
  Imprime el desglose detallado del estado y capacidad de cada tanque

  ## Parametros
  - lista_estado_tanques: Lista de mapas con el resumen procesado de cada tanque
  """
  def imprimir_reporte_tanques(lista_estado_tanques) do
    IO.puts(" litros almacenados y ocupación de tanques ")

    case Enum.empty?(lista_estado_tanques) do
      true ->
        IO.puts("No hay tanques registrados")

      false ->
        Enum.each(lista_estado_tanques, fn estado_tanque ->
          IO.puts("tanque: #{estado_tanque.id}")
          IO.puts("  - Capacidad total: #{estado_tanque.capacidad} L")
          IO.puts("  - Litros almacenados: #{estado_tanque.litros_almacenados} L")
          IO.puts("  - Porcentaje de ocupación: #{estado_tanque.porcentaje_ocupacion}%\n")
        end)
    end

    IO.puts(" ")
  end
end
