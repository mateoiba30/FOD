program ej3;

const
    FIN = 'fin';

type
    empleado = record
        numero, edad:integer;
        apellido, nombre, DNI: string[12];
    end;

type archivo_empleados = file of empleado;

procedure cargarEmpleados();
var 
    a1:archivo_empleados;
    nombre_fisico: string;
    emp: empleado;
    contador: integer;
begin
    contador:=1;

    write('Ingrese nombre archivo: ');
    readln(nombre_fisico);
    assign(a1,nombre_fisico);
    rewrite(a1);

    write('Ingrese apellido del empleado 1 (ingrese ',FIN,' para terminar): ');
    readln(emp.apellido);
   
    while (emp.apellido<>FIN) do begin
        write('Ingrese nombre del empleado: ');
        readln(emp.nombre);
        write('Ingrese dni del empleado: ');
        readln(emp.DNI);
        write('Ingrese edad del empleado: ');
        readln(emp.edad);
        write('Ingrese numero del empleado: ');
        readln(emp.numero);

        write(a1,emp);
        contador:=contador+1;
        writeln('');
        write('Ingrese apellido del empleado ',contador,': ');
        readln(emp.apellido);
    end;

    close(a1);
end;

procedure buscarEmpleados();
var
    nombre_fisico, condicion: string;
    a1: archivo_empleados; 
    emp: empleado;

begin

    write('Ingrese el nombre del archivo a abrir: ');
    readln(nombre_fisico);
    assign(a1, nombre_fisico);
    reset(a1); //abrimos el archivo existente

    write('Ingrese el nombre o apellido a buscar: ');
    readln(condicion);
    writeln('Coincidencias: ');
    while(not eof(a1)) do begin
        read(a1, emp);
        if(emp.nombre=condicion) or (emp.apellido=condicion) then
            writeln('nombre: ',emp.nombre,', apellido: ',emp.apellido,', DNI: ',emp.DNI,', edad: ',emp.edad,', numero: ',emp.numero);
    end;

    writeln('');
    writeln('Listado de todos los empleados: ');
    seek(a1, 0);
    while(not eof(a1)) do begin
        read(a1, emp);
        writeln('nombre: ',emp.nombre,', apellido: ',emp.apellido,', DNI: ',emp.DNI,', edad: ',emp.edad,', numero: ',emp.numero);
    end;

    writeln('');
    writeln('Listado de los empleados mayores de 70 anios: ');
    seek(a1, 0);
    while(not eof(a1)) do begin
        read(a1, emp);
        if(emp.edad>70) then
            writeln('nombre: ',emp.nombre,', apellido: ',emp.apellido,', DNI: ',emp.DNI,', edad: ',emp.edad,', numero: ',emp.numero);
    end;


end;


var
    opcion: integer;

begin

    writeln('Ingrese una de las siguiente opciones: ');
    writeln('1: cargar empleados');
    writeln('2: buscar empleados');
    write('-> ');
    readln(opcion);

    if(opcion=1) then begin
        cargarEmpleados();
    end
    else begin
        buscarEmpleados();
    end;

end.