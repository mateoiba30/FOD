program ej2;

CONST
valorAlto = 9999;

type

rango = 0..1;

alumno = record
	codigo, cursadas, final:integer;
	apellido, nombre:string;
end;

materia = record
	codigo: integer;
	final:rango; //0 desaprobado 1 aprobado
	cursada:rango; //0 desaprobado 1 aprobado
end;

maestro = file of alumno;
detalle = file of materia;

procedure leer (var arc_detalle: detalle; var dato: materia);
begin
	if not eof (arc_detalle) then
		read (arc_detalle,dato)
	else
	dato.codigo:= valorAlto;
end;

procedure leerAl (var a:alumno);
begin
	with a do begin
		write ('INGRESE COD: '); readln (codigo);
		if (codigo <> -1) then begin
			write ('INGRESE APELLIDO: '); readln (apellido);
			write ('INGRESE NOMBRE: '); readln (nombre);
			write ('INGRESE CANTIDAD MATERIAS SIN FINAL: '); readln (cursadas);
			write ('INGRESE CANTIDAD DE MATERIAS CON FINAL: '); readln (final);
		end;
		writeln ('');
	end;
end;

procedure imprimirAl (a:alumno);
begin
	with a do begin
		writeln ('CODIGO: ',codigo);
		writeln ('APELLIDO: ',apellido);
		writeln ('NOMBRE: ',nombre);
		writeln ('SIN FINAL: ',cursadas);
		writeln ('CON FINAL: ',final);
	end;
end;

procedure leerDet (var d:materia);
begin
	with d do begin
		write ('INGRESE COD: '); readln (codigo);
		if (codigo <> -1) then begin
			write ('INGRESE SI APROBO CURSADA: '); readln (cursada);
			write ('INGRESE SI APROBO FINAL: '); readln (final);
		end;
		writeln ('');
	end;
end;

procedure imprimirDet (d:materia);
begin
	with d do begin
		writeln ('CODIGO: ',codigo);
		writeln ('CURSADA: ',cursada);
		writeln ('FINAL: ',final); 
	end;
end;

procedure crearMaestro (var arc_maestro:maestro);
var
a:alumno;
begin
	rewrite (arc_maestro);
	leerAl (a);
	while (a.codigo <> -1) do begin
		write (arc_maestro,a);
		leerAl(a);
	end;
	close (arc_maestro);
end;

procedure crearDetalle (var arc_detalle:detalle);
var
d:materia;
begin
	rewrite (arc_detalle);
	leerDet (d);
	while (d.codigo <> -1) do begin
		write (arc_detalle,d);
		leerDet(d);
	end;
	close (arc_detalle);
end;

procedure mostrarDetalle (var arc_detalle:detalle);
var
d:materia;
begin
	reset (arc_detalle);
	while not eof (arc_detalle) do begin
		read (arc_detalle,d);
		imprimirDet(d);
	end;
	close (arc_detalle);
end;

procedure mostrarMaestro (var arc_maestro:maestro);
var
a:alumno;
begin
	reset (arc_maestro);
	while not eof (arc_maestro) do begin
		read (arc_maestro,a);
		imprimirAl(a);
	end;
	close (arc_maestro);
end;

procedure pasarATxt (var arc_maestro:maestro; var arcTxt:Text);
var
a:alumno;
begin
	reset (arc_maestro);
	rewrite (arcTxt);
	while not eof (arc_maestro) do begin
		read (arc_maestro,a);
		if (a.cursadas - a.final > 4) then
		with a do begin
			writeln (arcTxt,codigo,'  ',apellido,'  ',nombre,'  ',cursadas,'  ',final);
		end;
	end;
	close (arc_maestro);
	close (arcTxt);
end;

procedure actualizarMaestro (var arc_maestro: maestro; var arc_detalle: detalle);
var
    m:materia;
    a, a_aux: alumno;

begin
    reset(arc_maestro);
    reset(arc_detalle);

    leer(arc_detalle, m);
    while(m.codigo <> valorAlto) do begin
        a_aux.codigo := m.codigo; //mejor que tener una variable de materia anterior
        a_aux.cursadas := 0;
        a_aux.final :=0;
        while (a_aux.codigo = m.codigo) do begin //conviene manipular directamente el registro que quiero cambiar y luego escribirlo 1 vez en el disco
            a_aux.cursadas := a_aux.cursadas + m.cursada - m.final;//aniado nuevas cursadas hechas y saco las que le pudo aprobar el final
            a_aux.final := a_aux.final + m.final;
            leer(arc_detalle, m);
        end;

        if not eof(arc_maestro) then
            read(arc_maestro, a);
        while ( (not eof(arc_maestro)) and (a.codigo < a_aux.codigo) )do //busco el alumno en el maestro
            read(arc_maestro, a);
        seek(arc_maestro, filepos(arc_maestro)-1);//me pase por 1
        a.cursadas += a_aux.cursadas;
        a.final += a_aux.final;
        write(arc_maestro, a);//guardo cambios, prestar atencion a la variable que mando en este write
    end;

    close(arc_maestro);
    close(arc_detalle);
end;

var
    arc_maestro:maestro;
    arc_detalle:detalle;
    arcTxt: Text;

begin
	Assign (arc_maestro,'maestro');
	Assign (arc_detalle,'detalle');
	Assign (arcTxt,'alumnos.txt');
    writeln('Creacion del maestro:');
	crearMaestro(arc_maestro);
	writeln ('Creacion del detalle:');
	crearDetalle(arc_detalle);
	writeln ('Maestro:');
	mostrarMaestro (arc_maestro);
	writeln ('Detalle:');
	mostrarDetalle (arc_detalle);
    writeln ('Nuevo maestro:');
    actualizarMaestro(arc_maestro, arc_detalle);
    mostrarMaestro(arc_maestro);
end.