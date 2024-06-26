program ej4;

uses
  SysUtils; //para el IntToStr

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
    emp: empleado;
    contador: integer;
    repetido: boolean;
    nombre_fisico: string;
    a1: archivo_empleados;
    
begin
    write('Ingrese el nombre del ARCHIVO a manipular: ');
    readln(nombre_fisico);
    assign(a1,nombre_fisico);
    contador:=1;

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

procedure buscarEmpleados();
var
    condicion: string;
    emp: empleado;
    nombre_fisico: string;
    a1: archivo_empleados;

begin
    write('Ingrese el nombre del ARCHIVO a manipular: ');
    readln(nombre_fisico);
    assign(a1,nombre_fisico);
    reset(a1); //abrimos el archivo existente

    write('Ingrese el nombre o apellido a buscar: ');
    readln(condicion);
    writeln('');
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
    writeln('');
end;

procedure agregarEmpleados();
var 
    emp: empleado;
    contador: integer;
    repetido: boolean;
    nombre_fisico: string;
    a1: archivo_empleados;

begin
    write('Ingrese el nombre del ARCHIVO a manipular: ');
    readln(nombre_fisico);
    assign(a1,nombre_fisico);

    contador:=1;

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

procedure modificarEdad();
var
    numero: integer;
    emp: empleado;
    nombre_fisico: string;
    a1: archivo_empleados;

begin
    write('Ingrese el nombre del ARCHIVO a manipular: ');
    readln(nombre_fisico);
    assign(a1,nombre_fisico);

    write('Ingrese el numero de empleado a modificar: ');
    readln(numero);
    reset(a1); //abrimos el archivo existente

    while(not eof(a1)) do begin
        read(a1, emp);
        if(emp.numero=numero) then begin
            write('Ingrese la nueva edad: ');
            readln(emp.edad);
            seek(a1, filePos(a1)-1); //en el read de arriba hemos pasado de empleado, pero ahora debemos volver
            write(a1, emp);
        end;
    end;

    close(a1);
end;

procedure exportarArchivo();
var
    txt: Text;
    emp: empleado;
    nombre_fisico: string;
    a1: archivo_empleados;

begin
    write('Ingrese el nombre del ARCHIVO a manipular: ');
    readln(nombre_fisico);
    assign(a1,nombre_fisico);

    assign(txt, 'todos_empleados.txt');
    rewrite(txt);
    reset(a1);

    writeln(txt, 'nombre, apellido, DNI, edad, numero');
    while(not eof(a1)) do begin
        read(a1, emp);
        writeln(txt, emp.nombre,',',emp.apellido,',',emp.DNI,',',IntToStr(emp.edad),',',IntToStr(emp.numero));
    end;

    close(a1);
    close(txt);
end;

procedure exportarInvalidos();
var
    txt: Text;
    emp: empleado;
    nombre_fisico: string;
    a1: archivo_empleados;

begin
    write('Ingrese el nombre del ARCHIVO a manipular: ');
    readln(nombre_fisico);
    assign(a1,nombre_fisico);

    assign(txt, 'faltaDNIEMpleado.txt');
    rewrite(txt);
    reset(a1);

    writeln(txt, 'nombre, apellido, DNI, edad, numero');
    while(not eof(a1)) do begin
        read(a1, emp);
        if(emp.DNI='00') then
            writeln(txt, emp.nombre,',',emp.apellido,',00,',IntToStr(emp.edad),',',IntToStr(emp.numero));
    end;

    close(txt);
    close(a1);
end;

procedure eliminarEmpleado();
var
    ult, emp: empleado;
    nombre_fisico: string;
    a1: archivo_empleados;
    numero: integer;

begin
    write('Ingrese el nombre del ARCHIVO a manipular: ');
    readln(nombre_fisico);
    assign(a1,nombre_fisico);

    write('Ingrese el numero de empleado a eliminar: ');
    readln(numero);
    reset(a1); //abrimos el archivo existente

    seek(a1, fileSize(a1)-1); //nos paramos al final para leer el ultimo empleado
    read(a1, ult);
    seek(a1, 0); //pararnos al inicio del archivo para volver a buscar

    while(not eof(a1)) do begin
        read(a1, emp);
        if(emp.numero=numero) then begin
            write('empleado eliminado');
            seek(a1, filePos(a1)-1); //en el read de arriba hemos pasado de empleado, pero ahora debemos volver
            write(a1, ult);//sobreescribimos el empleado a eliminar con el ultimo
            seek(a1, fileSize(a1)-1);//truncamos el archivo solo si encontramos el empleado a eliminar
            truncate(a1);   
        end;
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
        writeln('0: FINALIZAR');
        writeln('1: cargar empleados');
        writeln('2: buscar empleados');
        writeln('3: agregar empleados');
        writeln('4: modificar empleado');
        writeln('5: exportar archivo empleados');
        writeln('6: exportar DNIs invalidos');
        writeln('7: eliminar empleado');

        write('-> ');
        readln(opcion);

        case opcion of
            0: terminar:=true;
            1: cargarEmpleados();
            2: buscarEmpleados();
            3: agregarEmpleados();
            4: modificarEdad();
            5: exportarArchivo();
            6: exportarInvalidos();
            7: eliminarEmpleado();          
        end;
    end;
end.