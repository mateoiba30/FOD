program ej2;

uses crt;

const
    FIN = -1;
    valorAlto = 9999;
    NUMERO = 1000;
    ELIMINADO = '***';

type    
    asistente=record
        nro:integer;
        apeYNombre, email, telefono, dni: string;
    end;

    archivo_asistentes = file of asistente;

procedure leerArc (var arc_log:archivo_asistentes; var dato:asistente);
begin
	if not eof (arc_log) then
		read (arc_log,dato)
	else
		dato.nro := valorAlto;
end;

procedure asistenteRegistrado(var encontre: boolean; numero: integer; var a1: archivo_asistentes; pos: integer);
var
    asist: asistente;
begin
    seek(a1, 0); //buscamos desde el inicio
    encontre:=false;
    while(not eof(a1)) and (encontre=false) do begin
        read(a1, asist);
        if( asist.nro = numero ) then
            encontre := true;
    end;
    seek(a1, pos); //volvemos a la posicion original
end;

procedure cargarAsistentes(var a1: archivo_asistentes);
var
    contador: integer;
    repetido: boolean;
    asist: asistente;

begin
    contador:=1;
    rewrite(a1); //debemos crearlo y no conservar datos previos

    write('Ingrese el numero de asistente (ingrese ', FIN, ' para finalizar): ');
    readln(asist.nro);
    while(asist.nro <> FIN) do begin
        write('Ingrese el apellido y nombre del asistente: ');
        readln(asist.apeYNombre);
        write('Ingrese el email del asistente: ');
        readln(asist.email);
        write('Ingrese el telefono del asistente: ');
        readln(asist.telefono);
        write('Ingrese el DNI del asistente: ');
        readln(asist.dni);

        asistenteRegistrado(repetido, asist.nro, a1, filePos(a1));
        if(repetido = false) then begin
            write(a1,asist);
        end
        else begin
            writeln('numero de asistente repetido!');
        end;

        contador:=contador+1;
        writeln('');
        write('Ingrese numero del asistente ',contador,': ');
        readln(asist.nro);
    end;
    close(a1);
end;

procedure eliminarLogicamente(var a1: archivo_asistentes);
var
    asist: asistente;
begin
    reset(a1);
    leerArc(a1, asist);
    while(asist.nro <> valorAlto) do begin
        if(asist.nro < NUMERO) then begin
            asist.apeYNombre := ELIMINADO;
            seek(a1, filePos(a1) -1 );//volver para atrás para guardar los cambios
            write(a1, asist);
        end;
        leerArc(a1, asist);
    end;
    close(a1);
end;

procedure imprimir (a:asistente);
begin
	with a do begin
		if (apeYNombre <> ELIMINADO) then begin
			writeln ('NRO: ',nro,' APELLIDO Y NOMBRE: ',apeYNombre,' MAIL: ',email,' TELEFONO: ',telefono,' DNI: ',dni);
			writeln ('');
		end;
	end;
end;

procedure mostrarArchivo (var arc_log:archivo_asistentes);
var
    a:asistente;
begin
	reset (arc_log);
	while not eof (arc_log) do begin
		read (arc_log,a);
		imprimir(a);
	end;
	close (arc_log);
end;

var
    nombre_fisico: string;
    a1: archivo_asistentes;

begin
    write('Ingrese el nombre del ARCHIVO de asistentes a generar: ');
    readln(nombre_fisico);
    assign(a1, nombre_fisico);

    cargarAsistentes(a1);
    eliminarLogicamente(a1);
    mostrarArchivo(a1);
end.