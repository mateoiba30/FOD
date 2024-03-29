program ej2;

CONST
    valorAlto = 9999;

type
    bool = 0..1;

    alumno_maestro=record
        apellido, nombre: string;
        codigo, cursadas, aprobadas: integer;
    end;

    maestro = file of alumno_maestro;

    alumno_detalle=record
        codigo: integer;
        cursada: bool;
        final:bool;
    end;

    detalle = file of alumno_detalle;

procedure leer (var arc_detalle: detalle; var dato: alumno_detalle);
begin
	if not eof (arc_detalle) then
		read (arc_detalle,dato)
	else
	dato.codigo:= valorAlto;
end;


procedure actualizarAlumno(var a_maestro: maestro; codigo: integer; cursadas: integer);
var
    alumno: alumno_maestro;
    encontrado: boolean;
begin
    encontrado := false;
    
    while (not encontrado) and (not eof(a_maestro)) do 
    begin
        read(a_maestro, alumno);
        
        if alumno.codigo = codigo then 
        begin
            encontrado := true;
            alumno.cursadas := alumno.cursadas + cursadas;
            alumno.aprobadas := alumno.aprobadas - cursadas;
            seek(a_maestro, filePos(a_maestro) - 1); // Retrocedemos un registro
            write(a_maestro, alumno); // Sobreescribimos el registro modificado
        end;
    end;

end;


procedure actualizarAlumnos(var a_maestro: maestro; var a_detalle: detalle);
var
    a_detalle_anterior, a_detalle_actual: alumno_detalle;
    cursadas: integer;

begin
    cursadas := 0;

    if not eof(a_detalle) then
        read(a_detalle, a_detalle_anterior);

    while not eof(a_detalle) do begin
        read(a_detalle, a_detalle_actual);

        if a_detalle_actual.codigo = a_detalle_anterior.codigo then begin
            cursadas := cursadas + a_detalle_actual.cursada; //vamos sumando la cantidad de cursadas, cada cual es 1 si es verdadera y restamos una si tuvimos una materia aprobada
            if a_detalle_actual.cursada = 0 then
                cursadas := cursadas -1;
        end
        else begin
            actualizarAlumno(a_maestro, a_detalle_anterior.codigo, cursadas);
            cursadas := 0;
            a_detalle_anterior := a_detalle_actual;
        end;

    end;

    actualizarAlumno(a_maestro, a_detalle_anterior.codigo, cursadas);

end;

procedure actualizarMaestro (var arc_maestro: maestro; var arc_detalle: detalle);
var
    m:alumno_detalle;
    a, a_aux: alumno_maestro;

begin
    leer(arc_detalle, m);
    while(m.codigo <> valorAlto) do begin
        a_aux.codigo := m.codigo; //mejor que tener una variable de materia anterior
        a_aux.cursadas := 0;
        a_aux.aprobadas :=0;
        while (a_aux.codigo = m.codigo) do begin //conviene manipular directamente el registro que quiero cambiar y luego escribirlo 1 vez en el disco
            a_aux.cursadas := a_aux.cursadas + m.cursada - m.final;//aniado nuevas cursadas hechas y saco las que le pudo aprobar el final
            a_aux.aprobadas := a_aux.aprobadas + m.final;
            leer(arc_detalle, m);
        end;

        if not eof(arc_maestro) then
            read(arc_maestro, a);
        while ( (not eof(arc_maestro)) and (a.codigo < a_aux.codigo) )do //busco el alumno en el maestro
            read(arc_maestro, a);
        seek(arc_maestro, filepos(arc_maestro)-1);//me pase por 1
        a.cursadas += a_aux.cursadas;
        a.aprobadas += a_aux.aprobadas;
        write(arc_maestro, a);//guardo cambios, prestar atencion a la variable que mando en este write
    end;
end;

var
    nombre_maestro, nombre_detalle : string;
    a_maestro: maestro;
    a_detalle: detalle;

begin

    write('Ingrese el nombre del archivo binario maestro a abrir:');
    readln(nombre_maestro);
    assign(a_maestro, nombre_maestro);
    reset(a_maestro); //abrimos el archivo

    write('Ingrese el nombre del archivo binario detalle a abrir:');
    readln(nombre_detalle);
    assign(a_detalle, nombre_detalle);
    reset(a_detalle); //abrimos el archivo

    actualizarMaestro(a_maestro, a_detalle);

    close(a_maestro);
    close(a_detalle);

end.