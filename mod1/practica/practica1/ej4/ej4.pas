program ej3;

const
    FIN = 'fin';

type
    empleado = record
        numero, edad:integer;
        apellido, nombre, DNI: string[12];
    end;

    archivo_empleados = file of empleado;


//asumo que me pasan abierto el archivo y este modulo no lo debe cerrar
procedure empleadoRegistrado(var encontre: boolean; numero: integer; var a1: archivo_empleados; pos: integer);
var
    emp: empleado;
begin
    seek(a1, 0); //buscamos desde el inicio
    encontre:=false;
    while(not eof(a1)) and (encontre=false) do begin
        read(a1, emp);
        if( emp.numero = numero ) then
            encontre := true;
    end;
    seek(a1, pos); //volvemos a la posicion original
end;

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
    close(a1);
end;

procedure agregarEmpleados();
var 
    a1:archivo_empleados;
    nombre_fisico: string;
    emp: empleado;
    contador: integer;
    repetido: boolean;
begin
    contador:=1;

    write('Ingrese nombre archivo: ');
    readln(nombre_fisico);
    assign(a1,nombre_fisico);
    reset(a1); //abrimos el archivo existente
    seek(a1, fileSize(a1));//nos paramos al final para agregar informacion

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

        empleadoRegistrado(repetido, emp.numero, a1, filePos(a1));
        if(repetido = false) then begin
            write(a1,emp);
        end
        else begin
            writeln('numero de empleado repetido!');
        end;

        contador:=contador+1;
        writeln('');
        write('Ingrese apellido del empleado ',contador,': ');
        readln(emp.apellido);
    end;

    close(a1);
end;

var
    opcion: integer;
    terminar: boolean;

begin
    terminar:=false;

    while(terminar=false) do begin
        writeln('Ingrese una de las siguiente opciones: ');
        writeln('1: cargar empleados');
        writeln('2: buscar empleados');
        writeln('3: agregar empleados');
        writeln('4: modificar empleado');
        writeln('5: exportar archivo empleados');
        writeln('6: exportar DNIs invalidos');
        writeln('7: FINALIZAR');

        write('-> ');
        readln(opcion);

        case opcion of
            1: cargarEmpleados();
            2: buscarEmpleados();
            3: agregarEmpleados();
            //4: modificarEmpleado();
            7: terminar:=true;
        end;
    end;
end.