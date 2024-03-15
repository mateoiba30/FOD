program ej3;

const
    FIN = 'fin';

type
    empleado = record
        numero, edad:integer;
        apellido, nombre, DNI: string[12];
    end;

type archivo_empleados = file of empleado;

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
    

end.