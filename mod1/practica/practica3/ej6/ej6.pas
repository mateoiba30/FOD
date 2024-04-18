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

procedure leerMaestro (var arc_log:maestro_prendas; var dato:reg_prenda);
begin
	if not eof (arc_log) then
		read (arc_log,dato)
	else
		dato.cod := valorAlto;
end;

procedure leerDetalle (var arc_log:detalle_prendas; var n:integer);
begin
	if not eof (arc_log) then
		read (arc_log,n)
	else
		n := valorAlto;
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
n:integer;
begin
	rewrite (arc_log);
	write('INGRESE CODIGO (-1 para finalizar): ');
    readln(n);
	while (n <> -1) do begin
		write (arc_log,n);
		write('INGRESE CODIGO: ');
        readln(n);
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
		imprimirPrenda (n);
		leerMaestro(arc_log,n);
	end;
	close (arc_log);
end;

procedure mostrarDetalle (var arc_log:detalle_prendas);
var
    n:integer;
begin
	reset (arc_log);
	leerDetalle(arc_log, n);
	while (n <> valorAlto) do begin
		writeln('CODIGO: ', n);
		leerDetalle(arc_log,n);
	end;
	close (arc_log);
end;

procedure borrarPrendasLogicamente (var arc_log:maestro_prendas; var aEliminar:detalle_prendas);
var
    p:reg_prenda;
    n:integer;

begin
    reset(arc_log);
    reset(aEliminar);

    leerDetalle(aEliminar, n);
    while(n<>valorAlto) do begin //mientras no lleguemos al final del detalle

        leerMaestro(arc_log, p);
        while(p.cod < n) do//buscamos la prenda a eliminar
            leerMaestro(arc_log, p);
        seek(arc_log, filePos(arc_log)-1);//asumimos que el codigo del detalle se encuentra en el maestro y por eso al salir hemos encontrado la prenda a eliminar
        p.stock := p.stock*-1;
        write(arc_log, p);//guardo los cambios

        leerDetalle(aEliminar, n);
    end;

    close(arc_log);
    close(aEliminar);
end;

procedure compactarArchivo(var arc_log:maestro_prendas; var arch_nuevo:maestro_prendas);
var
    p:reg_prenda;

begin
    reset(arc_log);
    rewrite(arch_nuevo);
   
    leerMaestro(arc_log, p);
    while(p.cod <> valorAlto) do begin
        if(p.stock > 0) then
            write(arch_nuevo, p);
        leerMaestro(arc_log, p);
    end;
    
    close(arch_nuevo);
    close(arc_log);

    erase (arc_log);//borramos el archivo original del disco
	rename(arch_nuevo,'maestro.dot'); //asignamos el nombre original al archivo compactado
end;

var 
    arc_log,arch_nuevo: maestro_prendas;
    aEliminar: detalle_prendas;

begin
	Assign (arc_log,'maestro.dot');
	Assign (aEliminar,'detalle.dot');
	Assign (arch_nuevo,'arch_aux.dot');//lo usamos para compactar

    writeln('CREAR MAESTRO: ');
    writeln ('');
    crearMaestro(arc_log);
    writeln ('');
    writeln ('');
    writeln('CREAR DETALLE: ');
    crearDetalle(aEliminar);
    writeln ('');
    writeln ('');
    writeln ('MAESTRO');
	writeln ('');
	mostrarMaestro (arc_log);
	writeln ('DETALLE');
	writeln ('');
	mostrarDetalle(aEliminar);
   borrarPrendasLogicamente(arc_log, aEliminar);
    writeln ('');
    writeln ('MAESTRO con bajas logicas');
	writeln ('');
	mostrarMaestro (arc_log);
    writeln ('');
    compactarArchivo(arc_log, arch_nuevo);

    writeln ('MAESTRO con bajas fisicas');
	writeln ('');
	mostrarMaestro (arch_nuevo);
    
end.
