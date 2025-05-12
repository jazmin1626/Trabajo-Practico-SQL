-- CONSULTAS SIMPLES (Punto A)

-- 1) Obtener una lista con los nombres de las distintas oficinas de la empresa
SELECT descripcion AS oficinas
FROM oficinas

-- 2) Obtener una lista de todos los productos indicando descripción del producto, su precio de costo
-- y su precio de costo IVA incluido (tomar el IVA como 21%)
SELECT PR.descripcion, PR.precio AS costo, PR.precio*1.21 AS precioConIva
FROM productos PR

-- 3) Obtener una lista indicando para cada empleado apellido, nombre, fecha de cumpleaños y edad
SELECT E.apellido, E.nombre, E.fecha_nacimiento, YEAR(CURDATE())-YEAR(E.fecha_nacimiento) AS edad
FROM empleados E

-- 4) Listar todos los empleados que tiene un jefe asignado
SELECT E.apellido, E.cod_jefe
FROM empleados E
WHERE E.cod_jefe IS NOT NULL

-- 5) Listar los empleados de nombre "María" ordenado por apellido
SELECT *
FROM empleados E
WHERE E.nombre = "Maria"
ORDER BY E.apellido

-- 6) Listar los clientes cuya razón social comience con "L" ordenado por código de cliente
SELECT *
FROM clientes C
WHERE C.razon_social LIKE "L%"
ORDER BY C.cod_cliente

-- 7) Listar toda la información de los pedidos de Marzo ordenado por fecha de pedido
SELECT *
FROM pedidos
WHERE MONTH (fecha_pedido) = 3
ORDER BY fecha_pedido

-- 8) Listar las oficinas que no tienen asignado director
SELECT *
FROM oficinas
WHERE codigo_director IS NULL

-- 9) Listar los 4 productos de menor precio de costo
SELECT descripcion
FROM productos
ORDER BY precio
LIMIT 4

-- 10) Listar los códigos de empleados de los tres que tengan la mayor cuota
SELECT E.cod_empleado
FROM empleados E, datos_contratos DC
WHERE E.cod_empleado = DC.cod_empleado
ORDER BY DC.cuota DESC
LIMIT 3

-- CONSULTAS MULTITABLAS

-- 1) De cada producto listar descripción, razón social del fabricante y stock ordenado por razón social
-- y descripción
SELECT PR.descripcion, F.razon_social, PR.cantidad_stock
FROM productos PR, fabricantes F
WHERE PR.cod_fabricante = F.cod_fabricante
ORDER BY F.razon_social, PR.descripcion

-- 2) De cada pedido listar código de pedido, fecha de pedido, apellido del empleado y razón social del cliente
SELECT PE.cod_pedido, PE.fecha_pedido, E.apellido, C.razon_social
FROM pedidos PE, empleados E, clientes C
WHERE PE.cod_empleado = E.cod_empleado
AND PE.cod_cliente = C.cod_cliente

-- 3) Listar por cada empleado apellido, cuota asignada, oficina a la que pertenece ordenado en forma
-- descendente por cuota
SELECT E.apellido, DC.cuota, E.cod_oficina
FROM empleados E, datos_contratos DC
WHERE E.cod_empleado = DC.cod_empleado
ORDER BY DC.cuota DESC

-- 4) Listar sin repetir la razón de todos aquellos clientes que hicieron pedidos en Abril
SELECT DISTINCT C.razon_social
FROM clientes C, pedidos PE
WHERE C.cod_cliente = PE.cod_cliente
AND MONTH (PE.fecha_pedido) = 4

-- 5) Listar sin repetir los productos que fueron pedidos en Marzo
SELECT DISTINCT PR.descripcion
FROM productos PR, pedidos PE, detalle_pedidos DP
WHERE PR.cod_producto = DP.cod_producto
AND PE.cod_pedido = DP.cod_pedido
AND MONTH (PE.fecha_pedido) = 3

-- 6) Listar aquellos empleados que están contratados por más de 10 años ordenado por cantidad de años
-- en forma descendente
/* Ejemplo de JOIN (más moderno) para combinar datos de 2 o más tablas */
SELECT E.apellido, YEAR(CURDATE())-YEAR(DC.fecha_contrato) "años_contratado"
FROM empleados E
JOIN datos_contratos DC ON E.cod_empleado = DC.cod_empleado
WHERE (YEAR(CURDATE())-YEAR(DC.fecha_contrato)) > 10
ORDER BY años_contratado DESC

