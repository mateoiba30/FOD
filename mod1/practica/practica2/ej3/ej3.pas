program ejer3;
uses crt;

CONST
valorAlto = 9999;
n = 3;

type

producto = record
	cod: integer;
	nombre: string;
	des: string;
	stockD: integer;
	stockM: integer;
	precio:real;
end;

venta = record
	cod:integer;
	cantidadVendida:integer; //stock vendido hago stockD - cantVendida
end;

maestro = file of producto;
detalle_diario = file of venta;
detalles = array [1..n] of detalle_diario;

procedure leer (var arc_detalle: detalle_diario; var dato:venta);
begin
	if not eof (arc_detalle) then
		read (arc_detalle,dato)
	else
		dato.cod:= valorAlto;
end;

procedure actualizar(var arc_maestro: maestro; var arc_detalle: detalle_diario);
var
    dato, aux: venta;
    prod: producto;
begin
    reset(arc_detalle);

    leer(arc_detalle, dato);
    while(dato.cod <> valorAlto) do begin
        aux.cod := dato.cod;
        aux.cantidadVendida := 0; //arranco en 0 porque el siguiente while lee al final
        while(aux.cod = dato.cod) do begin
            aux.cantidadVendida := aux.cantidadVendida + dato.cantidadVendida;
            leer(arc_detalle, dato);
        end;

        if not eof(arc_maestro) then
            read(arc_maestro, prod);
        while ( ( not eof(arc_maestro)) and (prod.cod < aux.cod)) do 
            read(arc_maestro, prod);
        seek(arc_maestro, filepos(arc_maestro) -1 );
        prod.stockD := prod.stockD - aux.cantidadVendida;
        write(arc_maestro, prod);
    end;

    close(arc_detalle);
end;

procedure actualizarMaestro (var arc_maestro: maestro; var arr_detalles: detalles);
var
    i: integer;

begin
    reset(arc_maestro);
    for i:= 1 to n do begin
        seek(arc_maestro, 0); //vuelvo al origen
        actualizar(arc_maestro, arr_detalles[i]);
    end;

    close(arc_maestro);
end;


var
    arcTxt : Text;
    arr_detalles: detalles;
    arc_maestro:maestro;

begin
    Assign (arr_detalles[1],'detalle1');
    Assign (arr_detalles[2],'detalle2');
    Assign (arr_detalles[3],'detalle3');
	Assign (arc_maestro,'maestro');
	actualizarMaestro (arc_maestro,arr_detalles);

    //Assign (arcTxt,'menosStock.txt');
	//hacerTxt (arc_maestro,arcTxt);
end.