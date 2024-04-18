program ej6;

uses crt;

CONST
valorAlto = 9999;

type
    reg_prenda=record
        cod, stock: integer;
        descripcion, colores, tipo: string;
        precio: double;
    end;

    maestro_prendas= file of reg_prenda;
    detalle_prendas= file of integer;

procedure leerMaestro (var arc_log:archivo; var dato:prendas);
begin
	if not eof (arc_log) then
		read (arc_log,dato)
	else
		dato.cod := valorAlto;
end;

procedure leerDatos (var p:reg_prenda);
begin
	with p do begin
		write ('INGRESE CODIGO (-1 para finalizar): '); readln (cod);
		if (cod <> -1) then begin
			write ('INGRESE STOCK: '); readln (stock);
			write ('INGRESE PRECIO: ');readln (precio);
		end;
		writeln ('');
	end;
end;

procedure imprimirPrenda (p:reg_prenda);
begin
	with p do begin
		writeln ('CODIGO: ',cod,' STOCK: ',stock);
		writeln (' ');
	end;
end;

procedure crearMaestro (var arc_log:maestro_prendas);
var
n:reg_prenda;
begin
	rewrite (arc_log);
	leerDatos (n);
	while (n.cod <> -1) do begin
		write (arc_log,n);
		leerDatos(n);
	end;
	close (arc_log);
end;

procedure crearDetalle (var arc_log:detalle_prendas);
var
n:reg_prenda;
begin
	rewrite (arc_log);
	write('INGRESE CODIGO: ');
    readln(n.cod);
	while (n.cod <> -1) do begin
		write (arc_log,n);
		write('INGRESE CODIGO: ');
        readln(n.cod);
	end;
	close (arc_log);
end;

procedure mostrarMaestro (var arc_log:maestro_prendas);
var
n:reg_prenda;
begin
	reset (arc_log);
	leerMaestro(arc_log,n);
	while (n.cod <> valorAlto) do begin
		imprimir (n);
		leerMaestro(arc_log,n);
	end;
	close (arc_log);
end;

procedure mostrarDetalle (var arc_log:maestro_prendas);
var
n:reg_prenda;
begin
	reset (arc_log);
	leerMaestro(arc_log,n);
	while (n.cod <> valorAlto) do begin
		writeln('CODIGO: ', n.cod);
		leerMaestro(arc_log,n);
	end;
	close (arc_log);
end;

var 
    arc_log,arch_nuevo: maestro_prendas;
    aEliminar: detalle_prendas;

begin
	Assign (arc_log,'maestro.dot');
	Assign (aEliminar,'detalle.dot');
	Assign (arch_nuevo,'arch_aux.dot');//lo usamos para compactar
    //compactarArchivo()
    //borrarPrendasLogicamente()
end;
