program creaderArchivos;

type

    bool = 0..1;

    a_maestro=record
        apellido, nombre: string;
        codigo, cursadas, aprobadas: integer;
    end;

    maestro = file of a_maestro;

    a_detalle=record
        codigo: integer;
        cursada: bool;
    end;

    detalle = file of a_detalle;

procedure crearBinarioMaestro(var a1: maestro; var txt: Text);
var
    alumno: a_maestro;

begin
    reset(txt);
    rewrite(a1); //creamos al archivo

    while(not eof(txt)) do begin
        readln(txt, alumno.codigo);
        readln(txt, alumno.apellido);
        readln(txt, alumno.nombre);
        readln(txt, alumno.cursadas);
        readln(txt, alumno.aprobadas);

        write(a1, alumno);
    end;
    close(a1);
    close(txt);
end;

procedure crearBinarioDetalle(var a1: detalle; var txt: Text);
var
    alumno: a_detalle;

begin
    reset(txt);
    rewrite(a1); //creamos al archivo

    while(not eof(txt)) do begin
        readln(txt, alumno.codigo);
        readln(txt, alumno.cursada);

        write(a1, alumno);
    end;
    close(a1);
    close(txt);
end;

procedure mostrarBinarioMaestro(var a1: maestro);
var
    alumno: a_maestro;

begin
    reset(a1);//lo abrimos en el incio del archivo

    while(not eof(a1)) do begin
        read(a1, alumno);
        writeln('codigo: ', alumno.codigo, ', apellido: ', alumno.nombre, ', nombre: ', alumno.nombre, ', cursadas: ', alumno.cursadas, ', aprobadas: ', alumno.aprobadas );
    end;

    close(a1);
end;

procedure mostrarBinarioDetalle(var a1: detalle);
var
    alumno: a_detalle;

begin
    reset(a1);//lo abrimos en el incio del archivo

    while(not eof(a1)) do begin
        read(a1, alumno);
        writeln('codigo: ', alumno.codigo, ', cursada: ', alumno.cursada);
    end;

    close(a1);
end;

var
    a1: maestro;
    a2: detalle;
    txt1: Text;

begin

    assign(a1, 'maestro_dat');
    assign(txt1, 'maestro_txt.txt');

    crearBinarioMaestro(a1, txt1);
    mostrarBinarioMaestro(a1);
{
    assign(a2, 'detalle_dat');
    assign(txt1, 'detalle_txt.txt');

    crearBinarioDetalle(a2, txt1);
    mostrarBinarioDetalle(a2);}
end.