-- 7) Obtener una lista de los clientes mayoristas ordenada por razón social
SELECT C.razon_social, L.descripcion
FROM clientes C, listas L
WHERE C.cod_lista = L.cod_lista
AND L.descripcion = "lista mayorista"
ORDER BY C.razon_social

-- 8) Obtener una lista sin repetir que indique qué productos compró cada cliente, ordenada por razón social
-- y descripción
SELECT DISTINCT PR.descripcion, C.razon_social
FROM productos PR, clientes C, pedidos PE, detalle_pedidos DP
WHERE PE.cod_pedido = DP.cod_pedido
AND PR.cod_producto = DP.cod_producto
AND C.cod_cliente = PE.cod_cliente
ORDER BY C.razon_social, PR.descripcion

-- 9) Obtener una lista con la descripción de aquellos productos cuyo stock está por debajo del punto de
-- reposición indicando cantidad a comprar y razón social del fabricante ordenada por razón social y descripción
SELECT PR.descripcion, F.razon_social, PR.cantidad_stock, PR.punto_reposicion,
		(PR.punto_reposicion-PR.cantidad_stock) AS "Comprar"
FROM productos PR, fabricantes F
WHERE PR.cod_fabricante = F.cod_fabricante
AND PR.cantidad_stock < PR.punto_reposicion
ORDER BY F.razon_social, PR.descripcion

-- 10) Listar aquellos empleados cuya cuota es menor a 50000 o mayor a 100000
SELECT E.apellido, DC.cuota
FROM empleados E, datos_contratos DC
WHERE E.cod_empleado = DC.cod_empleado
AND DC.cuota < 50000
OR DC.cuota > 100000


-- CONSULTAS (Punto B)

-- 1) Obtener la cantidad de unidades máxima
SELECT MAX(cantidad) AS cantidad_maxima
FROM item_ventas

-- 2) Obtener la cantidad total de unidades vendidas del producto C
SELECT SUM(cantidad) AS total_unidades_vendidas
FROM item_ventas
WHERE codigo_producto = 103 /*como producto C*/

-- 3) Cantidad de unidades vendidas por producto, indicando la descripción del producto, ordenado de mayor
-- a menor por las cantidades vendidas
SELECT SUM(IV.cantidad) "total_unidades_vendidas", P.nombre_producto
FROM item_ventas IV, productos P
WHERE IV.codigo_producto = P.codigo_producto
GROUP BY P.nombre_producto
ORDER BY total_unidades_vendidas DESC

-- 4) Cantidad de unidades vendidas por producto, indicando la descripción del producto, ordenado
-- alfabéticamente por nombre del producto para los productos que vendieron más de 30 unidades
SELECT SUM(IV.cantidad) "total_unidades_vendidas", P.nombre_producto
FROM item_ventas IV, productos P
WHERE IV.codigo_producto = P.codigo_producto
GROUP BY P.nombre_producto
HAVING SUM(IV.cantidad) > 30
ORDER BY P.nombre_producto
/* Ejemplo de HAVING que filtra datos después de agrupar (tales como SUM, AVG, COUNT)*/

-- 5) Obtener cuántas compras (1 factura = 1 compra) realizó cada cliente indicando el código y nombre del
-- cliente ordenado de mayor a menor
SELECT COUNT(V.numero_factura) "cantidad_compras", C.codigo_cliente, C.nombre
FROM ventas V, clientes C
WHERE V.codigo_cliente = C.codigo_cliente
GROUP BY C.codigo_cliente, C.nombre
ORDER BY cantidad_compras DESC

-- 6) Promedio de unidades vendidas por producto, indicando el código del producto para el cliente 1
SELECT AVG(IV.cantidad) "promedio_unidades_vendidas", IV.codigo_producto
FROM ventas V, item_ventas IV
WHERE V.numero_factura = IV.numero_factura
AND V.codigo_cliente = 1
GROUP BY IV.codigo_producto