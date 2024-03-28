program ej1;

type 
    empleado=record
        codigo, nombre:string;
        comision: real;
    end;

    archivo_empleados = file of empleado;

var
    nombre_completo, nombre_compactado, codigo_anterior:string;
    a_completo, a_compactado: archivo_empleados;
    e, e_anterior: empleado;
    comision_acumulada:real;

begin

    write('Ingrese el nombre del archivo de empleados a abrir:');
    readln(nombre_completo);
    assign(a_completo, nombre_completo);
    reset(a_completo); //abrimos el archivo

    write('Ingrese el nombre del archivo de empleados a generar:');
    readln(nombre_compactado);
    assign(a_compactado, nombre_compactado);
    rewrite(a_compactado); //creamos el archivo


    if not eof(a_completo) then //tengo que tener la info del primer empleado para acumular la comision
        read(a_completo, e_anterior);

    while not eof(a_completo) do begin

        read(a_completo, e);
        if e.codigo = e_anterior.codigo then begin
            e_anterior.comision:=e_anterior.comision + e.comision;
        end
        else begin
            write(a_compactado, e_anterior);
            e_anterior:=e;
        end;

    end;

    write(a_compactado, e_anterior); // hay que escribir el empleado final

    close(a_completo);
    close(a_compactado);
end.