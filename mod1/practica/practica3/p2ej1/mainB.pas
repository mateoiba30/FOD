program mainB;
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

procedure leerDetalle (var arc_detalle: detalle_diario; var dato:venta);
begin
	if not eof (arc_detalle) then
		read (arc_detalle,dato)
	else
		dato.cod:= valorAlto;
end;

procedure leerMaestro (var arc: maestro; var dato:producto);
begin
	if not eof (arc) then
		read (arc,dato)
	else
		dato.cod:= valorAlto;
end;

procedure actualizar(var arc_maestro: maestro; var arc_detalle: detalle_diario); //ahora los datos no están ordenados
var
    dato: venta;
    prod: producto;
    encontre:boolean;
begin
    //para el inciso A puedo recorrer el maestro, y busco dentro del detalle hasta encontrar una vez el código, ya que solo se modifica una vez y esto sería más eficiente -> en general tratar de recorrer por el maestro y luego por el detalle
    //en el caso del B NO debería recorrer el maestro y para cada cod recorrer todo el detalle. Debería recorrer todo el detalle y para cada cod recorrer el maestro hasta encontrar el dato
    reset(arc_detalle);

    leerDetalle(arc_detalle, dato);
    while(dato.cod <> valorAlto) do begin
        //debo acceder ya al maestro, no se si habrá otro dato con el mismo cod
        encontre:=false;
        leerMaestro(arc_maestro, prod);
        while ( (prod.cod<>valorAlto) and not(encontre)) do begin
            if(prod.cod = dato.cod) then begin
                encontre:=true;
                seek(arc_maestro, filepos(arc_maestro) -1 );
                prod.stockD := prod.stockD - dato.cantidadVendida;
                write(arc_maestro, prod);
                seek(arc_maestro, 0);//debo buscar desde el inicio la proxima
            end
            else begin
                leerMaestro(arc_maestro, prod);
            end;
        end;
        leerDetalle(arc_detalle, dato);
    end;
    close(arc_detalle);
end;

procedure actualizarMaestro (var arc_maestro: maestro; var arr_detalles: detalles);
var
    i: integer;

begin
    reset(arc_maestro);//como no hay orden, puedo recorrer de a un detalle a la vez
    for i:= 1 to n do begin
        seek(arc_maestro, 0); //vuelvo al origen
        actualizar(arc_maestro, arr_detalles[i]);
    end;

    close(arc_maestro);
end;

procedure generarTexto(var arc_maestro: maestro; var arcTxt: Text);
var
	prod: producto;

begin
	reset(arc_maestro);
	rewrite(arcTxt);

	while not eof(arc_maestro) do begin
		read(arc_maestro, prod);
		if (prod.stockD < prod.stockM) then
			writeln(arcTxt, 'codigo: ',prod.cod, ', nombre:', prod.nombre, ', descripcion: ', prod.des, ', stock disponible: ', prod.stockD, ', stock minimo: ', prod.stockM, ', precio: ', prod.precio:0:2); 
	end;

	close(arcTxt);
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

    assign (arcTxt,'menosStock.txt');
	generarTexto (arc_maestro,arcTxt);
    writeln('se ha generado el archivo con productos con menos stock del permitido');
end.